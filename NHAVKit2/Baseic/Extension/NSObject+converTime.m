//
//  NSObject+converTime.m
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/15.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import "NSObject+converTime.h"

@implementation NSObject (converTime)

/*!
 @method  计算视频时间。
 @discussion 根据传入的视频时间戳，换算成时间段。
 @param second 秒数
 
 */
+ (NSString *)convertTime:(float)second {
    // 相对格林时间
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  
  if (second / 3600 >= 1) {
    [formatter setDateFormat:@"HH:mm:ss"];
  } else {
    [formatter setDateFormat:@"mm:ss"];
  }
  
  NSString *showTimeNew = [formatter stringFromDate:date];
  return showTimeNew;
}

@end
