//
//  NHImageHandle.h
//  NHPlayDemo
//
//  Created by nenhall on 2019/3/7.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHImageHandle : NSObject

/**
 获取封面图
 
 @param url 视频地址
 @param videoTime 时间
 */
+ (UIImage *)getCoverImageFromVideoURL:(NSURL *)url time:(NSTimeInterval )videoTime;


/**
 获取视频宽高比

 @param url 视频地址
 */
+ (CGFloat )getVideoScale:(NSURL *)url;


/**
 计算缓冲进度
 */
+ (NSTimeInterval)availableDurationRanges:(AVPlayerItem *)playItme;

@end

NS_ASSUME_NONNULL_END
