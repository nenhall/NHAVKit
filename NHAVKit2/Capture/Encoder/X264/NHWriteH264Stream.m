//
//  NHWriteH264Stream.m
//  NHPushStreamSDK
//
//  Created by nenhall on 2019/2/19.
//  Copyright © 2019 neghao. All rights reserved.
//

#import "NHWriteH264Stream.h"

#include <libavutil/opt.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>



@implementation NHWriteH264Stream
{
    char *_out_file;
    FILE *_pFile;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filePath = [self saveFilePath];
        [self setFileSavedPath:self.filePath];
    }
    return self;
}

/*
 * 设置编码后文件的文件名，保存路径
 */
- (void)setFileSavedPath:(NSString *)path {
    char *filePath = (char *)[path UTF8String];
    _pFile = fopen(filePath, "wb");
    NSLog(@"%s",filePath);
}

/** 文件保存路径 */
- (NSString *)saveFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths.firstObject;
    NSString *fileName = [self saveFileName];
    NSString *writeFilePath = [documentPath stringByAppendingPathComponent:fileName];
    return writeFilePath;
}

/** 拼接文件名 */
- (NSString *)saveFileName {
    return [[self nowTime2String] stringByAppendingString:@".h264"];
}

/** 获取系统当前时间 */
- (NSString* )nowTime2String {
    NSString *date = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd-hh-mm-ss";
    date = [formatter stringFromDate:[NSDate date]];
    
    return date;
}

/** 写视频帧 */
- (void)writeFrame:(AVPacket)packet streamIndex:(NSInteger)streamIndex {
    
    fwrite(packet.data, packet.size, 1, _pFile);
    
    fflush(_pFile);
}

- (void)writeData:(uint8_t *)data size:(int)size index:(NSInteger)index {
    
    fwrite(data, size, 1, _pFile);
    
    fflush(_pFile);
}

- (void)setOutput:(id<NHX264OutputProtocol>)output {
    
}

- (void)dealloc {
    fclose(_pFile);
    
    _pFile = NULL;
    
    NSLog(@"%s",__func__);
}


@end
