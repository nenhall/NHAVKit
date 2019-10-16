//
//  NHAVCaptureSession.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/14.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@interface NHAVCaptureSession : NHBeasSession
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (nonatomic, weak) id<NHCaptureSessionProtocol> delegate;
@property (nonatomic, assign) NHImageFilterType filterType;

+ (instancetype)sessionWithPreviewView:(UIView *)preview outputType:(NHOutputType)outputType;

///**
// 开始录制264格式视频
// */
//- (void)startRecordX264;

/// 开始录制视频写入到文件
/// @param outputURL 输出文件路径
- (void)startWriteMovieToFileWithOutputURL:(NSURL *)outputURL;

/// 停止写入
- (void)stopWriteMovie;




@end

NS_ASSUME_NONNULL_END
