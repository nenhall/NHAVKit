//
//  NHAVCaptureSession.m
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/14.
//  Copyright © 2019 neghao. All rights reserved.
//

#import "NHAVCaptureSession.h"
#import <CoreVideo/CoreVideo.h>
#import "NHVideoConfiguration.h"
#import "NHVideoHelper.h"
#import "NHGPUImageView.h"
#import "NHImageBeautifyFilter.h"
#import "NHFrameImage.h"

//#import "NHH264Encoder.h"
//#import "NHWriteH264Stream.h"
//#import "NHX264Manager.h"

@interface NHAVCaptureSession ()<
AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,
AVCaptureFileOutputRecordingDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *moveFileOutput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UITapGestureRecognizer *focusGesture;
@property (nonatomic, weak  ) AVCaptureConnection *videoCaptureConnection;
@property (nonatomic, weak  ) AVCaptureConnection *audioCaptureConnection;
@property (nonatomic, strong) NHGPUImageView *gpuImageView;
//@property (nonatomic, strong) NHX264Manager *x264Manger;

@end


@implementation NHAVCaptureSession {
    dispatch_queue_t     _encodeQueue;
//    NHH264Encoder        *_x264Encoder;
//    NHWriteH264Stream    *_writeH264Stream;
    NHVideoConfiguration *_videoConfiguration;
    CGSize               _captureVideoSize;
    BOOL                 _isVideoPortrait;
    NHImageBeautifyFilter *_pixellateFilter;
    GPUImageMovie        *_movieFile;
    GPUImageMovieWriter  *_movieWriter;
    GPUImageVideoCamera  *_videoCamera;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self initializeCaptureSession];
  }
  return self;
}

+ (instancetype)sessionWithPreviewView:(UIView *)preview outputType:(NHOutputType)outputType {
  return [[NHAVCaptureSession alloc] initSessionWithPreviewView:preview outputType:outputType];
}

- (instancetype)initStreamWithInputPath:(NSString *)inPath outputPath:(NSString *)outPath
{
  self = [super initStreamWithInputPath:inPath
                             outputPath:outPath];
  if (self) {
    [self initializeCaptureSession];
  }
  return self;
}

- (instancetype)initSessionWithPreviewView:(UIView *)preview outputType:(NHOutputType)outputType {
  self = [super initSessionWithPreviewView:preview outputType:outputType];
  if (self) {
    [self initializeCaptureSession];
    
    //        [self initializeGPUCamera];
  }
  return self;
}

