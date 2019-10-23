//
//  NHFFmpegPlayer.h
//  NHPlayFramework
//
//  Created by nenhall on 2018/7/16.
//  Copyright © 2018年 nenhall_studio. All rights reserved.
//
/**
 - (void)nhAVPlayCurrentMoveFrameTime:(double)frameTime nowTime:(double)nowTime avPlay:(NHAVPlay *)avPlay {
 NSLog(@"frameTime:%f---nowTime:%f",frameTime,nowTime);
 _lastPlayTime = nowTime;
 
 self.time.text = [self dealTime:nowTime];
 if (_lastFrameTime < 0) {
 _lastFrameTime = frameTime;
 } else {
 _lastFrameTime = NH_LERP(frameTime, _lastFrameTime, 0.8);
 }
 self.fps.text = [NSString stringWithFormat:@"fps：%0.f",_lastFrameTime];
 }
 */

#import "NHBasePlayer.h"
#import "NHPlayerProtocol.h"



#define NH_LERP(A,B,C) ((A)*(1.0-C)+(B)*C)


NS_ASSUME_NONNULL_BEGIN

@class NHFFmpegPlayer;
@protocol NHFFmpegPlayerDelegate <NSObject>

- (void)nhAVPlayComplete:(NHFFmpegPlayer *)avPlay;

- (void)nhAVPlayCurrentMoveFrame:(UIImage *)image avPlay:(NHFFmpegPlayer *)avPlay;

- (void)nhAVPlayCurrentMoveFrameTime:(double)time nowTime:(double)nowTime avPlay:(NHFFmpegPlayer *)avPlay;

@end


@interface NHFFmpegPlayer : NHBasePlayer

#ifdef ENABLE_FFMPEG
@property (nonatomic, weak) id<NHFFmpegPlayerDelegate> delegate;
@property (nonatomic, copy) NSString *currentPath;

/** 解码后的image */
@property (nonatomic, strong, readonly) UIImage *currentImage;

/** 输出图像大小。默认设置为源大小 */
@property (nonatomic, assign) int outputWidth;
/** 输出图像大小。默认设置为源大小 */
@property (nonatomic, assign) int outputHeight;

/* 视频的frame高度 */
@property (nonatomic, assign, readonly) int sourceWidth;
@property (nonatomic, assign, readonly) int sourceHeight;

/* 视频的长度，秒为单位 */
@property (nonatomic, assign, readonly) double duration;

/* 视频的当前秒数 */
@property (nonatomic, assign, readonly) double currentTime;

/* 视频的帧率 */
@property (nonatomic, assign, readonly) double fps;

/**
 初始化
 
 @param videoPath 视频地址
 */
- (instancetype)initWithVideo:(NSString *)videoPath;

/** 寻求最近的关键帧在指定的时间 */
- (void)seekTime:(double)seconds;

/** 从视频流中读取下一帧。返回NO，如果没有帧读取（视频） */
- (BOOL)stepFrame;

/** 播放 */
- (void)play:(float)time;

/** 停止 */
- (void)stop;

/** 暂停 */
- (void)pause;

/** 重播 */
- (void)redialPlay;

/** 切换资源 */
- (void)replaceTheResource:(NSString *)videoPath;


#endif

@end

NS_ASSUME_NONNULL_END
