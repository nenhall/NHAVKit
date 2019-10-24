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


@interface ViewController ()
@property (nonatomic, strong) NHAVPlayer *player;
@property (nonatomic, strong) NHAVCaptureSession *capture;
@property (nonatomic, strong) NHGPUImageView *imageView;
@property (nonatomic, strong) NHX264Manager *x264;
@property (nonatomic, strong) NHWriteH264Stream *wirter;
//@property (nonatomic, strong) NHFFmpegPlayer *captureSession;

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
    [self.wirter writeFrame:*packet streamIndex:nil];
    
    x264_nal_t x264t;
    x264t.i_first_mb;
    
}


@end