#pragma mark - AVCaptureSession init
#pragma mark -
- (void)initializeCaptureSession {
  [super initializeCaptureSession];
  
  _encodeQueue = dispatch_queue_create("com.nenhall.encodeQueue", DISPATCH_QUEUE_SERIAL);
  _isVideoPortrait = YES;
  _videoOrientation = AVCaptureVideoOrientationPortrait;
  AVCaptureSessionPreset preset = AVCaptureSessionPreset1280x720;
  _captureVideoSize = [self getVideoSize:preset isVideoPortrait:_isVideoPortrait];
  
  // 初始化会话管理对象
  _captureSession = [[AVCaptureSession alloc] init];
  //指定输出质量
  _captureSession.sessionPreset = preset;
  
  // 视频输入
  NSError *videoInputError;
  _videoDeviceInput =  [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:&videoInputError];
  [self addInputDataToSession:_videoDeviceInput];

  
  // 输出数据对象
  switch (_outputType) {
    case NHOutputTypeVideoData:
      [self addOutputDataToSession:self.videoDataOutput];
      break;
      
    case NHOutputTypeVideoStillImage:
      [self addOutputDataToSession:self.videoDataOutput];
      [self addOutputDataToSession:self.stillImageOutput];
      break;
      
    case NHOutputTypeMovieFile:
      [self addOutputDataToSession:self.moveFileOutput];
      break;
      
    case NHOutputTypeMovieFileStillImage:
      [self addOutputDataToSession:self.moveFileOutput];
      [self addOutputDataToSession:self.stillImageOutput];
      break;
      
    case NHOutputTypeStillImage:
      [self addOutputDataToSession:self.stillImageOutput];
      break;
  }

  
  // 保存Connection，用于在SampleBufferDelegate中判断数据来源（是Video/Audio？）
  _videoCaptureConnection = [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
  _videoCaptureConnection.videoOrientation = _videoOrientation;
  // 设置镜像效果镜像
  if ([_videoCaptureConnection isVideoMirroringSupported]) {
    _videoCaptureConnection.videoMirrored = NO;
  }
  
  //视频稳定设置
  if ([_videoCaptureConnection isVideoStabilizationSupported]) {
    _videoCaptureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
  }
  //视频旋转方向的设置
  //    _videoCaptureConnection.videoScaleAndCropFactor = _videoCaptureConnection.videoMaxScaleAndCropFactor;
  
  // 音频输入
  AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
  NSError *audioInputError;
  _audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&audioInputError];
  [self addInputDataToSession:_audioDeviceInput];

  
  // 音频输出
  dispatch_queue_t audioQueue = dispatch_queue_create("audioOutputQueue", DISPATCH_QUEUE_CONCURRENT);
  _audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
  [_audioDataOutput setSampleBufferDelegate:self queue:audioQueue];
  [self addOutputDataToSession:_audioDataOutput];
  _audioCaptureConnection = [_audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
  
  
  // 预览层
  _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
  [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  [_previewLayer setFrame:CGRectMake(0, 0, _preview.bounds.size.width, _preview.bounds.size.height)];
  [_preview.layer addSublayer:_previewLayer];
  //    _previewLayer.connection.videoOrientation = [_videoOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
  
  [self setupFaceSessionOutput:_captureSession];
  [self addFocusGestureTouchEvent];
}

- (void)addInputDataToSession:(AVCaptureInput *)input {
  if ([_captureSession canAddInput:input]) {
    [_captureSession beginConfiguration];
    [_captureSession addInput:input];
    [_captureSession commitConfiguration];
  } else {
#ifdef DEBUG
    for (AVCaptureInput *input2 in [_captureSession inputs]) {
      if (input == input2) {
        kNSLog(@"Add Input Error: %@ Input already exist in captureSession",NSStringFromClass([input class]));
        return;
      }
    }
#endif
    kNSLog(@"Add Input Error: %@",NSStringFromClass([input class]));
    return;
  }
}

- (void)addOutputDataToSession:(AVCaptureOutput *)output {
  if ([_captureSession canAddOutput:output]) {
    [_captureSession beginConfiguration];
    [_captureSession addOutput:output];
    [_captureSession commitConfiguration];
  } else {
#ifdef DEBUG
    for (AVCaptureOutput *output2 in [_captureSession outputs]) {
      if (output == output2) {
        kNSLog(@"Add Output Error: %@ Output already exist in captureSession",NSStringFromClass([output class]));
        return;
      }
    }
#endif
    kNSLog(@"Add Output Error: %@",NSStringFromClass([output class]));
    return;
  }
}

- (void)initializeGPUCamera {
  
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720
                                                       cameraPosition:self.deviePosition];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    ///添加加载输入输出流（用来解决 解决获取视频第一帧图片黑屏问题，不加也行，哈哈）
    [_videoCamera addAudioInputsAndOutputs];
  
    _pixellateFilter = [[NHImageBeautifyFilter alloc] init];
    [_pixellateFilter addTarget:_gpuImageView];
    [_videoCamera addTarget:_pixellateFilter];
    [_videoCamera startCameraCapture];
}

- (void)initializeX264Encode {
//    _x264Manger = [[NHX264Manager alloc] init];
}

- (void)setCaptureSessionPreset:(const NSString *)preset {
  
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    for (AVCaptureConnection *connection in connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:mediaType]) {
                return connection;
            }
        }
    }
    return nil;
}

#pragma mark - Handle Video Orientation
- (AVCaptureVideoOrientation)currentVideoOrientation {
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        return AVCaptureVideoOrientationLandscapeRight;
    } else {
        return AVCaptureVideoOrientationLandscapeLeft;
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
          NSError *capLockError;
          if ([device lockForConfiguration:&capLockError]) {
            AVCaptureDeviceFormat *format = device.formats.firstObject;
            kNSLog(@"formats.count:%ld\nvideoSupportedFrameRateRanges:%@",device.formats.count,format.videoSupportedFrameRateRanges);
            
            //设置视频帧率
            device.activeVideoMaxFrameDuration = CMTimeMake(1, 10);
            //自动闪光灯
            if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
              [device setFlashMode:AVCaptureFlashModeAuto];
            }
            //自动白平衡
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
              [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            //自动对焦
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
              [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            //自动曝光
            if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
              [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [device unlockForConfiguration];
          }
          
            return device;
        }
    }
    return nil;
}

