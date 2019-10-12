//
//  NHVideoListCell.h
//  NHPushStreamSDKDemo
//
//  Created by nenhall on 2019/2/19.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHVideoListCell : UITableViewCell

+ (instancetype)loadCellWithTableView:(UITableView *)tableView;

- (void)setVideoTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
