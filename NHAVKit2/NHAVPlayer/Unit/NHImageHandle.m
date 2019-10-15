//
//  NHImageHandle.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/3/7.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHImageHandle.h"

@implementation NHImageHandle

//获取视频宽高比
+ (CGFloat)getVideoScale:(NSURL *)url{
    
    if (!url) return 0.0f;
    //获取视频尺寸
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    
    return videoSize.height/videoSize.width;
}


+ (UIImage *)getCoverImageFromVideoURL:(NSURL *)url time:(NSTimeInterval )videoTime{

    if (!url) return nil;
    
    UIImage *shotImage;
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    if ([urlString hasPrefix:@"/var"]) {
        url = [NSURL fileURLWithPath:urlString];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(videoTime, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    if (error) {
        NSLog(@"获取封面失败：%@",error.localizedDescription);
    }
    
    return shotImage;
}

/**
 计算缓冲进度
 */
+ (NSTimeInterval)availableDurationRanges:(AVPlayerItem *)playItme {
    NSArray *loadedTimeRanges =  [playItme loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

@end
