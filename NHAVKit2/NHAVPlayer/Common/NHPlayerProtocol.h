//
//  NHPlayerProtocol.h
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/13.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, NHPlayerInterruptionType) {
    NHPlayerInterruptionTypeBegan = (1 << 1), /**< 中断开始 eg. 来电 */
    NHPlayerInterruptionTypeEnded = (2 << 1), /**< 中断结束 eg. 来电 */
} NS_ENUM_AVAILABLE(10_12, 8_0);

typedef NS_ENUM(NSInteger, NHPlayerStatus) {
    NHPlayerStatusUnknown = (1 << 1), /**< 未知状态 */
    NHPlayerStatusReadyToPlay = (2 << 1), /**< 准备好播放 */
    NHPlayerStatusPaused = (3 << 1), /**< 播放暂停 */
//    NHPlayerStatusWaitingToPlayAtSpecifiedRate, /**< 准备好播放 */
    NHPlayerStatusPlaying = (4 << 1), /**< 播放中 */
    NHPlayerStatusBufferEmpty = (5 << 1), /**< 当缓存不够,视频加载不出来 */
    NHPlayerStatusFinished = (6 << 1), /**< 播放完成 */
    NHPlayerStatusFailed = (7 << 1), /**< 播放失败 */
    NHPlayerStatusStalled = (8 << 1), /**< 异常中断 */
    NHPlayerStatusInterruption = (9 << 1), /**< 中断 eg. 来电 */
} NS_ENUM_AVAILABLE(10_12, 8_0);


@protocol NHPlayerToolBarDelegate <NSObject>
@optional
- (BOOL)playerToolBarDidClickPlayOrPause;

- (void)playerToolBarDidClickPause;

- (BOOL)playerToolBarDidClickVideoZoom;

- (void)playerToolBarDragSlider:(float)value;
@end



@protocol NHPlayerActionDelegate <NSObject>
@optional
- (void)playDone;
- (void)pause;
- (void)play;
- (void)readyToPlay;
- (void)updateCacheProgress:(float)progress;
- (void)updatePlayProgress:(float)progress;
- (void)setMaxDuration:(float)duration;
- (void)fullZoom:(BOOL)full;


@end


NS_ASSUME_NONNULL_END
