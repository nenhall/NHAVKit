//
//  NHGifTool.h
//  NHAVFoundation
//
//  Created by nenhall_work on 2018/8/15.
//  Copyright © 2018年 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef DEBUG
#define kNSLog(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#define kNSLog(...)
#endif

typedef void(^NHInterceptBlock)(NSError *error, NSURL *url);

@interface NHGifTool : NSObject

/**
 截取视频
 
 @param videoUrl 视频的URL
 @param outPath 输出路径
 @param outputFileType 输出视频格式
 @param videoRange 截取视频的范围
 @param interceptBlock 视频截取的回调
 */
- (void)interceptVideoAndVideoUrl:(NSURL *)videoUrl
                      withOutPath:(NSString *)outPath
                   outputFileType:(NSString *)outputFileType
                            range:(NSRange)videoRange
                        intercept:(NHInterceptBlock)interceptBlock;


/**
 本地视频生成GIF图
 
 @param videoURL 视频的路径URL
 @param loopCount 播放次数 0即无限循环
 @param time 每帧的时间间隔 默认0.25s
 @param imagePath 存放GIF图片的文件路径
 @param completeBlock 完成的回调
 */
- (void)createGIFfromURL:(NSURL*)videoURL loopCount:(int)loopCount delayTime:(CGFloat )time gifImagePath:(NSString *)imagePath complete:(NHInterceptBlock)completeBlock;

@end
