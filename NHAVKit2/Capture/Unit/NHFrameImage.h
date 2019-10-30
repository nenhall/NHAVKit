//
//  NHFrameImage.h
//  NHAVFoundation
//
//  Created by nenhall_work on 2018/10/19.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "NHExportConfig.h"


NS_ASSUME_NONNULL_BEGIN

@interface NHFrameImage : NSObject

- (void)nh_setupCaptureSession;

/// 从视频中截取图片
/// @param sampleBuffer sampleBuffer description
+ (UIImage *)nh_imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/// 等比率缩放图片
/// @param image image description
/// @param scaleSize 缩放
+ (UIImage *)nh_scaleImage:(UIImage *)image toScale:(float)scaleSize;

/// 导出视频
/// @param url 文件地址
/// @param config 导出配置
/// @param progress 导出进度
/// @param completed 完成回调
/// @param save 是否同时保存相册
+ (void)exportVidelWithUrl:(NSURL *)url
              exportConfig:(nonnull NHExportConfig *)config
                  progress:(nonnull void (^)(CGFloat))progress
                 completed:(void (^)(NSURL *exportURL, NSError *error))completed
          savedPhotosAlbum:(BOOL)save;

/// 保存到相册
/// @param outputFileURL outputFileURL description
+ (void)saveVidelToPhoto:(NSURL *)outputFileURL;

/// 获取文件的大小
/// @param path 文件路径
+ (CGFloat)fileSize:(NSURL *)path;


@end

NS_ASSUME_NONNULL_END
