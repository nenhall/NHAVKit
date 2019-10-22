//
//  NHTodayNewsCell.h
//  NHPlayDemo
//
//  Created by nenhall on 2019/10/10.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NHPlayKit/NHPlayKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface NHTodayNewsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NHAVPlayer *player;

@property (nonatomic, copy) NSString *playURL;

@end

NS_ASSUME_NONNULL_END
