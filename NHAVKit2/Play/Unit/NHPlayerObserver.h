//
//  NHPlayerObserver.h
//  NHPlayDemo
//
//  Created by nenhall on 2019/3/7.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "NHPlayerProtocol.h"


//NS_ASSUME_NONNULL_BEGIN

@protocol NHPlayerObserverDelegate <NSObject>

@optional
- (void)playerObserverStatusChanged:(NHPlayerStatus)status;

- (void)playerObserverUpdateCacheProgress:(float)time;

- (void)playerObserverUpdatePlayProgress:(CMTime)time;

- (void)playerObserverHandleInterruption:(NHPlayerInterruptionType)interruptionType info:(id)info;

- (void)playerObserverAudioRouteChange:(AVAudioSessionRouteChangeReason)reason info:(NSDictionary*)info;

- (void)playerObserverDeviceOrientationChange:(UIDeviceOrientation)orientation;

@end

@interface NHPlayerObserver : NSObject
@property (nonatomic, weak) AVPlayer *player;
@property (nonatomic, weak, readonly) id timeObserverToken;
@property (nonatomic, weak) id<NHPlayerObserverDelegate> delegate;

- (instancetype)initWithPlayer:(AVPlayer *)player;

/**
 添加player所有观察者： status、loadedTimeRanges...
 */
- (void)safeAddPlayerItemAllObservers;

/**
 移除player所有观察者
 */
- (void)safeRemovePlayerItemAllObservers;

/**
 添加设置相关所有观察者
 */
- (void)safeAddDeviceObserver;

/**
 移除设置相关所有观察者
 */
- (void)safeRemoveDeviceObserver;

@end

//NS_ASSUME_NONNULL_END
