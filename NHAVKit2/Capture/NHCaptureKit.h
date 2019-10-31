//
//  NHCaptureKit.h
//  NHCaptureKit
//
//  Created by nenhall on 2019/4/29.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for NHCaptureKit.
FOUNDATION_EXPORT double NHCaptureKitVersionNumber;

//! Project version string for NHCaptureKit.
FOUNDATION_EXPORT const unsigned char NHCaptureKitVersionString[];


//#import "GPUImage.h"
#import "NHGPUImageView.h"
#import "NHImageBeautifyFilter.h"
#import "NHAVCapture.h"
#import "NHFrameImage.h"
#import "NHGifTool.h"


#if __has_include("NHFFmpegSession.h")
#import "NHFFmpegSession.h"
#endif

#if __has_include("NHX264Manager.h")
#import "NHX264Manager.h"
#endif