/** 人像识别 */
- (void)setupFaceSessionOutput:(AVCaptureSession *)session {
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
  
    if ([session canAddOutput:output]) {
        [session addOutput:output];
      
        NSArray *metadataObjectTypes = @[AVMetadataObjectTypeFace];
        [output setMetadataObjectTypes:metadataObjectTypes];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        //        [session addOutput:output];
    }
}

- (BOOL)cameraSupportZoom:(AVCaptureDevice *)captureDevice {
    return captureDevice.activeFormat.videoMaxZoomFactor > 1.0f;
}

- (CGFloat)maxZoomFactor:(AVCaptureDevice *)captureDevice {
    return MIN(captureDevice.activeFormat.videoMaxZoomFactor, 4.0f);
}

/** 放大 */
- (void)setZoomValue:(CGFloat)zoomValue forDevice:(AVCaptureDevice *)captureDevice {
    if (captureDevice.isRampingVideoZoom == NO) {
        NSError *error;
        if ([captureDevice lockForConfiguration:&error]) {
            CGFloat zoomFactor = pow([self maxZoomFactor:captureDevice], zoomValue);
            captureDevice.videoZoomFactor = zoomFactor;
            [captureDevice unlockForConfiguration];
        }
    }
}

/** 逐渐缩放 */
- (void)rampZoomToValue:(CGFloat)zoomValue forDevice:(AVCaptureDevice *)captureDevice {
    CGFloat zoomFactor = pow([self maxZoomFactor:captureDevice], zoomValue);
    NSError *error;
  
    if (captureDevice.isRampingVideoZoom == NO) {
        if ([captureDevice lockForConfiguration:&error]) {
            [captureDevice rampToVideoZoomFactor:zoomFactor withRate:1.0];
            [captureDevice unlockForConfiguration];
        }
    }
}

#pragma mark - 对焦事件
#pragma mark -
- (void)addFocusGestureTouchEvent {
  
    if (!_focusGesture) {
        _focusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTouchEvent:)];
    } else {
        [_preview removeGestureRecognizer:self.focusGesture];
    }
  
    if (_preview) {
        [_preview addGestureRecognizer:_focusGesture];
    }
  
}

- (void)focusTouchEvent:(UITapGestureRecognizer *)tap {
    [self focus:[tap locationInView:self.preview]];
}

/** 对焦 */
- (void)focus:(CGPoint)point;
{
    //#if HAS_AVFF
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([device isFocusPointOfInterestSupported] &&
           [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            double screenWidth = screenRect.size.width;
            double screenHeight = screenRect.size.height;
            double focus_x = point.x/screenWidth;
            double focus_y = point.y/screenHeight;
            if([device lockForConfiguration:nil]) {
                [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                    [device setExposureMode:AVCaptureExposureModeAutoExpose];
                }
                [device unlockForConfiguration];
            }
        }
    }
    //#endif
}

#pragma mark - private sett / gett
#pragma mark -
/**
 setting superview
 */
- (void)setPreview:(UIView *)preview {
    [_previewLayer removeFromSuperlayer];
    _preview = preview;
    [preview.layer addSublayer:_previewLayer];
    _previewLayer.frame = preview.bounds;
    [self addFocusGestureTouchEvent];
}

- (void)setOutputType:(NHOutputType)outputType {
  
  if (_outputType == outputType) return;
  _outputType = outputType;
  
  switch (_outputType) {
    case NHOutputTypeVideoData:
      [_captureSession removeOutput:_moveFileOutput];
      [_captureSession removeOutput:_stillImageOutput];
      [self addOutputDataToSession:self.videoDataOutput];
      break;
      
    case NHOutputTypeMovieFile:
      [_captureSession removeOutput:_videoDataOutput];
      [_captureSession removeOutput:_stillImageOutput];
      [self addOutputDataToSession:self.moveFileOutput];
      break;
      
    case NHOutputTypeStillImage:
      [_captureSession removeOutput:_moveFileOutput];
      [_captureSession removeOutput:_videoDataOutput];
      [self addOutputDataToSession:self.stillImageOutput];
      break;
      
    case NHOutputTypeVideoStillImage:
      [_captureSession removeOutput:_moveFileOutput];
      [self addOutputDataToSession:self.videoDataOutput];
      [self addOutputDataToSession:self.stillImageOutput];
      break;
      
    case NHOutputTypeMovieFileStillImage:
      [_captureSession removeOutput:_videoDataOutput];
      [self addOutputDataToSession:self.moveFileOutput];
      [self addOutputDataToSession:self.stillImageOutput];
      break;
  }
}

