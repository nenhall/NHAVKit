//
//  NSString+time.h
//  NHPlayFramework
//
//  Created by nenhall on 2019/3/11.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (time)


/**
 转换：@"%02d:%02d:%02d"
 */
+ (NSString *)dealTime:(double)time;

@end

NS_ASSUME_NONNULL_END
