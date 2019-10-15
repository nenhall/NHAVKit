//
//  NHVideoWatet.h
//  NHVideoProcessFramework
//
//  Created by nenhall on 2019/4/9.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHVideoWater : NSObject


/**
 使用GPUImage加载水印
 
 @param vedioPath 视频路径
 @param img 水印图片
 @param coverImg 水印图片二
 @param question 字符串水印
 @param fileName 生成之后的视频名字
 */
-(void)saveVedioPath:(NSURL*)vedioPath WithWaterImg:(UIImage*)img WithCoverImage:(UIImage*)coverImg WithQustion:(NSString*)question WithFileName:(NSString*)fileName;


@end

NS_ASSUME_NONNULL_END
