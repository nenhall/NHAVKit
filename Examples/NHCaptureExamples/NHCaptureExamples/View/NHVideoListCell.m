//
//  NHVideoListCell.m
//  NHPushStreamSDKDemo
//
//  Created by nenhall on 2019/2/19.
//  Copyright © 2019 neghao. All rights reserved.
//

#import "NHVideoListCell.h"

@interface NHVideoListCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation NHVideoListCell

+ (instancetype)loadCellWithTableView:(UITableView *)tableView {
    NSString *className = NSStringFromClass([self class]);
//    Class someClass = NSClassFromString(className);
    NSString *identifier = className;
    id obj = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!obj) {
        obj = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil].firstObject;
    }
    return obj;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeSubviews];
    }
    return self;
}

/**
 初始化子视图
 */
- (void)initializeSubviews {
    
}

- (void)setVideoTitle:(NSString *)title {
    self.title.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




@end
