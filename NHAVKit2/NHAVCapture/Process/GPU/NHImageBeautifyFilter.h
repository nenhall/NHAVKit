//
//  NHImageBeautifyFilter.h
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/28.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "NHImageCombinationFilter.h"



NS_ASSUME_NONNULL_BEGIN

@interface NHImageBeautifyFilter : GPUImageFilterGroup {
    GPUImageHSBFilter *hsbFilter;                      //HSB
    GPUImageBilateralFilter *bilateralFilter;          //face
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter; //edge
    NHImageCombinationFilter *combinationFilter;       //combine
}

// A normalization factor for the distance between central color and sample color.
@property(nonatomic, readwrite) CGFloat distanceNormalizationFactor;


@end

NS_ASSUME_NONNULL_END
