//
//  NHPlayerPrivateProtocol.h
//  NHPlayKit
//
//  Created by nenhall on 2019/10/15.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 播放工具条的相关事件代理
@protocol NHPlayerToolBarDelegate <NSObject>
@optional
- (BOOL)playerToolBarDidClickPlayOrPause;

- (void)playerToolBarDidClickPause;

- (BOOL)playerToolBarDidClickVideoZoom;

- (void)playerToolBarDragSlider:(float)value;
@end

@protocol NHPlayerPrivateProtocol <NSObject>

- (void)updateCacheProgress:(float)progress;

- (void)updatePlayProgress:(float)progress;

- (void)setMaxDuration:(float)duration;

- (void)fullZoom:(BOOL)full;

- (void)play;

- (void)playDone;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
