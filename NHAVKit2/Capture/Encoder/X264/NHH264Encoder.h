//
//  NHH264Encoder.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/18.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NHX264OutputProtocol.h"
#import "NHVideoConfiguration.h"


NS_ASSUME_NONNULL_BEGIN

@class NHVideoConfiguration;

@interface NHH264Encoder : NSObject <NHX264OutputProtocol>

@property (nonatomic, strong) id<NHX264OutputProtocol> outputDelegate;

- (instancetype)initWithVideoConfiguration:(NHVideoConfiguration *)videoConfiguration;

- (void)encoding:(CVPixelBufferRef)pixelBuffer timestamp:(CGFloat)timestamp;

- (void)teardown;


@end

NS_ASSUME_NONNULL_END
