//
//  NHAVPlayer.m
//  NHPlayFramework
//
//  Created by nenhall on 2018/11/12.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHAVPlayer.h"
#import <UIDevice+NHOrientation.h>
#import <NHPlayerObserver.h>


@interface NHAVPlayer ()<NHPlayerToolBarDelegate,NHPlayerObserverDelegate>
@property (nonatomic, strong) NHPlayerObserver *playerObs;
@property (nonatomic, strong) NHPlayerView *playerView;
@property (nonatomic, weak  ) AVPlayerItem *currentPlayItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy  ) NSString *playUrl;
@property (nonatomic, strong) id timeObserverToken;
@property (nonatomic, assign) float playProgress;
@property (nonatomic, assign) float cacheProgress;
@property (nonatomic, assign) float totalDuration;
@property (nonatomic, assign) BOOL autoPause;
@property (nonatomic, assign) float rate;
@property (nonatomic, copy  ) NSArray <NSLayoutConstraint *>*pViewConstraints;
@end

@implementation NHAVPlayer

+ (instancetype)playerWithView:(UIView *)view playUrl:(NSString *)playUrl {
    return [[NHAVPlayer alloc] initPlayerWithView:view playUrl:playUrl];
}

- (instancetype)initPlayerWithView:(UIView *)view
                           playUrl:(NSString *)playUrl {
    self = [super init];
    if (self) {
        _playUrl = playUrl;
        _playSuperView = view;
        [self initializeConfigure];
        [self initializePlayer];
        [self addPlayerView:view];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeConfigure];
        [self initializePlayer];
    }
    return self;
}

#pragma mark - initialize
#pragma mark -
- (void)initializeConfigure {
    //NSURLCache
    NSURLCache *URLCache =[[NSURLCache alloc]initWithMemoryCapacity:4*1024*1024 diskCapacity:20*1024*1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    //管理音频会话模式
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
}

/**
 初始化播放器
 */
- (void)initializePlayer {
    _currentPlayItem = [self markPlayerItemWithUrlString:_playUrl];
    if (!_player) {
        if (_currentPlayItem) {
            _player = [AVPlayer playerWithPlayerItem:_currentPlayItem];
        } else {
            _player = [[AVPlayer alloc] init];
        }
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        if (@available(iOS 9.0, *)) {
            _currentPlayItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO;
        }
        if (@available(iOS 10.0, *)) {
            _currentPlayItem.preferredForwardBufferDuration = 5;
            _player.automaticallyWaitsToMinimizeStalling = NO;
        }
        // 播放相关的监听
        _playerObs = [[NHPlayerObserver alloc] initWithPlayer:_player];
        _playerObs.delegate = self;
    }
}

- (void)setPlaySuperView:(UIView *)playSuperView {
    [_playSuperView removeFromSuperview];
    _playSuperView = playSuperView;
    [self addPlayerView:playSuperView];
}

/**
 生成AVPlayerItem
 @param string playurl
 */
- (AVPlayerItem *)markPlayerItemWithUrlString:(NSString *)string {
    
    if (!string) {
        NSLog(@"播放地址为空...");
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:string];
    if ([string hasPrefix:@"/var"]) {
        url = [NSURL fileURLWithPath:string];
    }
    
    /**
     AVURLAssetPreferPreciseDurationAndTimingKey:
     用来表明资源是否需要为时长的精确展示,以及随机时间内容的读取进行提前准备
     */
    NSDictionary *options = @{
                              AVURLAssetPreferPreciseDurationAndTimingKey : [NSNumber numberWithBool:YES]
                              };
    
    NSArray *assetKeys = @[ @"playable", @"hasProtectedContent" ];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:options];
    AVPlayerItem *newPlayItem = [AVPlayerItem playerItemWithAsset:urlAsset automaticallyLoadedAssetKeys:assetKeys];
    
    return newPlayItem;
}

#pragma mark - private method
#pragma mark -
- (void)play {
    if (_playStatus == NHPlayerStatusPaused) {
        if ((_totalDuration == _playProgress) && _totalDuration > 0) {
            [self playerToolBarDragSlider:0.0];
        }
    }
    [_player play];
}

- (void)pause {
    [_player pause];
    _playStatus = NHPlayerStatusPaused;
}

//设置播放倍速
- (void)setPlayerRate:(CGFloat )rate{
    _rate = rate;
    int status = 0;
    if (_playStatus == NHPlayerStatusPlaying) {
        status = 1;
    }
    if(self.player) self.player.rate = rate;
    if (!status) {
        [_player pause];
    }
}

- (void)replaceCurrentItemWithPlayUrl:(NSString *)playUrl {
    _playUrl = playUrl;
    [self initializePlayer];
    [_playerObs safeRemovePlayerItemAllObservers];
    [_player replaceCurrentItemWithPlayerItem:_currentPlayItem];
    [_playerObs safeAddPlayerItemAllObservers];
}

#pragma mark - NHPlayerObserverDelegate
#pragma mark -
- (void)playerObserverHandleInterruption:(NHPlayerInterruptionType)interruptionType info:(id)info {
    //判断开始中断还是中断已经结束
    if (interruptionType == NHPlayerInterruptionTypeBegan) {
        //停止播放
        [self.player pause];
        
    } else {
        [self.player play];
    }
}


