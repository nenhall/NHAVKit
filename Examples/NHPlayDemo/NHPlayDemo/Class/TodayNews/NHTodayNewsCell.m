//
//  NHTodayNewsCell.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/10/10.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHTodayNewsCell.h"

@implementation NHTodayNewsCell

- (void)setPlayURL:(NSString *)playURL {
    _titleLabel.text = playURL;
}

@end
