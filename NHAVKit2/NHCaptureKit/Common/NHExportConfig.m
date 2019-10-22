//
//  NHExportConfig.m
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/23.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHExportConfig.h"

@implementation NHExportConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _presetName = AVAssetExportPreset1280x720;
        _shouldOptimizeForNetworkUse = YES;
        _outputFileType = AVFileTypeMPEG4;
    }
    return self;
}

@end
