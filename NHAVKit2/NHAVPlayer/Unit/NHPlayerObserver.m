//
//  NHPlayerObserver.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/3/7.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHPlayerObserver.h"
#import <UIKit/UIKit.h>
#import "UIDevice+NHOrientation.h"
#import "NHKVOOwner.h"


static NSString *kStatus = @"status";
static NSString *kTimeControlStatus = @"timeControlStatus";
static NSString *kLoadedTimeRanges = @"loadedTimeRanges";
static NSString *kPlaybackBufferEmpty = @"playbackBufferEmpty";
static NSString *kPlaybackLikelyToKeepUp = @"playbackLikelyToKeepUp";


@interface NHPlayerObserver ()
@property (nonatomic, weak) AVPlayerItem *playerItem;
@property (nonatomic, weak) id timeObserverToken;
@property (nonatomic, strong) NSMutableArray *kvoOwner;
@end

@implementation NHPlayerObserver

- (instancetype)initWithPlayer:(AVPlayer *)player {
    self = [super init];
    if (self) {
        _player = player;
        _playerItem = player.currentItem;
        
        [self safeAddDeviceObserver];
        [self safeAddPlayerItemAllObservers];
    }
    return self;
}

- (void)safeAddDeviceObserver {
    // 回到app
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    // 将要离开app
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    //中断的通知: 如来电话
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleInterruption:)
//                                                 name:AVAudioSessionInterruptionNotification
//                                               object:[AVAudioSession sharedInstance]];
    
    //耳机插入和拔掉通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(audioRouteChangeListenerCallback:)
//                                                 name:AVAudioSessionRouteChangeNotification
//                                               object:[AVAudioSession sharedInstance]];
    
}

- (void)safeRemoveDeviceObserver {
    // 回到app
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 将要离开app
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    //中断的通知: 如来电话
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    //耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
}

/**
 添加 status、loadedTimeRanges观察者
 */
- (void)safeAddPlayerItemAllObservers {
    
    [self safeRemovePlayerItemAllObservers];
    
    if (!_player)  return;

    _playerItem = _player.currentItem;
    
    // 观察播放状态
    if (@available(iOS 10.0, *)) {
        [self safeAddObserver:_player forKeyPath:kTimeControlStatus options:NSKeyValueObservingOptionNew context:nil];
    }
    
    // 添加播放进度观察
    [self addPlayTimeObserve];
    
    // 观察status属性
    [self safeAddObserver:_playerItem forKeyPath:kStatus options:NSKeyValueObservingOptionNew context:nil];
    
    // 观察缓冲进度
    [self safeAddObserver:_playerItem forKeyPath:kLoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    
    // 当缓存不够,视频加载不出来的情况
    [self safeAddObserver:_playerItem forKeyPath:kPlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    
    //  缓存是否可以满足播放
    [self safeAddObserver:_playerItem forKeyPath:kPlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
    
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    // 播放失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFailed:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    
    // 异常中断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStalled:) name:AVPlayerItemPlaybackStalledNotification object:nil];
}

- (void)safeRemovePlayerItemAllObservers{
    if (!_player)  return;
    _playerItem = _player.currentItem;
    
    [_playerItem cancelPendingSeeks];

    /** 移除播放时间通知 */
    if (self.timeObserverToken) {
        [self.player removeTimeObserver:self.timeObserverToken];
        self.timeObserverToken = nil;
    }
    
    // 取消观察播放状态
    [self safeRemovePlayItemObserver];
    
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[AVAudioSession sharedInstance]];
    // 播放失败
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:[AVAudioSession sharedInstance]];
    // 异常中断
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:[AVAudioSession sharedInstance]];
}

- (void)safeRemovePlayItemObserver {
    [_kvoOwner enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NHKVOOwner *owner = obj;
        if (owner == nil) return;
        NSObject *observer = owner.observer;
        if (observer == nil) return;
        @try {
            [observer removeObserver:self
                      forKeyPath:owner.keyPath];
        } @catch (NSException *e) {
            NSLog(@"NHPlay-KVO: failed to remove observer for %@\n", owner.keyPath);
        }
    }];
    
    [_kvoOwner removeAllObjects];
}


