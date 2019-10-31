//
//  NHAVPlayer.h
//  NHPlayFramework
//
//  Created by nenhall on 2018/11/12.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NHImageHandle.h"
#import "NHPlayerProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface NHAVPlayer : NSObject

/// 播放对象代理
@property (nonatomic, weak) id<NHPlayerDelegate> delegate;

/// 播放地址
@property (nonatomic, copy, readonly) NSString *playUrl;

/// 播放状态
@property (nonatomic, assign) NHPlayerStatus playStatus;

/// 强制横屏
@property (nonatomic, assign) BOOL isFullScreen;

/// 点击toolbar显示隐藏手势，默认yes
@property (nonatomic, assign) BOOL enableToolBarOnTapGesture;

/// 自定义工具条，默认false，如果 true 所有相关工具条都会隐藏
@property (nonatomic, assign) BOOL customToolBar;

/// 播放层的父视图，由外部自定义
@property (nonatomic, weak  ) UIView *playSuperView;

@property (nonatomic, weak, readonly) AVPlayerItem *currentPlayItem;

/// 初始化播放器
/// @param view 播放层的父视图，由外部自定义
/// @param playUrl 播放地址
- (instancetype)initPlayerWithView:(UIView *)view playUrl:(NSString *)playUrl;

/// 初始化播放器
/// @param view 播放层的父视图，由外部自定义
/// @param playUrl 播放地址
+ (instancetype)playerWithView:(UIView *)view playUrl:(NSString *)playUrl;

/*!
 @method    play
 @abstract    Signals the desire to begin playback at the current item's natural rate.
 @discussion  Equivalent to setting the value of rate to 1.0.
 */
- (void)play;

/*!
 @method    pause
 @abstract    Pauses playback.
 @discussion  Equivalent to setting the value of rate to 0.0.
 */
- (void)pause;


/*!
 @method            replaceCurrentItemWithPlayerItem:
 @abstract        Replaces the player's current item with the specified player item.
 @param            playUrl
 The AVPlayerItem that will become the player's current item.
 @discussion
 In all releases of iOS 4, invoking replaceCurrentItemWithPlayerItem: with an AVPlayerItem that's already the receiver's currentItem results in an exception being raised. Starting with iOS 5, it's a no-op.
 */
- (void)replaceCurrentItemWithPlayUrl:(nullable NSString *)playUrl;

/**
 设置播放倍速 natural rate is 1.0
 0.0 means "paused", 1.0 indicates a desire to play at the natural rate of the current item.
 @param rate 倍速
 */
- (void)setPlayerRate:(CGFloat )rate;


- (void)releasePlayer;

@end

NS_ASSUME_NONNULL_END
