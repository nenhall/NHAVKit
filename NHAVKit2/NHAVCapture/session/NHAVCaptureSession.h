//
//  NHAVCaptureSession.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/14.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHBeasSession.h"


NS_ASSUME_NONNULL_BEGIN

@interface NHAVCaptureSession : NHBeasSession
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (nonatomic, weak) id<NHCaptureSessionProtocol> delegate;

+ (instancetype)sessionWithPreviewView:(UIView *)preview outputType:(NHOutputType)outputType;

///**
// 开始录制264格式视频
// */
//- (void)startRecordX264;


@end

NS_ASSUME_NONNULL_END
