//
//  NHX264OutputProtocol.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/19.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NHX264OutputProtocol <NSObject>

- (void)setOutput:(id<NHX264OutputProtocol>)output;

@end

NS_ASSUME_NONNULL_END
