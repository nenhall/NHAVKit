//
//  NHFrameImage.m
//  NHAVFoundation
//
//  Created by nenhall_work on 2018/10/19.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import "NHFrameImage.h"
#import <AVFoundation/AVFoundation.h>
#import "NHGifTool.h"

@interface NHFrameImage ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation NHFrameImage


// 创建并配置一个捕获会话并且启用它
- (void)nh_setupCaptureSession
{
    NSError *error = nil;
    // 创建session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 可以配置session以产生解析度较低的视频帧，如果你的处理算法能够应付（这种低解析度）。
    // 我们将选择的设备指定为中等质量。
    session.sessionPreset = AVCaptureSessionPresetMedium;
    // 找到一个合适的AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 用device对象创建一个设备对象input，并将其添加到session
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // 处理相应的错误
    }
    [session addInput:input];
    // 创建一个VideoDataOutput对象，将其添加到session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    // 配置output对象
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];

    // 指定像素格式
    output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    // 如果你想将视频的帧数指定一个顶值, 例如15ps
    // 可以设置minFrameDuration（该属性在iOS 5.0中弃用）
//    output.minFrameDuration = CMTimeMake(1, 15);
    // 启动session以启动数据流
    [session startRunning];
    // 将session附给实例变量
    _session = session;
}



// 抽样缓存写入时所调用的委托程序
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // 通过抽样缓存数据创建一个UIImage对象
    UIImage *image = [NHFrameImage nh_imageFromSampleBuffer:sampleBuffer];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

//    < 此处添加使用该image对象的代码 >
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"相片保存成功");
}


// 通过抽样缓存数据创建一个UIImage对象
+ (UIImage *)nh_imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    if (width == 0) {
        NSLog(@"图片生成为空");
        //        return nil;
    }
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    return (image);
}

// 等比率缩放图片
+ (UIImage *)nh_scaleImage:(UIImage *)image toScale:(float)scaleSize {

    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));

    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];

    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;
    
}


@end
