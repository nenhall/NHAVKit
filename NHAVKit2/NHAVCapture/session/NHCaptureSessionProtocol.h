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
- (void)capturedidOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer outputType:(NHOutputType)outputType;

- (void)captureOutputDidStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnection:(NSArray<AVCaptureConnection *> *)connections;


- (void)captureOutputDidFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error;


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
