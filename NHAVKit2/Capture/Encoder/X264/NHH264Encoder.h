//
//  NHH264Encoder.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/18.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NHVideoConfiguration.h"
#import "NHX264OutputProtocol.h"
#import "NHCaptureSessionProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface NHH264Encoder : NSObject <NHX264OutputProtocol>
#ifdef ENABLE_FFMPEG

@property (nonatomic, strong) id<NHX264OutputProtocol> outputObject;

- (instancetype)initWithVideoConfiguration:(NHVideoConfiguration *)videoConfiguration;

- (void)encoding:(CVPixelBufferRef)pixelBuffer timestamp:(CGFloat)timestamp;

- (void)teardown;


#endif

@end

NS_ASSUME_NONNULL_END
