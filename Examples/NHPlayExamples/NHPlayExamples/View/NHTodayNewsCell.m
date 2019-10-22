//
//  NHTodayNewsCell.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/10/10.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHTodayNewsCell.h"

@interface NHTodayNewsCell ()<NHPlayerDelegate>

@end

@implementation NHTodayNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _player = [[NHAVPlayer alloc] init];
    [_player setPlaySuperView:[self playView]];
    _player.delegate = self;

}

- (void)setPlayURL:(NSString *)playURL {
    _titleLabel.text = playURL;
    [_player replaceCurrentItemWithPlayUrl:playURL];
}

#pragma mark - NHPlayerDelegate
- (void)nhPlayerPlay:(NHAVPlayer *)player {
    
}

- (void)nhPlayerPause:(NHAVPlayer *)player {
    
}

- (void)nhPlayerPlayDone:(NHAVPlayer *)player {
    
}

- (void)nhPlayerReadyToPlay:(NHAVPlayer *)player {
    
}

- (void)nhPlayer:(NHAVPlayer *)player fullZoom:(BOOL)full {
    
}

- (void)nhPlayer:(NHAVPlayer *)player dragSlider:(float)progress {
    
}

- (void)nhPlayer:(NHAVPlayer *)player updatePlayProgress:(float)progress {
    
}

- (void)nhPlayer:(NHAVPlayer *)player updateCacheProgress:(float)progress {
    
}

- (void)nhPlayer:(NHAVPlayer *)player playFailed:(NSError *)error playURL:(NSURL *)playURL {
    
}

@end
