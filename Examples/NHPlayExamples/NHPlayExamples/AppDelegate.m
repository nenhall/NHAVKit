//
//  AppDelegate.m
//  NHPlayExamples
//
//  Created by nenhall on 2019/10/22.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSError *error =nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    BOOL isSuccess = [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    if (!isSuccess) {
        
        NSLog(@"__%@",error);
        
    }else{
        
        NSLog(@"成功了");
    }
    
}


// 防止在Xcode11以下编译不过问题
#ifdef __IPHONE_13_0

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Main" sessionRole:connectingSceneSession.role];
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];

}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#endif

@end
