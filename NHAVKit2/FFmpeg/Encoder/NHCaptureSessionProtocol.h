//
//  NHCaptureSessionProtocol.h
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/18.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <AVFoundation/AVFoundation.h>


#if __has_include(<libavformat/avformat.h>)
#define ENABLE_FFMPEG 1
#endif

#if __has_include(<x264.h>)
#define ENABLE_X264 1
#endif

@class NHExportConfig;

NS_ASSUME_NONNULL_BEGIN
/** 推流工具选择 */
typedef enum : NSUInteger {
  NHPushStreamOptionalAVCapture, //deflaut
  NHPushStreamOptionalFFmpeg,
} NHPushStreamOptional;

/** 推流工具选择 */
typedef enum : NSUInteger {
  NHOutputTypeVideoStillImage, /**< 拍摄 + 静态拍照 */
  NHOutputTypeMovieFileStillImage, /**< 录制 + 静态拍照 */
  NHOutputTypeVideoData, /**< 拍摄 */
  NHOutputTypeMovieFile, /**< 录制 */
  NHOutputTypeStillImage, /**< 静态拍照 */
} NHOutputType;

/** 推流状态 */
typedef enum : NSUInteger {
    NHPushStreamStatusUnknown,
    NHPushStreamStatusPushing,/**< 推流中 */
    NHPushStreamStatusEnd,/**< 推流结束 */
} NHPushStreamStatus;


@protocol NHCaptureSessionProtocol <NSObject>

@optional

/// 已经开始将视频写入到文件
- (void)captureShouldBeginWriteMovieToFileAtURL:(NSURL *)fileURL;

/// 视频写入到文件失败
/// @param error 失败原因
- (void)captureDidFailedWriteMovieToFile:(NSError *)error;

/// 完成视频写入文件操作
/// @param outputURL 输出路径(此路径既你设置的outputURL)
- (void)captureDidFinishWriteMovieToFile:(NSURL *)outputURL;

/// SampleBuffer输出
/// @param sampleBuffer sampleBuffer description
/// @param outputType outputType description
- (void)captureDidOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer outputType:(NHOutputType)outputType;

/// 导出视频
/// @param url 导出URL
/// @param config 导出配置
/// @param progress 导出进度
/// @param completed 完成回调
/// @param save 是否在导出成功的同时保存到相册
- (void)exportVidelWithUrl:(NSURL *)url
              exportConfig:(NHExportConfig *)config
                  progress:(void (^)(CGFloat value))progress
                 completed:(void (^)(NSURL *exportURL, NSError *error))completed
          savedPhotosAlbum:(BOOL)save;

/**
 获取视频当前图片(截屏)

 @param newImage 返回新的图片
 @param save 是否同时保存到相册
 */
- (void)captureStillImage:(void (^)(UIImage *image))newImage savedPhotosAlbum:(BOOL)save;



@end


#pragma mark - NHFFmpegSessionProtocol
/****************************** NHFFmpegSessionProtocol   *************************/
/****************************** NHFFmpegSessionProtocol   *************************/
/****************************** NHFFmpegSessionProtocol   *************************/

@protocol NHFFmpegSessionProtocol <NSObject>


@end

NS_ASSUME_NONNULL_END