- (void)startCapture {
    if (![_captureSession isRunning]) {
        [_captureSession startRunning];
    }
  
  switch (_outputType) {
    case NHOutputTypeVideoData:
      
      break;
      
    case NHOutputTypeMovieFile:
      [self startRecord];
      break;
      
    case NHOutputTypeStillImage:

      break;
    case NHOutputTypeVideoStillImage:

      break;
      
    case NHOutputTypeMovieFileStillImage:
      
      break;
  }
}

- (void)stopCapture {
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
  
  switch (_outputType) {
    case NHOutputTypeVideoData:
      
      break;
      
    case NHOutputTypeMovieFile:
      [self stopRecord];
      break;
      
    case NHOutputTypeStillImage:
      
      break;
    case NHOutputTypeVideoStillImage:
      
      break;
      
    case NHOutputTypeMovieFileStillImage:
      
      break;
  }
}

- (void)startRecord {

  if (!self.outputPath) {
    kNSLog(@"输出路径错误，%@",_outputPath);
    return;
  }
  
  if (!self.isRecording) {
    NSURL *outputUrl = [NSURL URLWithString:_outputPath];
    if ([_outputPath hasPrefix:@"/var"]) {
      outputUrl = [NSURL fileURLWithPath:_outputPath];
      self.isRecording = YES;
      [_moveFileOutput startRecordingToOutputFileURL:[NSURL URLWithString:self.outputPath]
                                   recordingDelegate:self];
    }
  }
}

- (void)startRecordX264 {
    [self initializeX264Encode];

}

- (void)stopRecord {
    if (self.isRecording) {
        self.isRecording = NO;
      [_moveFileOutput stopRecording];
//        [_x264Manger teardown];
        kNSLog(@"停止录制.");
    }
}

- (void)deviceOrientationDidChangeNotification:(NSNotification *)note {
    UIDevice *curruntDevice = [UIDevice currentDevice];
    if (self.autoLayoutSubviews) {
        if (kIPadDevice) {
            if (curruntDevice.orientation == UIDeviceOrientationLandscapeLeft) {
                _previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                _videoCaptureConnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;

            } else if (curruntDevice.orientation == UIDeviceOrientationLandscapeRight) {
                _previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                _videoCaptureConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;

            } else if (curruntDevice.orientation == UIDeviceOrientationFaceDown) {
                _previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                _videoCaptureConnection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;

            } else {
                _previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
                _videoCaptureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
            }
        }
        [self layoutSubviews];
    }
}

- (void)setPreviewLayerFrame:(CGRect)rect {
    _previewLayer.frame = rect;
}

- (void)layoutSubviews {
    [_previewLayer setFrame:CGRectMake(0, 0, _preview.bounds.size.width, _preview.bounds.size.height)];
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
#pragma mark -
/*
 CMSampleBufferRef: 帧缓存数据，描述当前帧信息
 CMSampleBufferGetXXX : 获取帧缓存信息
 CMSampleBufferGetDuration : 获取当前帧播放时间
 CMSampleBufferGetImageBuffer : 获取当前帧图片信息
 */
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
  
//    kNSLog(@"%ld",_videoDataOutput.connections.count);
  
    if (_videoDataOutput.connections.firstObject == connection) {
        //采集视频
        //            UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        //            if (image) {
        //                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        //            }
    }else{
        //采集音频
    }
  
    if (connection == _videoCaptureConnection) {
        if (self.isRecording) {
//            [self.x264Manger encoding:sampleBuffer];
        }
      
    } else if (connection == _audioCaptureConnection) {

    }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(capturedidOutputSampleBuffer:outputType:)]) {
    [self.delegate capturedidOutputSampleBuffer:sampleBuffer outputType:_outputType];
  }
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
  
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
#pragma mark -
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
  
    kNSLog(@"%@",connections);
    if (self.delegate && [self.delegate respondsToSelector:@selector(captureOutputDidStartRecordingToOutputFileAtURL:fromConnection:)]) {
        [self.delegate captureOutputDidStartRecordingToOutputFileAtURL:output fromConnection:connections];
    }
  
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
  
  if (error) {
    kNSLog(@"\n录制完成,错误：%@",error.localizedDescription);
  } else {
    kNSLog(@"\n录制完成 outputFileURL：%@",outputFileURL);
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(captureOutputDidFinishRecordingToOutputFileAtURL:fromConnections:error:)]) {
    [self.delegate captureOutputDidFinishRecordingToOutputFileAtURL:outputFileURL fromConnections:connections error:error];
  }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
