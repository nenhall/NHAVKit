//
//  NHAVEditor.h
//  NHVideoProcessFramework
//
//  Created by nenhall on 2019/4/13.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NHAVEditor : NSObject
@property AVMutableComposition *mutableComposition;
@property AVMutableVideoComposition *mutableVideoComposition;
@property AVMutableAudioMix *mutableAudioMix;
@property CALayer *watermarkLayer;

- (id)initWithComposition:(AVMutableComposition*)composition videoComposition:(AVMutableVideoComposition*)videoComposition audioMix:(AVMutableAudioMix*)audioMix;

- (void)performWithAsset:(AVAsset*)asset;

@end

NS_ASSUME_NONNULL_END
