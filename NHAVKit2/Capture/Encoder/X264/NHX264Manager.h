//
//  NHX264Manager.h
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/11.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NHX264Manager : NSObject


/**
 x264编码 (asys)

 @param sampleBuffer sampleBuffer
 */
- (void)encoding:(CMSampleBufferRef)sampleBuffer;

- (void)teardown;


@end

NS_ASSUME_NONNULL_END
