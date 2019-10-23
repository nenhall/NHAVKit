//
//  NHImageCombinationFilter.h
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/28.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "GPUImageThreeInputFilter.h"

NS_ASSUME_NONNULL_BEGIN

// Internal CombinationFilter(It should not be used outside)
@interface NHImageCombinationFilter : GPUImageThreeInputFilter {
    GLint smoothDegreeUniform;
}

@property (nonatomic, assign) CGFloat intensity;
@end

NS_ASSUME_NONNULL_END
