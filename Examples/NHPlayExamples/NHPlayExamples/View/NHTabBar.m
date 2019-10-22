//
//  NHTabBar.m
//  NHPlayDemo
//
//  Created by nenhall on 2019/10/11.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import "NHTabBar.h"

@implementation NHTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        line.backgroundColor = UIColor.whiteColor;
        [self addSubview:line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            view.hidden = true;
        }
    }
    
}

@end