/**
 添加播放进度观察
 */
- (void)addPlayTimeObserve {
        __weak typeof(self)weakself = self;
    _timeObserverToken = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                               queue:dispatch_get_main_queue()
                                                          usingBlock:^(CMTime time)
                          {
                              if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(playerObserverUpdatePlayProgress:)]) {
                                  [weakself.delegate playerObserverUpdatePlayProgress:time];
                              }
                              
                          }];
}


#pragma mark - observe receiver center
#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    NSLog(@"keyPath：%@",keyPath);
    
    NHPlayerStatus playerStatus = NHPlayerStatusUnknown;
    
    if ([keyPath isEqualToString:kPlaybackBufferEmpty]) {
        playerStatus = NHPlayerStatusBufferEmpty;
        
    } else if ([keyPath isEqualToString:kStatus]) {
        AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
        NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
        if ([statusNumber isKindOfClass:[NSNumber class]]) {
            status = statusNumber.integerValue;
        }
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                playerStatus = NHPlayerStatusReadyToPlay;
                break;
            case AVPlayerItemStatusFailed:
                playerStatus = NHPlayerStatusFailed;
                break;
            case AVPlayerItemStatusUnknown:
                playerStatus = NHPlayerStatusUnknown;
                break;
        }
        
    } else if ([keyPath isEqualToString:kTimeControlStatus]) {
        NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
        if (@available(iOS 10.0, *)) {
            AVPlayerTimeControlStatus status = AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate;
            if ([statusNumber isKindOfClass:[NSNumber class]]) {
                status = statusNumber.integerValue;
            }
            switch (status) {
                case AVPlayerTimeControlStatusPaused:
                    playerStatus = NHPlayerStatusPaused;
                    break;
                    
                case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
                    playerStatus = NHPlayerStatusReadyToPlay;
                    break;
                    
                case AVPlayerTimeControlStatusPlaying:
                    playerStatus = NHPlayerStatusPlaying;
                    break;
            }
            
        } else {
            NSLog(@"keyPath: kTimeControlStatus");
        }
    } else if ([keyPath isEqualToString:kLoadedTimeRanges]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverUpdateCacheProgress:)]) {
            [self.delegate playerObserverUpdateCacheProgress:0];
        }
        return;
    } else if ([keyPath isEqualToString:kPlaybackLikelyToKeepUp]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverUpdateCacheProgress:)]) {
            [self.delegate playerObserverUpdateCacheProgress:0];
        }
        return;
    }

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverStatusChanged:)]) {
        [self.delegate playerObserverStatusChanged:playerStatus];
    }
}

- (void)playbackFinished:(NSNotification *)note {
    NSLog(@"播放完成");
    [[UIDevice currentDevice] setInterfaceOrientations:UIInterfaceOrientationPortrait];
//    OSStatus ret = AudioSessionSetActiveWithFlags(NO, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverStatusChanged:)]) {
        [self.delegate playerObserverStatusChanged:NHPlayerStatusFinished];
    }
}

- (void)playbackFailed:(NSNotification *)note {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverStatusChanged:)]) {
        [self.delegate playerObserverStatusChanged:NHPlayerStatusFailed];
    }
}

- (void)playbackStalled:(NSNotification *)note {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverStatusChanged:)]) {
        [self.delegate playerObserverStatusChanged:NHPlayerStatusStalled];
    }
}

/**
 中断事件
 */
