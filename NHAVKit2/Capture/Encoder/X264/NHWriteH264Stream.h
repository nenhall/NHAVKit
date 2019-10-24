//
//  NHWriteH264Stream.h
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/19.
//  Copyright © 2019 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHX264OutputProtocol.h"
#import "NHCaptureSessionProtocol.h"

//#include <libavcodec/avcodec.h>



NS_ASSUME_NONNULL_BEGIN


@interface NHWriteH264Stream : NSObject <NHX264OutputProtocol>
@property (copy, nonatomic) NSString *filePath;

//- (void)writeFrame:(AVPacket)packet streamIndex:(NSInteger)streamIndex;
- (void)writeData:(uint8_t*)data size:(int)size index:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
