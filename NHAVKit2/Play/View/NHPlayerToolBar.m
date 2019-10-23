//
//  NHPlayerToolBar.m
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/13.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import "NHPlayerToolBar.h"
#import "NSObject+converTime.h"

#define KImagePath(name) [NSString stringWithFormat:@"NHPlay.bundle/%@",(name)]

@interface NHPlayerToolBar ()
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *playSlider;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UILabel *endTimeLabel;
@end

@implementation NHPlayerToolBar {

}

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self initializeSubviews];
  }
  return self;
}


- (void)initializeSubviews {

    _playBtn = [[UIButton alloc] init];
  [_playBtn setImage:[self getImageWithName:@"bofang"] forState:UIControlStateNormal];
  [_playBtn setImage:[self getImageWithName:@"zanting"] forState:UIControlStateSelected];
  [_playBtn setImage:[self getImageWithName:@"zanting"] forState:UIControlStateSelected | UIControlStateHighlighted];
  [_playBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_playBtn];

  _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
  _progressView.progressTintColor = [UIColor clearColor];
  _progressView.backgroundColor = [UIColor clearColor];
  _progressView.progress = 0.0;
  _progressView.trackTintColor = [UIColor clearColor];
  _progressView.trackTintColor = [UIColor colorWithRed:128 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1];
  _progressView.progressTintColor = [UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:1];
  [self addSubview:_progressView];
  
  _playSlider = [[UISlider alloc] init];
  _playSlider.tintColor = [UIColor clearColor];
  [_playSlider setThumbImage:[self getImageWithName:@"circleyuanquan"] forState:UIControlStateNormal];
  _playSlider.value = 0.0;
  _playSlider.maximumTrackTintColor = [UIColor clearColor];
  _playSlider.minimumTrackTintColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
  [_playSlider addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventValueChanged];
  [self addSubview:_playSlider];
  
  _fullScreenBtn = [[UIButton alloc] init];
  [_fullScreenBtn setImage:[self getImageWithName:@"quanping"] forState:UIControlStateNormal];
  [_fullScreenBtn setImage:[self getImageWithName:@"xiaoping"] forState:UIControlStateSelected];
  [_fullScreenBtn setImage:[self getImageWithName:@"xiaoping"] forState:UIControlStateSelected | UIControlStateHighlighted];
  [_fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_fullScreenBtn];
//  _fullScrrenBtn.backgroundColor = [UIColor blueColor];
  
  
  _endTimeLabel = [[UILabel alloc] init];
  _endTimeLabel.font = [UIFont systemFontOfSize:10];
  _endTimeLabel.backgroundColor = [UIColor clearColor];
  _endTimeLabel.textColor = [UIColor whiteColor];
  _endTimeLabel.textAlignment = NSTextAlignmentCenter;
  _endTimeLabel.text = @"00:00";
  [self addSubview:_endTimeLabel];
  
}

- (void)dragSlider:(UISlider *)slider {
  if (self.delegate && [self.delegate respondsToSelector:@selector(playerToolBarDragSlider:)]) {
    [self.delegate playerToolBarDragSlider:slider.value];
  }
}

- (void)playOrPause:(UIButton *)button {
  if (self.delegate && [self.delegate respondsToSelector:@selector(playerToolBarDidClickPlayOrPause)]) {
    button.selected = [self.delegate playerToolBarDidClickPlayOrPause];
  }
}

- (void)fullScreen:(UIButton *)button {
  if (self.delegate && [self.delegate respondsToSelector:@selector(playerToolBarDidClickVideoZoom)]) {
    button.selected = [self.delegate playerToolBarDidClickVideoZoom];
  }
}

- (void)updateCacheProgress:(float)progress {
  NSLog(@"CacheProgress: %f",progress);
  _progressView.progress = progress;
}

- (void)updatePlayProgress:(float)progress {
  _playSlider.value = progress;
}

- (void)setMaxDuration:(float)duration {
  _endTimeLabel.text = [NSObject convertTime:duration];
  _playSlider.maximumValue = duration;
}

- (void)fullZoom:(BOOL)full {
  _fullScreenBtn.selected = full;
}

- (void)play {
  _playBtn.selected = YES;
}