- (void)handleInterruption:(NSNotification *)notification{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverStatusChanged:)]) {
        [self.delegate playerObserverStatusChanged:NHPlayerStatusInterruption];
    }
   
    NSDictionary *info = notification.userInfo;
    NSLog(@"中断事件: %@",info);
    
    AVAudioSessionInterruptionType type =[info[AVAudioSessionInterruptionTypeKey] integerValue];
    NHPlayerInterruptionType interruptionType = NHPlayerInterruptionTypeBegan;

    //判断开始中断还是中断已经结束
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //停止播放
        
    } else {
        //如果中断结束会附带一个KEY值，表明是否应该恢复音频
        AVAudioSessionInterruptionOptions options =[info[AVAudioSessionInterruptionOptionKey] integerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            //恢复播放
            interruptionType = NHPlayerInterruptionTypeEnded;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverHandleInterruption:info:)]) {
        [self.delegate playerObserverHandleInterruption:interruptionType info:info];
    }
}


/**
 耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverAudioRouteChange:info:)]) {
        [self.delegate playerObserverAudioRouteChange:routeChangeReason info:interuptionDict];
    }
}

- (void)appBecomeActive:(NSNotification *)note {
    
}

- (void)appWillResignActive:(NSNotification *)note {
    
}

- (void)deviceOrientationChange:(NSNotification *)note {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerObserverDeviceOrientationChange:)]) {
        [self.delegate playerObserverDeviceOrientationChange:orientation];
    }
}

#pragma mark - safe add or remove observer
#pragma mark -
- (void)safeAddObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context {
    BOOL isExist = [self objIsExistKVOOwner:observer forKeyPath:keyPath];
    if (isExist) {
        // duplicated register
        NSLog(@"duplicated observer");
    }
    @try {
        [observer addObserver:self forKeyPath:keyPath options:options context:context];
        
        NHKVOOwner *owner = [[NHKVOOwner alloc] init];
        owner.observer = observer;
        owner.keyPath  = keyPath;
        [self.kvoOwner addObject:owner];
    } @catch (NSException *e) {
        NSLog(@"NHPlay-KVO: failed to add observer for %@\n", keyPath);
    }
}

- (void)safeRemoveObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
                   context:(void *)context {
    BOOL isExist = [self objIsExistKVOOwner:observer forKeyPath:keyPath];
    if (isExist) {
        // duplicated register
        NSLog(@"duplicated observer");
    }
    
    @try {
        if (isExist) {
            [observer removeObserver:self forKeyPath:keyPath context:context];
        }
    } @catch (NSException *e) {
        NSLog(@"NHPlay-KVO: failed to remove observer for %@\n", keyPath);
    }
}

- (BOOL)objIsExistKVOOwner:(NSObject *)observer
                forKeyPath:(NSString *)keyPath {
    __block NSInteger foundIndex = -1;
    [self.kvoOwner enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NHKVOOwner *owner = (NHKVOOwner *)obj;
        if (owner.observer == observer && [owner.keyPath isEqualToString:keyPath]) {
            foundIndex = idx;
            *stop = YES;
        }
    }];
    
    if (foundIndex > -1) {
        [_kvoOwner removeObjectAtIndex:foundIndex];
        return YES;
    }
    return NO;
}

#pragma mark - private sett / gett
#pragma mark -
- (void)setPlayer:(AVPlayer *)player {
    [self safeAddPlayerItemAllObservers];
    _player = player;
    _playerItem = player.currentItem;
}

- (NSMutableArray *)kvoOwner {
    if (!_kvoOwner) {
        _kvoOwner = [[NSMutableArray alloc] init];
    }
    return _kvoOwner;
}

//- (void)appBecomeActive {
//    @try {
//        [self.player seekToTime:self.time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//            if (finished) {
//                [self.player play];
//            }
//        }];
//    } @catch (NSException *exception) {
//        [self.player play];
//    }
////在继续播放的时候可能会后退一定的时间，而如果我们想要精准地继续播放则需要下面这个方法
//[self.player seekToTime:self.time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:nil];
//}

- (void)dealloc {
    [self safeRemoveDeviceObserver];
    [self safeRemovePlayerItemAllObservers];
    NSLog(@"%s",__func__);
}

@end
