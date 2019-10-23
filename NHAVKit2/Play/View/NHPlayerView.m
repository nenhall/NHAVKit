//
//  NHPlayerView.m
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/13.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import "NHPlayerView.h"
#import "NHPlayerToolBar.h"


@interface NHPlayerView ()<NHPlayerToolBarDelegate>
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, weak  ) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIImageView *watingCover;
@property (nonatomic, strong) UIButton *lockBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NHPlayerToolBar *toolBar;
@property (nonatomic, strong) UIView *hudView;

@end

@implementation NHPlayerView

- (instancetype)initWithPlayer:(AVPlayerLayer*)playerLayer
{
    self = [super init];
    if (self) {
        _enableToolBarOnTapGesture = YES;
        _playerLayer = playerLayer;
        self.backgroundColor = [UIColor blackColor];
        [self initializeSubviews];
    }
    return self;
}

- (void)initializeSubviews {
  
  _playerView = [[UIView alloc] init];
  _playerView.backgroundColor = [UIColor blackColor];
  [self addSubview:_playerView];
  [_playerView.layer addSublayer:_playerLayer];
  
  _hudView = [[UIView alloc] init];
  _hudView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
  [self addSubview:_hudView];
  
  _topView = [[UIView alloc] init];
  _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
  [self addSubview:_topView];
  
  _toolBar = [[NHPlayerToolBar alloc] init];
 
  _toolBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
  [self addSubview:_toolBar];
  
}

- (void)setBarDelegate:(id<NHPlayerToolBarDelegate>)delegate {
  _barDelegate = delegate;
  _toolBar.delegate = delegate;
}

- (void)resetPlayerLayer:(AVPlayerLayer *)playerLayer {
  if (_playerLayer) {
    [_playerLayer removeFromSuperlayer];
  }
  _playerLayer = playerLayer;
  [_playerView.layer addSublayer:_playerLayer];
}

- (void)setCustomToolBar:(BOOL)customToolBar {
    _customToolBar = customToolBar;
    [_hudView setHidden:customToolBar];
    [_toolBar setHidden:customToolBar];
    [_topView setHidden:customToolBar];
    [_lockBtn setHidden:customToolBar];
}

- (void)updateCacheProgress:(float)progress {
  [_toolBar updateCacheProgress:progress];
}

- (void)updatePlayProgress:(float)progress {
  [_toolBar updatePlayProgress:progress];
}

- (void)setMaxDuration:(float)duration {
  [_toolBar setMaxDuration:duration];
}

- (void)fullZoom:(BOOL)full {
  [_toolBar fullZoom:full];
}

- (void)play {
  [_toolBar play];
}

- (void)playDone {
  [_toolBar playDone];
}

- (void)pause {
  [_toolBar pause];
}

- (void)updatePlayStatus:(NHPlayerStatus)status {
    [_toolBar updatePlayStatus:status];
}

- (void)hiddenToolBar:(BOOL)hidden {
    _toolBar.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  
    if (_enableToolBarOnTapGesture) {
        CGPoint topPoint = [touches.anyObject locationInView:_topView];
        CGPoint toolBarPoint = [touches.anyObject locationInView:_toolBar];
        
        if ([_topView pointInside:topPoint withEvent:event]) {
            
            
        } else   if ([_toolBar pointInside:toolBarPoint withEvent:event]) {
            
            
        } else {
            _hudView.hidden = !_hudView.hidden;
            _topView.hidden = !_topView.hidden;
            _toolBar.hidden = !_toolBar.hidden;
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }

}


- (void)layoutSubviews {
  [super layoutSubviews];
  [self makeSubviewsConstraints];
}

/**
 添加子视图约束
 */
- (void)makeSubviewsConstraints {
  
  {
    _playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:_playerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_playerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_playerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                           ]];
    _playerLayer.frame = _playerView.bounds;
  }
  
  {
    _hudView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:_hudView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_hudView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_hudView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_hudView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                           ]];
  }
  
  {
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    [_topView addConstraint:[NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]
                           ]];
  }
  
  {
    _toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [_toolBar addConstraint:[NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:49]];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                           ]];
  }
}

@end
