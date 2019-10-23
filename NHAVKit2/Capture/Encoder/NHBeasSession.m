//
//  NHBeasSession.m
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/15.
//  Copyright © 2019 neghao. All rights reserved.
//

#import "NHBeasSession.h"


@interface NHBeasSession ()
@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;

@end

@implementation NHBeasSession
@synthesize inputURL = _inputURL;
@synthesize outputURL = _outputURL;
@synthesize status = _status;
@synthesize videoOrientation = _videoOrientation;
@synthesize preview = _preview;
@synthesize distanceNormalizationFactor = _distanceNormalizationFactor;
@synthesize cameraPosition = _cameraPosition;
@synthesize captureSessionPreset = _captureSessionPreset;
@synthesize isPortrait = _isPortrait;


- (instancetype)init {
  self = [super init];
  if (self) {
      [self initializeBaseConfig];
  }
  return self;
}

- (instancetype)initStreamWithInputURL:(NSURL *)inURL outputURL:(NSURL *)outURL {
    self = [super init];
    if (self) {
        _inputURL = inURL;
        _outputURL = outURL;
        [self initializeBaseConfig];
    }
    return self;
}

- (instancetype)initSessionWithPreviewView:(UIView *)preview outputType:(NHOutputType)outputType {
    self = [super init];
    if (self) {
        _preview = preview;
        _outputType = outputType;
        [self initializeBaseConfig];
    }
    return self;
}

- (void)initializeBaseConfig {
    _isPortrait = YES;
    _autoLayoutSubviews = YES;
    _cameraPosition = AVCaptureDevicePositionFront;
    _videoOrientation = AVCaptureVideoOrientationPortrait;
    _captureSessionPreset = AVCaptureSessionPreset1280x720;
    _videoSize = [self getVideoSize:_captureSessionPreset isVideoPortrait:_isPortrait];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
}

/** 屏幕旋转的通知方法 */
- (void)deviceOrientationDidChangeNotification:(NSNotification *)note {
    //    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //    [_previewLayer setFrame:_videoPreviewView.bounds];
}

/** 开始捕捉(预览) */
- (void)startCapture {}

/** 停止捕捉(预览) */
- (void)stopCapture {}

/** 开始推流 */
- (void)startPushStream {}

/** 停止推流 */
- (void)stopPushStream {}

/** 镜像切换 */
- (BOOL)videoMirrored {return NO;}

/** 更新预览层视图布局 */
- (void)layoutSubviews {}

/** 重设预览层frame */
- (void)setPreviewLayerFrame:(CGRect)rect {}

/** 设置视频的方向 */
- (void)setVideoOrientation:(AVCaptureVideoOrientation)videoOrientation {}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {}

- (void)rotateCamera { }

- (void)takePhotoSavedPhotosAlbum:(BOOL)save isScaling:(BOOL)isScaling complete:(void (^)(UIImage *image))complete {

}

/** 获取视频尺寸 */
- (CGSize)getVideoSize:(NSString *)sessionPreset isVideoPortrait:(BOOL)isVideoPortrait {
    CGSize size = CGSizeZero;
    if ([sessionPreset isEqualToString:AVCaptureSessionPresetMedium]) {
        if (isVideoPortrait)
            size = CGSizeMake(360, 480);
        else
            size = CGSizeMake(480, 360);
    } else if ([sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        if (isVideoPortrait)
            size = CGSizeMake(1080, 1920);
        else
            size = CGSizeMake(1920, 1080);
    } else if ([sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        if (isVideoPortrait)
            size = CGSizeMake(720, 1280);
        else
            size = CGSizeMake(1280, 720);
    } else if ([sessionPreset isEqualToString:AVCaptureSessionPreset640x480]) {
        if (isVideoPortrait)
            size = CGSizeMake(480, 640);
        else
            size = CGSizeMake(640, 480);
    }
    
    return size;
}



- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"相片保存成功");
}

@end