#pragma mark -
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  
  for (AVMetadataFaceObject *faceObj in metadataObjects) {
    //        kNSLog(@"face id: %ld",faceObj.faceID);
    //        kNSLog(@"face bounds: %@",NSStringFromCGRect(faceObj.bounds));
  }
}


#pragma mark - private method
#pragma mark -
/** 设置闪光灯模式 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode {
  AVCaptureDevice *captureDevice= [self.videoDeviceInput device];
  NSError *error;
  //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
  if ([captureDevice lockForConfiguration:&error]) {
    if ([captureDevice isFlashModeSupported:flashMode]) {
      [captureDevice setFlashMode:flashMode];
    }
    [captureDevice unlockForConfiguration];
  }else{
    kNSLog(@"设置闪光灯模式发生错误：%@",error.localizedDescription);
  }
}


- (void)exportVidelWithUrl:(NSURL *)url exportConfig:(NHExportConfig *)config progress:(nonnull void (^)(CGFloat))progress completed:(nonnull void (^)(NSURL * _Nonnull, NSError * _Nonnull))completed savedPhotosAlbum:(BOOL)save {
  [[NHVideoHelper new] exportVidelWithUrl:url exportConfig:config progress:progress completed:completed savedPhotosAlbum:YES];
}


/**
 拍照
 */
- (void)takePhotoSavedPhotosAlbum:(BOOL)save isScaling:(BOOL)isScaling complete:(void (^)(UIImage * _Nonnull))complete {
  
  AVCaptureConnection *connection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
  if (!connection) {
    kNSLog(@"take photo failed: AVCaptureConnection is nil");
    return;
  }

  [_stillImageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                 completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
   {
     if (imageDataSampleBuffer == NULL) return;
     if (error) {
       kNSLog(@"take photo failed: %@",error.localizedDescription);
       return;
     }
     
     UIImageOrientation imgOrientation = UIImageOrientationUp;
     if (self.videoOrientation == AVCaptureDevicePositionFront) {
       //IOS前置摄像头左右成像 前置摄像头图像方向 UIImageOrientationLeftMirrored
       imgOrientation = UIImageOrientationLeftMirrored;
     }
     
     NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
     UIImage *orgImage = [UIImage imageWithData:imageData];
     UIImage *frontImage = [[UIImage alloc] initWithCGImage:orgImage.CGImage scale:orgImage.scale orientation:UIImageOrientationLeftMirrored];
     
     //取得影像数据（需要ImageIO.framework 与 CoreMedia.framework）
     CFDictionaryRef myAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
     kNSLog(@"影像属性: %@", myAttachments);
     
     if (isScaling) {
       frontImage= [NHFrameImage nh_scaleImage:orgImage toScale:0.5];
     }
     
     nh_safe_dispatch_main_q(^{
       if (complete) complete(frontImage);
     });
     
     if (save) {
       UIImageWriteToSavedPhotosAlbum(frontImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
     }
   }];
}

- (AVCaptureDevicePosition)changeCameraPosition {
    NSError *error;
    AVCaptureDevicePosition position = [[_videoDeviceInput device] position];
  
    AVCaptureDeviceInput *videoInput;
  
    if (position == AVCaptureDevicePositionBack) {
        videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        self.previewLayer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 0.0f);
        position = AVCaptureDevicePositionFront;
    } else {
        videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack] error:&error];
        self.previewLayer.transform = CATransform3DIdentity;
        position = AVCaptureDevicePositionBack;
    }
  
    if (error) {
      kNSLog(@"%@",error.localizedDescription);
      return;
    }
  
    if (videoInput) {
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:_videoDeviceInput];
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            _videoDeviceInput = videoInput;
        }
        [self.captureSession commitConfiguration];
    }
  
    return position;
}

