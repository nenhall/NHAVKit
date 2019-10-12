//
//  AppDelegate.h
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/12.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 * 是否允许转向
 */
@property(nonatomic,assign)BOOL allowRotation;

@end

