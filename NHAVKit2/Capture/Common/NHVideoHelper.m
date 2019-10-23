//
//  NHVideoHelper.m
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/23.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHVideoHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation NHVideoHelper

//导出视频
- (void)exportVidelWithUrl:(NSURL *)url
              exportConfig:(nonnull NHExportConfig *)config
                  progress:(nonnull void (^)(CGFloat))progress
                 completed:(void (^)(NSURL *exportURL, NSError *error))completed
          savedPhotosAlbum:(BOOL)save {
    
    NSLog(@"压缩前文件大小：%f",[self fileSize:url]);
    
    if (!url) {
        NSLog(@"导出路径无效!");
    }
    
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSArray *exportSessions = [AVAssetExportSession exportPresetsCompatibleWithAsset:avasset];
    BOOL containsObj = [exportSessions containsObject:AVAssetExportPresetLowQuality];
    
    if (containsObj) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avasset presetName:config.presetName];
        exportSession.outputURL = config.exportUrl;
        exportSession.shouldOptimizeForNetworkUse = config.shouldOptimizeForNetworkUse;
        exportSession.outputFileType = config.outputFileType;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                NSLog(@"压缩完毕，文件大小：%f",[self fileSize:config.exportUrl]);
                if (completed) {
                    completed(config.exportUrl, exportSession.error);
                }
                if (save) {
                    [self saveVidelToPhoto:config.exportUrl];
                }
            } else if (exportSession.status == AVAssetExportSessionStatusExporting) {
                NSLog(@"压缩进度：%f",exportSession.progress);
                if (progress) {
                    progress(exportSession.progress);
                }
            } else if (exportSession.status == AVAssetExportSessionStatusWaiting) {
                NSLog(@"压缩进度：%f",exportSession.progress);
                if (progress) {
                    progress(exportSession.progress);
                }
            }
        }];
        
    }
}

//保存到相册
- (void)saveVidelToPhoto:(NSURL *)outputFileURL {
    
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"保存到相册出错");
        } else {
            NSLog(@"保存到相册成功");
        }
    }];
}

- (CGFloat)fileSize:(NSURL *)path {
    return [[NSData dataWithContentsOfURL:path] length] / 1024.00 / 1024.00;
}

@end
