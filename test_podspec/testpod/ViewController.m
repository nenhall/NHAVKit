//
//  ViewController.m
//  testpod
//
//  Created by nenhall on 2019/10/23.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "ViewController.h"
#import <NHAVKit2/NHPlayKit.h>
#import <NHAVKit2/NHCaptureKit.h>
#import <NHAVKit2/x264.h>
#import <NHAVKit2/libavcodec/avcodec.h>


@interface ViewController ()
@property (nonatomic, strong) NHAVPlayer *player;
@property (nonatomic, strong) NHAVCaptureSession *capture;
@property (nonatomic, strong) NHGPUImageView *imageView;
@property (nonatomic, strong) NHX264Manager *x264;
@property (nonatomic, strong) NHH264Encoder *x264Encoder;
@property (nonatomic, strong) NHFFmpegPlayer *ffmpegPlay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player = [NHAVPlayer playerWithView:self.view playUrl:nil];

    self.capture = [[NHAVCaptureSession alloc] initStreamWithInputURL:nil outputURL:nil];
    [self.capture startWriteMovieToFileWithOutputURL:nil];

    _x264 = [[NHX264Manager alloc] init];
    [_x264 encoding:nil];
    
    AVPacket *packet;
    
    _x264Encoder = [[NHH264Encoder alloc] init];
    [_x264Encoder encoding:0 timestamp:0];
    
    x264_nal_t x264t;
    x264t.i_first_mb;
    
}


@end
