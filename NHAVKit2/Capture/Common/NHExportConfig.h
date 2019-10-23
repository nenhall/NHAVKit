//
//  NHExportConfig.h
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/23.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NHExportConfig : NSObject
@property (nonatomic, copy) NSURL *exportUrl;
/**
 default:AVAssetExportPreset1280x720
 */
@property (nonatomic, copy) NSString *presetName;

/**
 default:AVFileTypeMPEG4
 */
@property (nonatomic, copy) AVFileType outputFileType;
/* indicates that the output file should be optimized for network use, e.g. that a QuickTime movie file should support "fast start"
 default: YES
 */
@property (nonatomic) BOOL shouldOptimizeForNetworkUse;

@end

NS_ASSUME_NONNULL_END
