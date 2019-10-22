//
//  NHFrameImage.h
//  NHAVFoundation
//
//  Created by nenhall_work on 2018/10/19.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHFrameImage : NSObject

- (void)nh_setupCaptureSession;

/**
 从视频中u截取图片
 */
+ (UIImage *)nh_imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;


// 等比率缩放图片
+ (UIImage *)nh_scaleImage:(UIImage *)image toScale:(float)scaleSize;


@end

NS_ASSUME_NONNULL_END
