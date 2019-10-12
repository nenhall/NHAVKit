//
//  NHVideoProgress.m
//  NHCaptureDemo
//
//  Created by nenhall on 2019/3/26.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "NHVideoProgress.h"
#import <CoreGraphics/CoreGraphics.h>
#import <NHUIKit.h>



@implementation NHVideoProgress {
    CGFloat _progress;
    UIColor *_color;
    NSMutableArray *_drawList;
    float _lastProgress;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _drawList = [[NSMutableArray alloc] init];
        NSDictionary *dict = @{@"color" : _color, @"progress" : @(0.0)};
        [_drawList addObject:dict];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _drawList = [[NSMutableArray alloc] init];
        NSDictionary *dict = @{@"color" : [UIColor orangeColor], @"progress" : @"0"};
        [_drawList addObject:dict];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _color = [UIColor orangeColor];
    }
    return self;
}

- (void)setDrawProgress:(float)progress color:(UIColor *)color {
    _progress = progress;
    _color = color;
    NSLog(@"%f",progress);

    if ((progress >= 0.2 && progress < 0.3) || progress == 0.4) {
        _color = [UIColor redColor];
        
    } else {
        _color = [UIColor orangeColor];
    }
    
    NSDictionary *dict = @{@"color" : _color, @"progress" : @(progress)};
    
    [_drawList addObject:dict];
    
    [self setNeedsDisplay];
    
}


- (void)drawRect:(CGRect)rect {
    
   CGContextRef ref = UIGraphicsGetCurrentContext();
    
    for (NSDictionary *dict in _drawList) {
        UIColor *color = [dict objectForKey:@"color"];
        float progress = [[dict objectForKey:@"progress"] floatValue];
        float beginPointX = self.width * _lastProgress;
        float currentDrawW = (self.width * progress) - beginPointX;
        if (_drawList.count < 3) {
            currentDrawW = self.width * progress;
        }
        CGContextAddRect(ref, CGRectMake(beginPointX, 0, currentDrawW, self.height));
        CGContextSetFillColorWithColor(ref, color.CGColor);
        CGContextSetStrokeColorWithColor(ref, color.CGColor);
        _lastProgress = progress;
        CGContextClosePath(ref);
        CGContextDrawPath(ref, kCGPathFillStroke);
    }
    
}


@end
