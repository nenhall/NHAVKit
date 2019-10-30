//
//  NHAVCaptureSession.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/14.
//  Copyright © 2019 neghao. All rights reserved.
//


#import "NHBeasSession.h"


NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    NHImageFilterBilateralFilter,  /**< 磨皮 (default)*/
    NHImageFilterExposureFilter,   /**< 曝光 */
    NHImageFilterBrightnessFilter, /**< 美白 */
    NHImageFilterSaturationFilter, /**< 饱和 */
    NHImageFilterSystemOriginal,   /**< 系统原生相机效果 */
    NHImageFilterCustomFilter,
} NHImageFilterType;


@interface NHAVCapture : NHBeasSession
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (nonatomic, weak) id<NHCaptureSessionProtocol> delegate;
@property (nonatomic, assign) NHImageFilterType filterType;

/// 摄像头位置
@property (nonatomic, assign, readonly) AVCaptureDevicePosition cameraPosition;

/// 初始化
/// @param preview 预览层
/// @param outputType 文件输出类型
+ (instancetype)sessionWithPreviewView:(UIView *)preview outputType:(NHOutputType)outputType;

/// 开始录制视频写入到文件
/// @param outputURL 输出文件路径
- (void)startWriteMovieToFileWithOutputURL:(NSURL *)outputURL;

/// 完成录制
- (void)finishRecording;

/// 取消录制
- (void)cancelRecording;

/// 暂停录制
- (void)pauseRecording;

/// 恢复录制
- (void)resumeRecording;


@end

NS_ASSUME_NONNULL_END
