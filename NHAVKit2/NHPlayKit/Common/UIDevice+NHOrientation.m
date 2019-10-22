//
//  UIDevice+NHOrientation.m
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/14.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import "UIDevice+NHOrientation.h"

@implementation UIDevice (NHOrientation)

- (void)setInterfaceOrientations:(UIInterfaceOrientation)interfaceOrientation
{
  
  
  NSNumber *orientationTarget = [NSNumber numberWithInteger:interfaceOrientation];
  
  [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
  
}
@end

