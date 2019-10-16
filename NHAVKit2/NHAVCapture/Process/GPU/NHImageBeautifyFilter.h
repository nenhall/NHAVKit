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
    GPUImageHSBFilter *_hsbFilter;                      //HSB
    GPUImageBilateralFilter *_bilateralFilter;          //face 磨皮
    GPUImageCannyEdgeDetectionFilter *_cannyEdgeFilter; //edge
    NHImageCombinationFilter *_combinationFilter;       //combine
    
    GPUImageExposureFilter *_exposureFilter;     /**< 曝光 */
    GPUImageBrightnessFilter *_brightnessfilter; /**< 美白 */
    GPUImageSaturationFilter *_saturationFilter; /**< 饱和 */
}

// A normalization factor for the distance between central color and sample color.
// 中心色和样本色之间距离的归一化因子。
@property(nonatomic, readwrite) CGFloat distanceNormalizationFactor;

// Exposure ranges from -10.0 to 10.0, with 0.0 as the normal level
// 曝光范围
@property(readwrite, nonatomic) CGFloat exposure;

// Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
// 亮度范围
@property(readwrite, nonatomic) CGFloat brightness;

/** Saturation ranges from 0.0 (fully desaturated) to 2.0 (max saturation), with 1.0 as the normal level
 */
@property(readwrite, nonatomic) CGFloat saturation;

- (BOOL)addExposureFilter;
- (BOOL)addBrightnessFilter;
- (BOOL)addSaturationFilter;


- (BOOL)removeExposureFilter;
- (BOOL)removeBrightnessFilter;
- (BOOL)removeSaturationFilter;

@end

NS_ASSUME_NONNULL_END