- (void)playDone {
  _playBtn.selected = NO;
}

- (void)pause {
  _playBtn.selected = NO;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self makeSubviewsConstraints];
}

- (void)updatePlayStatus:(NHPlayerStatus)status {
    
    if (status == NHPlayerStatusPlaying) {
          _playBtn.selected = YES;
    } else {
          _playBtn.selected = NO;
    }
}

/**
 添加子视图约束
 */
- (void)makeSubviewsConstraints {
  CGFloat leftSpace = 10.0;
  CGFloat rightSpace = -10.0;
  CGFloat height = 30.0;
  {
    _playBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint*playBtnLeftC = [NSLayoutConstraint constraintWithItem:_playBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:leftSpace];
    
    NSLayoutConstraint*playBtnCenterYC = [NSLayoutConstraint constraintWithItem:_playBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint*playBtnWidthC = [NSLayoutConstraint constraintWithItem:_playBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:height];
    
    NSLayoutConstraint*playBtnHeightC = [NSLayoutConstraint constraintWithItem:_playBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:height];
    [_playBtn addConstraints:@[playBtnWidthC, playBtnHeightC]];
    [self addConstraints:@[playBtnLeftC, playBtnCenterYC]];
  }

  {
    _fullScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint*fullBtnRightC = [NSLayoutConstraint constraintWithItem:_fullScreenBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:rightSpace];
    
    NSLayoutConstraint*fullBtnCenterYC = [NSLayoutConstraint constraintWithItem:_fullScreenBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint*fullBtnWidthC = [NSLayoutConstraint constraintWithItem:_fullScreenBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    NSLayoutConstraint*fullBtnHeightC = [NSLayoutConstraint constraintWithItem:_fullScreenBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [_fullScreenBtn addConstraints:@[fullBtnWidthC,fullBtnHeightC]];
    
    [self addConstraints:@[fullBtnRightC, fullBtnCenterYC]];
  }
  
  {
    _endTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint*endLabelRightC = [NSLayoutConstraint constraintWithItem:_endTimeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_fullScreenBtn attribute:NSLayoutAttributeLeft multiplier:1 constant:rightSpace*0.5];
    
    NSLayoutConstraint*endLabelCenterYC = [NSLayoutConstraint constraintWithItem:_endTimeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
//    NSLayoutConstraint*fullBtnWidthC = [NSLayoutConstraint constraintWithItem:_endTimeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    NSLayoutConstraint*endLabelHeightC = [NSLayoutConstraint constraintWithItem:_endTimeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [_endTimeLabel addConstraints:@[endLabelHeightC]];
    
    [self addConstraints:@[endLabelRightC, endLabelCenterYC]];
  }
  
  {
    _playSlider.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint*playBtnLeftC = [NSLayoutConstraint constraintWithItem:_playSlider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_playBtn attribute:NSLayoutAttributeRight multiplier:1 constant:leftSpace];
    
    NSLayoutConstraint*playBtnRightC = [NSLayoutConstraint constraintWithItem:_playSlider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_endTimeLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:rightSpace];

    NSLayoutConstraint*playBtnCenterYC = [NSLayoutConstraint constraintWithItem:_playSlider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [self addConstraints:@[playBtnLeftC, playBtnRightC, playBtnCenterYC]];
  }
  
  {
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint*playBtnLeftC = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_playSlider attribute:NSLayoutAttributeLeft multiplier:1 constant:0];

    NSLayoutConstraint*playBtnRightC = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_playSlider attribute:NSLayoutAttributeRight multiplier:1 constant:0];

    NSLayoutConstraint*playBtnCenterYC = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_playSlider attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    [self addConstraints:@[playBtnLeftC, playBtnRightC, playBtnCenterYC]];
  }
}

/**
 获取framework内的图片资源
 
 @param name 图片史
 */
- (UIImage *)getImageWithName:(NSString *)name {
    
    // 获取bundle参数
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"NHAVPlayer")];
    // 文件路径
    NSString* htmlPath = [bundle pathForResource:@"NHPlay" ofType:@"bundle"];
    
    bundle = [NSBundle bundleWithPath:htmlPath];
    // 读UIImage
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
    return image;
}

@end
