//
//  NHFFmpegPlayer.m
//  NHPlayFramework
//
//  Created by nenhall on 2018/7/16.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHFFmpegPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <VideoToolbox/VideoToolbox.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libavcodec/avcodec.h>
#include <libswscale/swscale.h>
#import "NHAVKitTimer.h"
#import "NHAVKitDefine.h"


@interface NHFFmpegPlayer ()

@property (nonatomic, assign) float lastFrameTime;
@end

@implementation NHFFmpegPlayer
{
    AVFormatContext *nhFormatContext;
    AVCodecContext  *nhcodeContext;
    AVFrame         *nhFrame;
    AVStream        *nhStream;
    AVPacket        nhpacket;
    AVPicture       nhPicture;
    int             videoStream;
    double          fps;
    BOOL            isReleaseResources;
    
}

- (instancetype)initWithVideo:(NSString *)videoPath
{
    if (!(self = [super init])) {
        return nil;
    }
    
    if ([self initializeSource:[videoPath UTF8String]]) {
        return self;
    } else {
        return nil;
    }
}


- (BOOL)initializeSource:(const char *)filePath {
    
    if (filePath == NULL) {
        goto initError;
    }
    
    isReleaseResources = NO;
    
    AVCodec *pCode;
    
    /** 注册所有解码器 */
    avcodec_register_all();
    av_register_all();
    avformat_network_init();
    
    /** 打开视频文件 */
    int open = avformat_open_input(&nhFormatContext, filePath, NULL, NULL);
    
    if (open != 0) {
        NSLog(@"打开文件失败");
        goto initError;
    }
    
    /** 检测数据流 */
    int find_stream = av_find_best_stream(nhFormatContext, AVMEDIA_TYPE_VIDEO, -1, -1, &pCode, 0);
    videoStream = find_stream;
    if (find_stream < 0) {
        NSLog(@"没有打到第一个视频流");
        goto initError;
    }
    
    /** 获取视频流的编码上下文指针 */
    nhStream = nhFormatContext->streams[videoStream];
    
    nhcodeContext = nhStream->codec;
    
#if DEBUG
    /** 打印视频流信息 */
    av_dump_format(nhFormatContext, videoStream, filePath, 0);
    
#endif
    
    if (nhStream->avg_frame_rate.den  && nhStream->avg_frame_rate.num) {
        fps = av_q2d(nhStream->avg_frame_rate);
    } else {
        fps = 30;
    }
    
    /** 查找解码器 */
    pCode = avcodec_find_decoder(nhcodeContext->codec_id);
    if (pCode == NULL) {
        NSLog(@"没有找到解码器");
        goto initError;
    }
    
    /** 打开解码器 */
    int openav2 = avcodec_open2(nhcodeContext, pCode, NULL);
    if (openav2 < 0) {
        NSLog(@"打开解码器失败");
        goto initError;
    }
    
    /** 分配视频帧 */
    nhFrame = av_frame_alloc();
    
    _outputWidth = nhcodeContext->width;
    _outputHeight = nhcodeContext->height;
    
    return YES;
    
initError:NSLog(@"发生了一个错误呼呼");
    
    return NO;
}


-(void)play:(float)time {
    
    if (time <= 0) {
        _lastFrameTime = -1;
    } else {
        
    }
    
    [self seekTime:time];
    [NHAVKitTimer timerWithTimeInterval:1 / self.fps start:0 target:self action:@selector(displayNextFrame) repeats:YES async:NO onlyFlag:@"play"];
}

- (void)displayNextFrame {
    
    if (![self stepFrame]) {
        [NHAVKitTimer cancelTask:@"play"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(nhAVPlayComplete:)]) {
            [self.delegate nhAVPlayComplete:self];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(nhAVPlayCurrentMoveFrame:avPlay:)]) {
        [self.delegate nhAVPlayCurrentMoveFrame:self.currentImage avPlay:self];
    }
    
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    float frameTime = 1.0 / ([NSDate timeIntervalSinceReferenceDate] - startTime);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(nhAVPlayCurrentMoveFrameTime:nowTime:avPlay:)]) {
        [self.delegate nhAVPlayCurrentMoveFrameTime:frameTime nowTime:self.currentTime avPlay:self];
    }
}

- (void)stop {
    [NHAVKitTimer cancelTask:@"play"];
    [self releaseResources];
}

