//
//  NHPlayerView.h
//  NHPlayDemo
//
//  Created by nenhall_work on 2018/11/13.
//  Copyright © 2018 nenhall_studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NHPlayerProtocol.h"
#import "NHPlayerPrivateProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface NHPlayerView : UIView <NHPlayerDelegate,NHPlayerPrivateProtocol>
@property (nonatomic, weak) id<NHPlayerToolBarDelegate> barDelegate;
/// 点击toolbar显示隐藏手势，默认yes
@property (nonatomic, assign) BOOL enableToolBarOnTapGesture;
/// 自定义工具条，默认false，如果 true 所有相关工具条都会隐藏
@property (nonatomic, assign) BOOL customToolBar;


- (instancetype)initWithPlayer:(AVPlayerLayer *)playerLayer;

- (void)resetPlayerLayer:(AVPlayerLayer *)playerLayer;

//更新播放按钮状态
-(void)updatePlayStatus:(NHPlayerStatus)status;

-(void)hiddenToolBar:(BOOL)hidden;



@end

NS_ASSUME_NONNULL_END
