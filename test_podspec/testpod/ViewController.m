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
@property (nonatomic, strong) NHAVCapture *capture;
@property (nonatomic, strong) NHGPUImageView *imageView;
@property (nonatomic, strong) NHX264Manager *x264;
@property (nonatomic, strong) NHFFmpegPlayer *ffmpegPlay;
@property (nonatomic, strong) NHFrameImage *fImage;
@property (nonatomic, strong) NHGifTool *gitTool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player = [NHAVPlayer playerWithView:self.view playUrl:@""];

    self.capture = [[NHAVCapture alloc] initStreamWithInputURL:[NSURL URLWithString:@""]
                                                     outputURL:[NSURL URLWithString:@""]];
    [self.capture startWriteMovieToFileWithOutputURL:[NSURL URLWithString:@""]];

    _x264 = [[NHX264Manager alloc] init];
    CMSampleBufferRef bufferRef;
    [_x264 encoding:bufferRef];
    
}


@end