- (void)pause {
    [NHAVKitTimer cancelTask:@"play"];
}

- (void)redialPlay {
    [self initializeSource:[self.currentPath UTF8String]];
}

- (void)seekTime:(double)seconds {
    
    AVRational timeBase = nhFormatContext->streams[videoStream]->time_base;
    
    int64_t targetFrame = (int64_t)((double)timeBase.den / timeBase.num * seconds);
    
    avformat_seek_file(nhFormatContext,
                       videoStream,
                       0,
                       targetFrame,
                       targetFrame,
                       AVSEEK_FLAG_FRAME);
    
    avcodec_flush_buffers(nhcodeContext);
    
}

- (BOOL)stepFrame {
    int frameFinished = 0;
    while (!frameFinished  &&  av_read_frame(nhFormatContext, &nhpacket) >= 0) {
        if (nhpacket.stream_index == videoStream) {
            avcodec_decode_video2(nhcodeContext,
                                  nhFrame,
                                  &frameFinished,
                                  &nhpacket);
        }
    }
    
    if (frameFinished == 0 && isReleaseResources == NO) {
        [self releaseResources];
    }
    return frameFinished != 0;
}

- (void)replaceTheResource:(NSString *)videoPath {
    
    if (!isReleaseResources) {
        //        [self releaseResources];
    }
    self.currentPath = [videoPath copy];
    [self initializeSource:[videoPath UTF8String]];
}


#pragma mark - 重写属性访问方法
- (void)setOutputWidth:(int)outputWidth {
    if (_outputWidth == outputWidth) {
        return;
    }
    
    _outputWidth = outputWidth;
}

- (void)setOutputHeight:(int)outputHeight {
    if (_outputHeight == outputHeight) {
        return;
    }
    
    _outputHeight = outputHeight;
}

- (UIImage *)currentImage {
    if (!nhFrame->data[0]) {
        return nil;
    }
    
    return [self imageFormAVPicture];
}

- (double)duration {
    return (double)nhFormatContext->duration / AV_TIME_BASE;
}

- (double)currentTime {
    AVRational timeBase = nhFormatContext->streams[videoStream]->time_base;
    return nhpacket.pts * (double)timeBase.num / timeBase.den;
}

- (int)sourceWidth {
    return nhcodeContext->width;
}

- (int)sourceHeight {
    return nhcodeContext->height;
}

- (double)fps {
    return fps;
}

#pragma mark - 内部方法
- (UIImage *)imageFormAVPicture {
    
    avpicture_free(&nhPicture);
    avpicture_alloc(&nhPicture, AV_PIX_FMT_RGB24, _outputWidth, _outputHeight);
    struct SwsContext *imgConvertCtx = sws_getContext(nhFrame->width,
                                                      nhFrame->height,
                                                      AV_PIX_FMT_YUV420P,
                                                      _outputWidth,
                                                      _outputHeight,
                                                      AV_PIX_FMT_RGB24,
                                                      SWS_FAST_BILINEAR,
                                                      NULL, NULL, NULL);
    
    if (imgConvertCtx == nil) {
        return nil;
    }
    
    sws_scale(imgConvertCtx,
              nhFrame->data,
              nhFrame->linesize,
              0,
              nhFrame->height,
              nhPicture.data,
              nhPicture.linesize);
    
    sws_freeContext(imgConvertCtx);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreate(kCFAllocatorDefault,
                                  nhPicture.data[0],
                                  nhPicture.linesize[0] * _outputHeight);
    
    CGDataProviderRef providerData = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGImageRef imageRef = CGImageCreate(_outputWidth,
                                        _outputHeight, 8, 24,
                                        nhPicture.linesize[0],
                                        colorSpaceRef,
                                        bitmapInfo,
                                        providerData,
                                        NULL, NO,
                                        kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(providerData);
    CFRelease(data);
    
    return image;
}

- (void)releaseResources {
    NSLog(@"释放资源");
    
    isReleaseResources = YES;
    avpicture_free(&nhPicture);
    av_packet_free(&nhpacket);
    av_free(nhFrame);
    
    if (nhcodeContext) {
        avcodec_close(&nhcodeContext);
    }
    
    if (nhFormatContext) {
        avformat_close_input(&nhFormatContext);
    }
    
    avformat_network_deinit();
    
}

@end
