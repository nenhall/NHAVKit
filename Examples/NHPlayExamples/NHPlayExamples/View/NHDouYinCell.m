//
//  NHDouYinCell.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/10/10.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHDouYinCell.h"

@interface NHDouYinCell ()
@property (weak, nonatomic) IBOutlet UIButton *userHead;
@property (weak, nonatomic) IBOutlet UIButton *likeAction;
@property (weak, nonatomic) IBOutlet UIButton *sharedAction;
@property (weak, nonatomic) IBOutlet UIButton *moreAction;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *musicAction;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIView *actionViews;

@end

@implementation NHDouYinCell


- (void)setPlayURL:(NSString *)playURL {
    _playURL = playURL;
    
    NSArray *array = [playURL componentsSeparatedByString:@"/"];
    NSString *title;
    if (array.count) {
        title = array.lastObject;
    }
    
    self.titleLabel.text = title;
    self.detailLabel.text = playURL;
    
}

@end
