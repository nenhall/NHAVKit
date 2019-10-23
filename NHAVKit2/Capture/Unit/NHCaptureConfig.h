//
//  NHCaptureConfig.h
//  NHCaptureFramework
//
//  Created by nenhall on 2019/4/16.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHCaptureConfig : NSObject


/**
 视频分辨率
 @param preset
 AVCaptureSessionPresetiFrame1280x720;
 AVCaptureSessionPresetiFrame960x540;
 AVCaptureSessionPreset3840x2160;
 AVCaptureSessionPreset1920x1080;
 AVCaptureSessionPreset1280x720;
 AVCaptureSessionPreset960x540;
 AVCaptureSessionPreset640x480;
 */
- (void)setCaptureSessionPreset:(const NSString *)preset;

/** 设置视频的方向 */
- (void)setVideoOrientation:(AVCaptureVideoOrientation)videoOrientation;

@end

NS_ASSUME_NONNULL_END
