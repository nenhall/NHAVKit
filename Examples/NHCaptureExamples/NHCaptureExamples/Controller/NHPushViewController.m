//
//  NHPushViewController.m
//  NHCaptureDemo
//
//  Created by nenhall on 2019/3/17.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHPushViewController.h"
#import <NHPlayKit/NHPlayKit.h>



#define kMoveSourcesPath  [[NSBundle mainBundle] pathForResource:@"I’m-so-sick-1080P—Apink" ofType:@"mp4"]


@interface NHPushViewController ()<NHFFmpegPlayerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *previewView;
@property (weak, nonatomic) IBOutlet UITextView *pushTextView;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;
@property (weak, nonatomic) IBOutlet UIButton *paseBtn;
@property (weak, nonatomic) IBOutlet UIButton *beginPushBtn;
//@property (nonatomic, strong) NHPushStream *nhPushTool;
@property (nonatomic, strong) NHFFmpegPlayer *nhPlay;
@property (nonatomic, strong) NHAVPlayer *nhAVPlay;
@property (nonatomic, assign) float lastFrameTime;
@property (nonatomic, assign) float lastPlayTime;

@end

@implementation NHPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeStreamPush];
    

    
}

- (void)initializeStreamPush {
//    _nhPushTool = [[NHPushStream alloc] initWithOptional:NHPushStreamOptionalFFmpeg];
    
    _nhPlay = [[NHFFmpegPlayer alloc] initWithVideo:kMoveSourcesPath];
    _nhPlay.delegate = self;
    
    _nhAVPlay = [[NHAVPlayer alloc] initPlayerWithView:_previewView playUrl:kMoveSourcesPath];

}


- (IBAction)copyAction:(UIButton *)sender {
    UIPasteboard *pasteB = [UIPasteboard generalPasteboard];
    pasteB.string = self.pushTextView.text;
}

- (IBAction)paseAction:(UIButton *)sender {
    UIPasteboard *pasteB = [UIPasteboard generalPasteboard];
    self.pushTextView.text = pasteB.string;
    
}


- (IBAction)beginPushStearm:(UIButton *)sender {
    if (sender.selected) {
//        [_nhPushTool stopPushStream];
        sender.selected = NO;
        
    } else {
        sender.selected = YES;
//        [self.nhPushTool startPushInputUrl:kMoveSourcesPath
//                                 outputUrl:self.pushTextView.text];
        [_nhAVPlay play];
    }
    
}

- (IBAction)back:(UIButton *)sender {
    [_nhAVPlay releasePlayer];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (NSString *)dealTime:(double)time {
    
    int tns, thh, tmm, tss;
    tns = time;
    thh = tns / 3600;
    tmm = (tns % 3600) / 60;
    tss = tns % 60;
    
    //        [ImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
    return [NSString stringWithFormat:@"%02d:%02d:%02d",thh,tmm,tss];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - NHFFmpegPlayerDelegate
- (void)nhAVPlayCurrentMoveFrameTime:(double)frameTime nowTime:(double)nowTime avPlay:(NHFFmpegPlayer *)avPlay {
    NSLog(@"frameTime:%f---nowTime:%f",frameTime,nowTime);
    _lastPlayTime = nowTime;
    
    NSString *time = [self dealTime:nowTime];

}

- (void)nhAVPlayCurrentMoveFrame:(UIImage *)image avPlay:(NHFFmpegPlayer *)avPlay {

}

- (void)nhAVPlayComplete:(NHFFmpegPlayer *)avPlay {
    
    
}

#pragma mark - UITextViewDelegate
#pragma mark -
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