- (void)playerObserverStatusChanged:(NHPlayerStatus)status {
    _playStatus = status;
    
    switch (status) {
        case NHPlayerStatusReadyToPlay:{
//            #if defined(__arm64__)
            CMTime duration = _currentPlayItem.duration;
            NSLog(@"Ready to Play duration:%f", CMTimeGetSeconds(duration));
            if (!isnan(CMTimeGetSeconds(duration))) {
                [_playerView setMaxDuration:CMTimeGetSeconds(duration)];
                CMTimeShow(duration);
            }
//            #endif
        }
            break;
        case NHPlayerStatusPlaying:{
            [_playerView updatePlayStatus:status];
        }
            break;
        case NHPlayerStatusPaused:{
            [_playerView updatePlayStatus:status];
        }
            
            break;
        case NHPlayerStatusBufferEmpty:
            
            break;
        case NHPlayerStatusFailed:{
            [_playerView updatePlayStatus:status];
        }
            
            break;
        case NHPlayerStatusFinished:
            [_playerView playDone];
            
            break;
        case NHPlayerStatusStalled:{
            [_playerView updatePlayStatus:status];
        }
            
            break;
        case NHPlayerStatusInterruption:{
            [_playerView updatePlayStatus:status];
        }
            
            break;
        case NHPlayerStatusUnknown:
            
            break;
        default:
            break;
    }
    
}

- (void)playerObserverUpdateCacheProgress:(float)progress {
    
    NSTimeInterval timeInterval = [NHImageHandle availableDurationRanges:_currentPlayItem];
    _totalDuration = CMTimeGetSeconds(_currentPlayItem.duration); // 总时间
    float cacheProgress = timeInterval / _totalDuration;
    _cacheProgress = timeInterval * 1.0;
    if ((_cacheProgress > _playProgress) && _autoPause) {
        _autoPause = NO;
        [_playerView play];
        _playStatus = NHPlayerStatusPlaying;
        [_player play];
    }
    [_playerView updateCacheProgress:cacheProgress];
}

- (void)playerObserverUpdatePlayProgress:(CMTime)time {
    if (self.currentPlayItem) {
        // 当前播放时间：秒
        self.playProgress = self.currentPlayItem.currentTime.value / self.currentPlayItem.currentTime.timescale;
        [self.playerView updatePlayProgress:self.playProgress];
    } else {
        NSLog(@"Current PlayItem is null");
    }
}

- (void)playerObserverDeviceOrientationChange:(UIDeviceOrientation)orientation {
    if (UIDeviceOrientationIsPortrait(orientation)) {
         _isFullScreen = NO;
     } else if (UIDeviceOrientationIsLandscape(orientation)) {
         _isFullScreen = YES;
     }
     [_playerView fullZoom:_isFullScreen];
}

- (void)playerObserverAudioRouteChange:(AVAudioSessionRouteChangeReason)reason info:(NSDictionary *)info{
    NSLog(@"耳机插入、拔出事件");
    
    switch (reason) {
        case AVAudioSessionRouteChangeReasonUnknown:
            
            break;
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            //判断为耳机接口
            AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
            AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
            NSString *portType = previousOutput.portType;
            
            if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
                // 拔掉耳机继续播放
                if (self.playStatus == NHPlayerStatusPlaying) {
                    [self.player play];
                }
            }
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            
            break;
        case AVAudioSessionRouteChangeReasonRouteConfigurationChange:
            
            break;
    }
}


#pragma mark - NHPlayerToolBarDelegate
#pragma mark -
- (BOOL)playerToolBarDidClickPlayOrPause {
    
    if (_playStatus == NHPlayerStatusPlaying || _playStatus == NHPlayerStatusBufferEmpty) {
        [_player pause];
        return NO;
        
    } else {
        [_player play];
        return YES;
    }
}

- (BOOL)playerToolBarDidClickVideoZoom {
    if (_isFullScreen) {
        //调用横屏代码
        _isFullScreen = NO;
        [[UIDevice currentDevice] setInterfaceOrientations:UIInterfaceOrientationPortrait];
        return NO;
    } else {
        _isFullScreen = YES;
        [[UIDevice currentDevice]setInterfaceOrientations:UIInterfaceOrientationLandscapeRight];
        return YES;
    }
}

- (void)playerToolBarDragSlider:(float)value {
    __block CMTime newTime = CMTimeMake(value, 1);
    __weak typeof(self)weakself = self;
    [_currentPlayItem seekToTime:newTime completionHandler:^(BOOL finished) {
        if ((CMTimeGetSeconds(newTime) > weakself.cacheProgress)) {
            weakself.autoPause = YES;
            [weakself.player pause];
            weakself.playStatus = NHPlayerStatusPaused;
            [weakself.playerView pause];
        }
    }];
}


#pragma mark - private sett / gett
#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", keyPath);
}
- (void)addPlayerView:(UIView *)view {
    if (!view) {
        NSLog(@"Player Super View can't null");
        return;
    }
    [view addObserver:self forKeyPath:@"subviews" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
//    [self.playerView removeConstraints:_pViewConstraints];
//    [self.playerView removeFromSuperview];

    [view addSubview:self.playerView];
    _playerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_playerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_playerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_playerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    _pViewConstraints = @[ left, right, top, bottom ];
    [view addConstraints:_pViewConstraints];
}

- (NHPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[NHPlayerView alloc] initWithPlayer:_playerLayer];
        _playerView.barDelegate = self;
    }
    return _playerView;
}

- (void)releasePlayer {
    [_playerObs safeRemoveDeviceObserver];
    [_playerObs safeRemovePlayerItemAllObservers];
}


- (void)dealloc {
    [self releasePlayer];
    NSLog(@"%s",__func__);
}


@end
