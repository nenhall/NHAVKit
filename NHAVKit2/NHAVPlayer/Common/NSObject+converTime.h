//
//  NSObject+converTime.h
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/15.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (converTime)
/*!
 @method  计算视频时间。
 @discussion 根据传入的视频时间戳，换算成时间段。
 @param second 秒数
 
 */
+ (NSString *)convertTime:(float)second;

@end

NS_ASSUME_NONNULL_END