//镜像切换
- (BOOL)videoMirrored {
  
    NSError *error;
    AVCaptureDevicePosition position = [[_videoDeviceInput device] position];
  
    if (position == AVCaptureDevicePositionFront) {
        CATransform3D curruntTransform = self.previewLayer.transform;
        if (curruntTransform.m11 == 1) {
            self.previewLayer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f);
            return NO;
        } else {
            self.previewLayer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 0.0f);
            return YES;
        }
    }
  
    if (error) {
        kNSLog(@"%@",error.localizedDescription);
    }
  
    return NO;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {

}


- (void)dealloc {
    kNSLog(@"%s",__func__);
}


#pragma mark - private method - initialize
#pragma mark -
- (AVCaptureStillImageOutput *)stillImageOutput {
  if (!_stillImageOutput) {
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    // Setup the still image file output
    // 将输出流设置成JPEG的图片格式输出，这里输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [_stillImageOutput setOutputSettings:@{ AVVideoCodecKey : AVVideoCodecJPEG }];
    //是否支持光学防抖动功能
    if ([_stillImageOutput isStillImageStabilizationSupported]) {
      //开启光学防抖动
      [_stillImageOutput setAutomaticallyEnablesStillImageStabilizationWhenAvailable:YES];
    }
  }
  return _stillImageOutput;
}

- (AVCaptureMovieFileOutput *)moveFileOutput {
  if (!_moveFileOutput) {
    _moveFileOutput = [[AVCaptureMovieFileOutput alloc] init];
  }
  return _moveFileOutput;
}

