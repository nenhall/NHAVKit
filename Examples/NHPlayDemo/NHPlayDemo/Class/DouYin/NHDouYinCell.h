//
//  NHDouYinCell.h
//  NHPlayDemo
//
//  Created by nenhall on 2019/10/10.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHDouYinCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (nonatomic, copy) NSString *playURL;

@end

NS_ASSUME_NONNULL_END
