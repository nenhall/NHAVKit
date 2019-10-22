//
//  NHPlayerProtocol.h
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/13.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NHAVPlayer;


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


/// 播放相关事件的代理方法
@protocol NHPlayerDelegate <NSObject>
@optional

/// 播放完成
/// @param player player description
- (void)nhPlayerPlayDone:(NHAVPlayer *)player;

/// 暂停播放
/// @param player player description
- (void)nhPlayerPause:(NHAVPlayer *)player;

/// 开始播放
/// @param player player description
- (void)nhPlayerPlay:(NHAVPlayer *)player;

/// 准备播放
/// @param player player description
- (void)nhPlayerReadyToPlay:(NHAVPlayer *)player;

/// 播放失败
/// @param player player description
/// @param error error description
/// @param playURL playURL description
- (void)nhPlayer:(NHAVPlayer *)player playFailed:(NSError *)error playURL:(NSString *)playURL;

/// 播放缓存进度更新
/// @param player player description
/// @param progress 进度
- (void)nhPlayer:(NHAVPlayer *)player updateCacheProgress:(float)progress;

/// 播放进度更新
/// @param player player description
/// @param progress 播放进度
- (void)nhPlayer:(NHAVPlayer *)player updatePlayProgress:(float)progress;

/// 用户拖拽进度条(在未自定义playToolBar时生效)
/// @param player player description
/// @param progress 拖拽后的进度
- (void)nhPlayer:(NHAVPlayer *)player dragSlider:(float)progress;

/// 在读取视频文件，准备播放后，设置/获取最大时长时调用(在未自定义playToolBar时，同时将要自动设置最大时长)
/// @param player player description
/// @param duration 视频的总时长
- (void)nhPlayer:(NHAVPlayer *)player setMaxDuration:(float)duration;

/// 全屏或者退出全屏
/// @param player player description
/// @param full true为全屏，否则非全屏(在未自定义playToolBar时生效)
- (void)nhPlayer:(NHAVPlayer *)player fullZoom:(BOOL)full;

@end



NS_ASSUME_NONNULL_END
