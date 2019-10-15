//
//  NHBeasSession.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/15.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHCaptureSessionProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface NHBeasSession : NSObject <NHCaptureSessionProtocol>
{
  NSString *_inputPath;
  NSString *_outputPath;
  NHPushStreamStatus _status;
  AVCaptureVideoOrientation _videoOrientation;
  BOOL     _isRecording;
  __weak UIView *_preview;
  CGFloat _distanceNormalizationFactor;
  NHOutputType _outputType;
}

@property (nonatomic, copy) NSString *inputPath;
@property (nonatomic, copy) NSString *outputPath;
@property (nonatomic, assign) NHPushStreamStatus status;


/**
 视频方向
 */
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/**
 摄像头位置
 */
@property (nonatomic, assign) AVCaptureDevicePosition deviePosition;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, weak  ) UIView *preview;
@property (nonatomic, assign) NHOutputType outputType;

/**
 在屏幕旋转后自动更新子视图的布局，default：YES
 一但关闭，将不会自动调用`layoutSubviews`及`setVideoOrientation`方法
 */
@property (nonatomic, assign) BOOL autoLayoutSubviews;

// A normalization factor for the distance between central color and sample color.
@property(nonatomic, readwrite) CGFloat distanceNormalizationFactor;

/**
 初始化

 @param preview 预览层
 */
- (instancetype)initSessionWithPreviewView:(UIView *)preview outputType:(NHOutputType)outputType;

- (instancetype)initStreamWithInputPath:(NSString *)inPath
                             outputPath:(NSString *)outPath;


/**
 屏幕旋转的通知方法
 */
- (void)deviceOrientationDidChangeNotification:(NSNotification *)note;

- (void)initializeCaptureSession;

/** 开始捕捉(预览) */
- (void)startCapture;

/** 停止捕捉(预览) */
- (void)stopCapture;

/** 开始推流 */
- (void)startPushStream;

/** 停止推流 */
- (void)stopPushStream;

/** 镜像切换 */
- (BOOL)videoMirrored;

/** 切换摄像头 */
- (AVCaptureDevicePosition)changeCameraPosition;

/** 设置预览层 */
- (void)setPreview:(UIView *)preview;

/** 更新预览层视图布局 */
- (void)layoutSubviews;

/** 重设预览层frame */
- (void)setPreviewLayerFrame:(CGRect)rect;




/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode;

/**
 

 @param newImage 生成的图片
 @param save 是否同时保存到相册，plist文件中添加：`Privacy - Photo Library Additions Usage Description`
 */


/**
 拍照：截取视频当前帧

 @param save 是否保存到相册
 @param isScaling 是否比例绽放：0.5
 @param complete 截取后的图片
 */
- (void)takePhotoSavedPhotosAlbum:(BOOL)save isScaling:(BOOL)isScaling complete:(nullable void (^)(UIImage *image))complete;

/**
 获取视频尺寸

 @param sessionPreset AVCaptureSessionPreset
 @param isVideoPortrait 是否竖屏
 */
- (CGSize)getVideoSize:(NSString *)sessionPreset isVideoPortrait:(BOOL)isVideoPortrait;
    
@end

NS_ASSUME_NONNULL_END
