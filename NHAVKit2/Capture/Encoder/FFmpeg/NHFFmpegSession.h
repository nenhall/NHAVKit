//
//  NHFFmpegSession.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/14.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHBeasSession.h"


NS_ASSUME_NONNULL_BEGIN

@interface NHFFmpegSession : NHBeasSession

#ifdef ENABLE_FFMPEG
/** 切换来源流：以摄像头作为音视频输入流 */
- (void)decoderFormCamera;

/** 切换来源流：以本地的文件作为音视频输入流 */
- (void)decoderFormLocalFile:(NSString *)filePath;

#endif
@end

NS_ASSUME_NONNULL_END
