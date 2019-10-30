//
//  NHX264Encoder.m
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/18.
//  Copyright © 2019 neghao. All rights reserved.
//

#import "NHH264Encoder.h"
#import "NHWriteH264Stream.h"

#include <libavutil/opt.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <libavutil/imgutils.h>


@interface NHH264Encoder ()
@property (strong, nonatomic) NHVideoConfiguration *videoConfiguration;

@end

@implementation NHH264Encoder
{
    AVCodecContext                      *_pCodecCtx;
    AVCodec                             *_pCodec;
    AVPacket                             _packet;
    AVFrame                             *_pFrame;
    int                                  _pictureSize;
    int                                  _frameCounter;
    int                                  _frameWidth; // 编码的图像宽度
    int                                  _frameHeight; // 编码的图像高度
}

- (instancetype)initWithVideoConfiguration:(NHVideoConfiguration *)videoConfiguration {
    self = [super init];
    if (self) {
        _videoConfiguration = videoConfiguration;
        [self setupEncoder];
    }
    return self;
}

- (void)setupEncoder {
    // 注册FFmpeg所有编解码器
    avcodec_register_all();

    _frameCounter = 0;
    _frameWidth = _videoConfiguration.videoSize.width;
    _frameHeight = _videoConfiguration.videoSize.height;
    
    // Param that must set
    _pCodecCtx = avcodec_alloc_context3(_pCodec);
    _pCodecCtx->codec_id = AV_CODEC_ID_H264;
    _pCodecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
    _pCodecCtx->pix_fmt = AV_PIX_FMT_YUV420P;
    _pCodecCtx->width = _frameWidth;
    _pCodecCtx->height = _frameHeight;
    _pCodecCtx->time_base.num = 1;
    _pCodecCtx->time_base.den = _videoConfiguration.frameRate;
    _pCodecCtx->bit_rate = _videoConfiguration.bitrate;
    _pCodecCtx->gop_size = _videoConfiguration.maxKeyframeInterval;
    _pCodecCtx->qmin = 10;
    _pCodecCtx->qmax = 51;
    //    pCodecCtx->me_range = 16;
    //    pCodecCtx->max_qdiff = 4;
    //    pCodecCtx->qcompress = 0.6;
    // Optional Param
    //    pCodecCtx->max_b_frames = 3;
    
    
    // Set Option
    AVDictionary *param = NULL;
    if (_pCodecCtx->codec_id == AV_CODEC_ID_H264) {
        av_dict_set(&param, "preset", "slow", 0);
        av_dict_set(&param, "tune", "zerolatency", 0);
        //        av_dict_set(&param, "profile", "main", 0);
    }
    
    _pCodec = avcodec_find_encoder(_pCodecCtx->codec_id);
    if (!_pCodec) {
        NSLog(@"Can not find encoder!");
        return;
    }
    
    if (avcodec_open2(_pCodecCtx, _pCodec, &param) < 0) {
        NSLog(@"Failed to open encoder!");
        return;
    }
    
    _pFrame = av_frame_alloc();
    _pFrame->width = _frameWidth;
    _pFrame->height = _frameHeight;
    _pFrame->format = AV_PIX_FMT_YUV420P;
    
    // old api
    avpicture_fill((AVPicture *)_pFrame , NULL, _pCodecCtx->pix_fmt, _pCodecCtx->width, _pCodecCtx->height);
    _pictureSize = avpicture_get_size(_pCodecCtx->pix_fmt, _pCodecCtx->width, _pCodecCtx->height);

//    av_image_fill_arrays(_pFrame->data, _pFrame->linesize, NULL, AV_PIX_FMT_YUV420P, _pCodecCtx->width, _pCodecCtx->height, 1);
//    _pictureSize = av_image_get_buffer_size(_pCodecCtx->pix_fmt, _pCodecCtx->width, _pCodecCtx->height, 1);

    av_new_packet(&_packet, _pictureSize);
    
}

- (void)encoding:(CVPixelBufferRef)pixelBuffer timestamp:(CGFloat)timestamp {
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    // get buffer info
    UInt8 *pY = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    UInt8 *pUV = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    size_t pYBytes = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    size_t pUVBytes = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);
    
    // buffer to store YUV with layout YYYYYYYYUUVV
    UInt8 *pYUV420P = (UInt8 *)malloc(width * height * 3 / 2);
    
    /* convert NV12 data to YUV420*/
    UInt8 *pU = pYUV420P + (width * height);
    UInt8 *pV = pU + (width * height / 4);
    for (int i = 0; i < height; i++) {
//        memcpy(void *__dst, const void *__src, size_t __n)
        memcpy(pYUV420P + i * width, pY + i * pYBytes, width);
    }
    
    for (int j = 0; j < height / 2; j++) {
        for (int i = 0; i < width / 2; i++) {
            *(pU++) = pUV[i<<1];
            *(pV++) = pUV[(i<<1) + 1 ];
        }
        pUV += pUVBytes;
    }
    
    
    //Read raw YUV data
    _pFrame->data[0] = pYUV420P;                                //Y
    _pFrame->data[1] = _pFrame->data[0] + width * height;       //U
    _pFrame->data[2] = _pFrame->data[1] + (width * height) / 4; //V
    
    //PTs
    _pFrame->pts = _frameCounter;
    
    // Encode
    int  got_picture = 0;
    if (!_pCodecCtx) {
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        return;
    }
    
    int ret = avcodec_encode_video2(_pCodecCtx, &_packet, _pFrame, &got_picture);
    if (ret < 0) {
        NSLog(@"Failed to encode!");
        return;
    }
    
    if (got_picture == 1) {
        NSLog(@"Succeed to encode frame: %5d\tsize:%5d", _frameCounter, _packet.size);
        _frameCounter++;
        NHWriteH264Stream *writeH264Stream = self.outputDelegate;
        [writeH264Stream writeFrame:_packet streamIndex:_packet.stream_index];
//        [writeH264Stream writeData:_packet.data size:_packet.size index:_packet.stream_index];
        av_free_packet(&_packet);
    }
    
    free(pYUV420P);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
}

- (void)teardown {
    NHWriteH264Stream *writeH264Streaming = self.outputDelegate;
    writeH264Streaming = nil;
    
    avcodec_close(_pCodecCtx);
    av_free(_pFrame);
    _pCodecCtx = NULL;
    _pFrame = NULL;
    
}

#pragma mark -- NHX264OutputProtocol
- (void)setOutput:(id<NHX264OutputProtocol>)output {
    self.outputDelegate = output;
}


@end
