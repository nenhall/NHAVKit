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
- (void)captureDidBeginWriteMovieToFile;

/// 视频写入到文件失败
/// @param error 失败原因
- (void)captureWriteMovieToFileFailed:(NSError *)error;

/// 完成视频写入文件操作
/// @param outputURL 输出路径(此路径既你设置的outputURL)
- (void)captureDidFinishWriteMovieToFile:(NSURL *)outputURL;

/// SampleBuffer输出
/// @param sampleBuffer sampleBuffer description
/// @param outputType outputType description
- (void)captureDidOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer outputType:(NHOutputType)outputType;

/// 开始录制视频
/// @param fileURL 输出文件路径
/// @param connections AVCaptureConnection description
- (void)captureOutputDidStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnection:(NSArray<AVCaptureConnection *> *)connections;

/// 录制完成
/// @param outputFileURL outputFileURL description
/// @param connections connections description
/// @param error error description
- (void)captureOutputDidFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error;


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

@protocol NHFFmpegSessionProtocol <NSObject>


@end

NS_ASSUME_NONNULL_END
