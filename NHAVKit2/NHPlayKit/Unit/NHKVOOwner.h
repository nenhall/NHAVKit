//
//  NHKVOOwner.h
//  NHPlayDemo
//
//  Created by nenhall on 2019/3/7.
//  Copyright © 2019 nenhall_studio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHKVOOwner : NSObject
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, weak) id observer;
@end

NS_ASSUME_NONNULL_END
