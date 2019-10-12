//
//  NSString+time.m
//  NHPlayFramework
//
//  Created by nenhall on 2019/3/11.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NSString+time.h"

@implementation NSString (time)

+ (NSString *)dealTime:(double)time {
    
    int tns, thh, tmm, tss;
    tns = time;
    thh = tns / 3600;
    tmm = (tns % 3600) / 60;
    tss = tns % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",thh,tmm,tss];
}

@end
