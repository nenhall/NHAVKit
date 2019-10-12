//
//  NHPlayerToolBar.h
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/13.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHPlayerProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface NHPlayerToolBar : UIView <NHPlayerActionDelegate>
@property (nonatomic, weak) id<NHPlayerToolBarDelegate> delegate;

//更新播放按钮状态
-(void)updatePlayStatus:(NHPlayerStatus)status;

@end

NS_ASSUME_NONNULL_END
