//
//  NHFFmpegSession.m
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/14.
//  Copyright © 2019 neghao. All rights reserved.
//

#import "NHFFmpegSession.h"


#ifdef ENABLE_FFMPEG

#include <libavformat/avformat.h>
#include <libavformat/avio.h>
#include <libavutil/opt.h>
#include <libavutil/time.h>

//#include <libavutil/mathematics.h>
//#include <libavutil/time.h>

@interface NHFFmpegSession () {
    AVOutputFormat *_outputFmt;
    AVFormatContext *_ifmt_ctx;
    AVFormatContext *_ofmt_ctx;
    AVPacket _packet;
    int _ret;
}

@end

#endif

@implementation NHFFmpegSession

#ifdef ENABLE_FFMPEG

- (void)decoderFormCamera {
    
}

/** 从本地的文件中获取音视频流 */
- (void)decoderFormLocalFile:(NSString *)filePath {
    dispatch_async(dispatch_queue_create("push", 0), ^{
        [self _decoderFormLocalFile:filePath];
    });
}

- (void)_decoderFormLocalFile:(NSString *)filePath {
    
    //判定文件路径
    BOOL isFilePath = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isFilePath) {
        NSLog(@"文件路径错误！！！");
        return;
    }
    
    _status = NHPushStreamStatusPushing;
    
    char input_str_full[500] = {0};
    char output_str_full[500] = {0};
    sprintf(input_str_full, "%s", [filePath UTF8String]);
    sprintf(output_str_full, "%s", [_outputURL.absoluteString UTF8String]);
    
    //初始化相关对象
    _ifmt_ctx = NULL;
    _ofmt_ctx = NULL;
    _outputFmt = NULL;
    
    
    char in_file_name[500] = {0};
    char out_file_name[500] = {0};
    int frameIndex = 0;
    int videoIndex = -1;
    int64_t startTime = 0;
    
    
    strcpy(in_file_name, input_str_full);
    strcpy(out_file_name, output_str_full);
    
    
    /** register decoder */
    av_register_all();
    //    av_register_output_format(_outputFmt);
    //    av_register_hwaccel(<#AVHWAccel *hwaccel#>);
    //    av_register_codec_parser(<#AVCodecParser *parser#>);
    //    av_register_bitstream_filter(<#AVBitStreamFilter *bsf#>);
    //    avcodec_register(<#AVCodec *codec#>);
    //    av_register_input_format(<#AVInputFormat *format#>);
    //    ffurl_register_protocol();
    
    
    /** initialize network */
    avformat_network_init();
    
    /** input */
    _ret = avformat_open_input(&_ifmt_ctx, in_file_name, 0, 0);
    if (_ret < 0) {
        printf( "Could not open input file.");
        goto end;
    }
    
    _ret = avformat_find_stream_info(_ifmt_ctx, 0);
    if (_ret < 0) {
        printf( "Failed to retrieve input stream information");
        goto end;
    }
    
    for (int i = 0; i < _ifmt_ctx->nb_streams; i++) {
        /** 视音频流 */
        AVStream *in_stream = _ifmt_ctx->streams[i];
        AVCodecContext *codecContext = in_stream->codec;
        if (codecContext->codec_type == AVMEDIA_TYPE_VIDEO) {
            //查找音频
            videoIndex = i;
            break;
        }
    }
    
    av_dump_format(_ifmt_ctx, 0, in_file_name, 0);
    
    
    /** output */
    // RTMP
    avformat_alloc_output_context2(&_ofmt_ctx, NULL, "flv", out_file_name);
    
    if (!_ofmt_ctx) {
        printf( "Could not create output context\n");
        _ret = AVERROR_UNKNOWN;
        goto end;
    }
    
    _outputFmt = _ofmt_ctx->oformat;
    
    /** ergodic input stream */
    for (int i = 0; i < _ifmt_ctx->nb_streams; i++) {
        //创建输出码流的AVStream
        AVStream *i_stream = _ifmt_ctx->streams[i];
        AVCodec *i_codec = avcodec_find_decoder(i_stream->codecpar->codec_id);
        
        AVStream *o_stream = avformat_new_stream(_ofmt_ctx, i_codec);
        AVCodec *o_codec = avcodec_find_decoder(o_stream->codecpar->codec_id);
        
        if (!o_stream) {
            printf( "Failed allocating output stream\n");
            _ret = AVERROR_UNKNOWN;
            goto end;
        }
        
        //将输入视频/音频的参数拷贝至输出视频/音频的AVCodecContext结构体
        // avcodec_copy_context 被avcodec_parameters_to_context、avcodec_parameters_from_context替代
        //        _ret = avcodec_copy_context(o_stream->codec, i_stream->codec);
        AVCodecContext *pCodecCtx = avcodec_alloc_context3(o_codec);
        avcodec_parameters_to_context(pCodecCtx, i_stream->codecpar);
        
        if (_ret < 0) {
            printf( "Failed to copy context from input to output stream codec context\n");
            goto end;
        }
        pCodecCtx->codec_tag = 0;
        
        if (_ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER) {
            pCodecCtx->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
        }
        
        _ret = avcodec_parameters_from_context(o_stream->codecpar, pCodecCtx);
        if (_ret < 0) {
            printf( "Failed to copy context from input to output stream codec context 2\n");
            goto end;
        }
        
    }
    
    
    /** dump format */
    av_dump_format(_ofmt_ctx, 0, out_file_name, 1);
    
    /** open output url */
    if (!(_outputFmt->flags & AVFMT_NOFILE)) {
        _ret = avio_open(&_ofmt_ctx->pb, out_file_name, AVIO_FLAG_WRITE);
        if (_ret < 0) {
            printf( "Could not open output URL '%s'", out_file_name);
            goto end;
        }
    }
    
    //写文件头（对于某些没有文件头的封装格式，不需要此函数。比如说MPEG2TS）
    _ret = avformat_write_header(_ofmt_ctx, NULL);
    if (_ret < 0) {
        printf( "Error occurred when opening output URL\n");
        goto end;
    }
    
    startTime = av_gettime();
    
    while (1) {
        
        AVStream *in_stream, *out_stream;
        
        /** get in avpacket */
        _ret = av_read_frame(_ifmt_ctx, &_packet);
        if (_ret < 0) {
            break;
        }
        
        /** simple write pts */
        if (_packet.pts == AV_NOPTS_VALUE) {
            /** wirte pts */
            AVRational time_base = _ifmt_ctx->streams[videoIndex]->time_base;
            
            //duration between 2 frames(us)
            int64_t calc_duration = (double)AV_TIME_BASE / av_q2d(_ifmt_ctx->streams[videoIndex]->r_frame_rate);
            
            // paramaters
            // print time
            _packet.pts = (double)(frameIndex * calc_duration) / (double)(av_q2d(time_base) * AV_TIME_BASE);
            // decode time
            _packet.dts = _packet.pts;
            // continue time
            _packet.duration = (double)calc_duration / (double)(av_q2d(time_base) * AV_TIME_BASE);
        }
        
        // important:delay
        // stream_index:标识该AVPacket所属的视频/音频流
        if (_packet.stream_index == videoIndex) {
            AVRational time_base = _ifmt_ctx->streams[videoIndex]->time_base;
            AVRational time_base_q = {1, AV_TIME_BASE};
            int64_t pts_time = av_rescale_q(_packet.dts, time_base, time_base_q);
            int64_t now_time = av_gettime() - startTime;
            
            if (pts_time > now_time) {
                av_usleep((int)(pts_time - now_time));
            }
        }
        
        if (_ifmt_ctx == NULL || _ofmt_ctx == NULL) {
            goto end;
        }
        
        in_stream = _ifmt_ctx->streams[_packet.stream_index];
        out_stream = _ofmt_ctx->streams[_packet.stream_index];
        
        
        /** copy packet */
        _packet.pts = av_rescale_q_rnd(_packet.pts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
        _packet.dts = av_rescale_q_rnd(_packet.dts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
        _packet.duration = av_rescale_q(_packet.duration, in_stream->time_base, out_stream->time_base);
        
        //该数据在媒体流中的字节偏移量
        _packet.pos = -1;
        
        if (_packet.stream_index == videoIndex) {
            printf("Send %8d video frames to output URL\n",frameIndex);
            frameIndex ++;
        }
        
        //将AVPacket（存储视频压缩码流数据）写入文件。
        _ret = av_interleaved_write_frame(_ofmt_ctx, &_packet);
        
        if (_ret < 0) {
            printf("Error muxing packet\n");
            break;
        }
        
        //                AVPacket *packet = &(_packet);
        //                av_packet_free(&packet);
        av_free_packet(&_packet);
    }
    
    //写文件尾（对于某些没有文件头的封装格式，不需要此函数。比如说MPEG2TS）
    av_write_trailer(_ofmt_ctx);
    
    
end:
    [self stopPushStream];
    NSLog(@"error stop Push Stream");
    return;
}


- (void)stopPushStream {
    
    _status = NHPushStreamStatusEnd;
    
    avformat_close_input(&_ifmt_ctx);
    if (_ofmt_ctx && !(_ofmt_ctx->flags && AVFMT_NOFILE)) {
        avio_close(_ofmt_ctx->pb);
    }
    
//    avformat_free_context(_ofmt_ctx);
    if (_ret < 0 && _ret != AVERROR_EOF) {
        printf("error occurred . \n");
        return;
    }
}


//avformat_free_context内部实现部份
//void avformat_free_context(AVFormatContext *s)
//{
//    int i;
//
//
//    if (!s)
//        return;
//
//
//    av_opt_free(s);
//    if (s->iformat && s->iformat->priv_class && s->priv_data)
//        av_opt_free(s->priv_data);
//    if (s->oformat && s->oformat->priv_class && s->priv_data)
//        av_opt_free(s->priv_data);
//
//
//    for (i = s->nb_streams - 1; i >= 0; i--) {
//        ff_free_stream(s, s->streams[i]);
//    }
//    for (i = s->nb_programs - 1; i >= 0; i--) {
//        av_dict_free(&s->programs[i]->metadata);
//        av_freep(&s->programs[i]->stream_index);
//        av_freep(&s->programs[i]);
//    }
//    av_freep(&s->programs);
//    av_freep(&s->priv_data);
//    while (s->nb_chapters--) {
//        av_dict_free(&s->chapters[s->nb_chapters]->metadata);
//        av_freep(&s->chapters[s->nb_chapters]);
//    }
//    av_freep(&s->chapters);
//    av_dict_free(&s->metadata);
//    av_freep(&s->streams);
//    av_freep(&s->internal);
//    flush_packet_queue(s);
//    av_free(s);
//}


#endif

@end
