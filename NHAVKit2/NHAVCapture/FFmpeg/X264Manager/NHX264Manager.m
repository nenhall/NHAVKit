//
//  NHX264Manager.m
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/11.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHX264Manager.h"
#import "NHH264Encoder.h"
#import "NHWriteH264Stream.h"
#import "NHVideoConfiguration.h"

@interface NHX264Manager ()

@end

@implementation NHX264Manager
{
    dispatch_queue_t     _encodeQueue;
    NHH264Encoder        *_x264Encoder;
    NHWriteH264Stream    *_writeH264Stream;
    NHVideoConfiguration *_videoConfiguration;
    CGSize               _captureVideoSize;
    BOOL                 _isVideoPortrait;
}

- (void)startRecord {
    [self initializeX264Encode];
    
}

- (void)teardown {
    dispatch_sync(_encodeQueue, ^{
        //        self.isRecording = NO;
        [_x264Encoder teardown];
        NSLog(@"停止录制.");
    });
}


- (void)initializeX264Encode {
    
    _encodeQueue = dispatch_queue_create("avcaptureSession", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(_encodeQueue, ^{
        _writeH264Stream = [[NHWriteH264Stream alloc] init];
        
        _videoConfiguration = [NHVideoConfiguration defaultConfiguration];
        _videoConfiguration.videoSize = _captureVideoSize;
        _videoConfiguration.frameRate = 30;
        _videoConfiguration.maxKeyframeInterval = 60;
        _videoConfiguration.bitrate = 1536*1000;
        _x264Encoder = [[NHH264Encoder alloc] initWithVideoConfiguration:_videoConfiguration];
        [_x264Encoder setOutputObject:_writeH264Stream];
        
//        self.isRecording = YES;
        NSLog(@"开始录制.");
    });
}


- (void)encoding:(CMSampleBufferRef)sampleBuffer {
    
    dispatch_sync(_encodeQueue, ^{
        
        CVPixelBufferRef pixelBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
        CMTime ptsTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
        CGFloat pts = CMTimeGetSeconds(ptsTime);
        
        [_x264Encoder encoding:pixelBufferRef timestamp:pts];
    });
}

@end
