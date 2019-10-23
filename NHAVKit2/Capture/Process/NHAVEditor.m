//
//  NHAVEditor.m
//  NHVideoProcessFramework
//
//  Created by nenhall on 2019/4/13.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHAVEditor.h"

@implementation NHAVEditor
- (id)initWithComposition:(AVMutableComposition *)composition videoComposition:(AVMutableVideoComposition *)videoComposition audioMix:(AVMutableAudioMix *)audioMix
{
    self = [super init];
    if(self != nil) {
        self.mutableComposition = composition;
        self.mutableVideoComposition = videoComposition;
        self.mutableAudioMix = audioMix;
    }
    return self;
}

- (void)performWithAsset:(AVAsset*)asset
{
    [self doesNotRecognizeSelector:_cmd];
}
@end