- (AVCaptureVideoDataOutput *)videoDataOutput {
  if (!_videoDataOutput) {
    // 视频输出
    _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    // nv12
    /**
     kCVPixelBufferPixelFormatTypeKey 指定解码后的图像格式
     kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange  : YUV420 用于标清视频[420v]
     kCVPixelFormatType_420YpCbCr8BiPlanarFullRange   : YUV422 用于高清视频[420f]
     kCVPixelFormatType_32BGRA : 输出的是BGRA的格式，适用于OpenGL和CoreImage
     */
    //NSString *typekey = (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange],
                              kCVPixelBufferPixelFormatTypeKey,
                              nil];
    _videoDataOutput.videoSettings = settings;
    _videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:
                                      [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                                 forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    dispatch_queue_t videoQueue = dispatch_queue_create("videoOutputQueue", DISPATCH_QUEUE_CONCURRENT);
    [_videoDataOutput setSampleBufferDelegate:self queue:videoQueue];
  }
  return _videoDataOutput;
}
//将视频流变成yuvdata数据
//-(NSData*) convertVideoSmapleBufferToYuvData:(CMSampleBufferRef) videoSample{
//    //获取yuv数据
//    //通过CMSampleBufferGetImageBuffer方法，获得CVImageBufferRef。
//    //这里面就包含了yuv420数据的指针
//    CVImageBufferRef pixelBuffer =CMSampleBufferGetImageBuffer(videoSample);
//    //表示开始操作数据
//    CVPixelBufferLockBaseAddress(pixelBuffer,0);
//    //图像宽度（像素）
//    size_t pixelWidth =CVPixelBufferGetWidth(pixelBuffer);
//    //图像高度（像素）
//    size_t pixelHeight =CVPixelBufferGetHeight(pixelBuffer);
//    //yuv中的y所占字节数
//    size_t y_size = pixelWidth * pixelHeight;
//    //yuv中的u和v分别所占的字节数
//    size_t uv_size = y_size /4;
//    uint8_t*yuv_frame = aw_alloc(uv_size *2+ y_size);
//    //获取CVImageBufferRef中的y数据
//    uint8_t*y_frame =CVPixelBufferGetBaseAddressOfPlane(pixelBuffer,0);
//    memcpy(yuv_frame, y_frame, y_size);
//    //获取CMVImageBufferRef中的uv数据
//    uint8_t*uv_frame =CVPixelBufferGetBaseAddressOfPlane(pixelBuffer,1);
//    memcpy(yuv_frame + y_size, uv_frame, uv_size *2);
//    CVPixelBufferUnlockBaseAddress(pixelBuffer,0);
//    NSData*nv12Data = [NSData dataWithBytesNoCopy:yuv_framelength:y_size + uv_size *2];
//    //旋转
//    return[self rotateNV12Data:nv12Data];
//
//}
//
////yuv格式---->nv12格式
//-(NSData*)rotateNV12Data:(NSData*)nv12Data{
//    intdegree =0;
//    switch(self.videoConfig.orientation) {
//        caseUIInterfaceOrientationLandscapeLeft:
//            degree =90;
//            break;
//        caseUIInterfaceOrientationLandscapeRight:degree =270;
//            break;
//        default:
//            //do nothingbreak;
//    }
//
//    if(degree !=0) {
//        uint8_t*src_nv12_bytes = (uint8_t*)nv12Data.bytes;
//        uint32_t width = (uint32_t)self.videoConfig.width;
//        uint32_t height = (uint32_t)self.videoConfig.height;
//        uint32_t w_x_h = (uint32_t)(self.videoConfig.width*self.videoConfig.height);
//        uint8_t*rotatedI420Bytes =aw_alloc(nv12Data.length);
//        NV12ToI420Rotate(src_nv12_bytes, width,src_nv12_bytes + w_x_h, width,rotatedI420Bytes, height,rotatedI420Bytes + w_x_h, height /2,rotatedI420Bytes + w_x_h + w_x_h /4, height /2,width, height, (RotationModeEnum)degree);I420ToNV12(rotatedI420Bytes, height,rotatedI420Bytes + w_x_h, height /2,rotatedI420Bytes + w_x_h + w_x_h /4, height /2,src_nv12_bytes, height, src_nv12_bytes + w_x_h, height,height, width);
//        aw_free(rotatedI420Bytes);}returnnv12Data;
//
//}
////nv12格式数据合成flv格式
//-(aw_flv_video_tag*)encodeYUVDataToFlvTag:(NSData*)yuvData {
//    if(!_vEnSession) {
//        returnNULL;
//
//    }
//    //yuv变成转
//    CVPixelBufferRefOSStatusstatus =noErr;
//    //视频宽度
//    size_t pixelWidth =self.videoConfig.pushStreamWidth;
//    //视频高度
//    size_t pixelHeight =self.videoConfig.pushStreamHeight;
//    //现在要把NV12数据放入CVPixelBufferRef中，因为硬编码主要调用VTCompressionSessionEncodeFrame函数，此函数不接受yuv数据，但是接受CVPixelBufferRef类型。
//    CVPixelBufferRefpixelBuf =NULL;
//    //初始化pixelBuf，数据类型是kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange，此类型数据格式同NV12格式相同。
//    CVPixelBufferCreate(NULL, pixelWidth, pixelHeight,kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,NULL, &pixelBuf);
//    // Lock address，锁定数据，应该是多线程防止重入操作。
//    if(CVPixelBufferLockBaseAddress(pixelBuf,0) !=kCVReturnSuccess){
//        [self onErrorWithCode:AWEncoderErrorCodeLockSampleBaseAddress Faileddes:@"encode video lock base address failed"];
//
//        return NULL;
//
//    }
//    //将yuv数据填充到CVPixelBufferRef中
//    size_t y_size =aw_stride(pixelWidth) * pixelHeight;size_tuv_size = y_size /4;uint8_t*yuv_frame = (uint8_t*)yuvData.bytes;
//    //处理yframe
//    uint8_t*y_frame =CVPixelBufferGetBaseAddressOfPlane(pixelBuf,0);
//    memcpy(y_frame, yuv_frame, y_size);
//    uint8_t*uv_frame =CVPixelBufferGetBaseAddressOfPlane(pixelBuf,1);
//    memcpy(uv_frame, yuv_frame + y_size, uv_size *2);
//    //硬编码CmSampleBufRef
//    //时间戳
//    uint32_tptsMs =self.manager.timestamp+1;
//    //self.vFrameCount++ * 1000.f / self.videoConfig.fps;
//    CMTimepts =CMTimeMake(ptsMs,1000);
//    //硬编码主要其实就这一句。将携带NV12数据的PixelBuf送到硬编码器中，进行编码。
//    status =VTCompressionSessionEncodeFrame(_vEnSession, pixelBuf, pts,kCMTimeInvalid,NULL, pixelBuf,NULL);
//
//    if(status ==noErr) {
//        dispatch_semaphore_wait(self.vSemaphore,DISPATCH_TIME_FOREVER);
//        if(_naluData) {
//            //此处硬编码成功，_naluData内的数据即为h264视频帧。
//            //我们是推流，所以获取帧长度，转成大端字节序，放到数据的最前面
//            uint32_tnaluLen = (uint32_t)_naluData.length;
//            //小端转大端。计算机内一般都是小端，而网络和文件中一般都是大端。大端转小端和小端转大端算法一样，就是字节序反转就行了。
//            uint8_tnaluLenArr[4] = {
//                naluLen >>24&0xff, naluLen >>16&0xff, naluLen >>8&0xff, naluLen &0xff
//            };
//            //将数据拼在一起
//            NSMutableData*mutableData = [NSMutableData dataWithBytes:naluLenArrlength:4];
//            [mutableData appendData:_naluData];
//            //将h264数据合成flv tag，合成flvtag之后就可以直接发送到服务端了。后续会介绍
//            aw_flv_video_tag*video_tag =aw_encoder_create_video_tag((int8_t*)mutableData.bytes, mutableData.length, ptsMs,0,self.isKeyFrame);
//
//            //到此，编码工作完成，清除状态。
//            _naluData=nil;
//            _isKeyFrame=NO;
//            CVPixelBufferUnlockBaseAddress(pixelBuf,0);
//            CFRelease(pixelBuf);
//            returnvideo_tag;
//
//        }
//
//    }else{
//        [self onErrorWithCode:AWEncoderErrorCodeEncodeVideoFrameFaileddes:@"encode video frame error"];
//    }
//
//    CVPixelBufferUnlockBaseAddress(pixelBuf,0);CFRelease(pixelBuf);
//    return NULL;
//}
//
////将音频流转换成data数据
//-(NSData*) convertAudioSmapleBufferToPcmData:(CMSampleBufferRef) audioSample{
//    //获取pcm数据大小
//    NSIntegeraudioDataSize =CMSampleBufferGetTotalSampleSize(audioSample);
//
//    //分配空间
//    int8_t*audio_data =aw_alloc((int32_t)audioDataSize);
//
//    //获取CMBlockBufferRef//这个结构里面就保存了PCM数据
//    CMBlockBufferRefdataBuffer =CMSampleBufferGetDataBuffer(audioSample);
//
//    //直接将数据copy至我们自己分配的内存中
//    CMBlockBufferCopyDataBytes(dataBuffer,0, audioDataSize, audio_data);
//
//    //返回数据
//    return[NSData dataWithBytesNoCopy:audio_data length:audioDataSize];
//}
//
//
////将音频data数据编码成acc格式并合成为flv
//-(aw_flv_audio_tag*)encodePCMDataToFlvTag:(NSData*)pcmData{
//    self.curFramePcmData= pcmData;AudioBufferListoutAudioBufferList = {0};
//
//    outAudioBufferList.mNumberBuffers=1;
//
//    outAudioBufferList.mBuffers[0].mNumberChannels= (uint32_t)self.audioConfig.channelCount;
//
//    outAudioBufferList.mBuffers[0].mDataByteSize=self.aMaxOutputFrameSize;
//
//    outAudioBufferList.mBuffers[0].mData=malloc(self.aMaxOutputFrameSize);
//
//    uint32_toutputDataPacketSize =1;
//
//    OSStatusstatus =AudioConverterFillComplexBuffer(_aConverter,aacEncodeInputDataProc, (__bridgevoid*_Nullable)(self), &outputDataPacketSize, &outAudioBufferList,NULL);
//    if(status ==noErr) {
//        NSData*rawAAC = [NSDatadataWithBytesNoCopy: outAudioBufferList.mBuffers[0].mDatalength:outAudioBufferList.mBuffers[0].mDataByteSize];
//
//        self.manager.timestamp+=1024*1000/self.audioConfig.sampleRate;
//
//        returnaw_encoder_create_audio_tag((int8_t*)rawAAC.bytes, rawAAC.length, (uint32_t)self.manager.timestamp, &_faacConfig);
//
//    }else{
//        [self onErrorWithCode:AWEncoderErrorCodeAudioEncoder Faileddes:@"aac编码错误"];
//
//    }
//    return NULL;
//
//}
//发送音频flv到rtmp服务器

@end
