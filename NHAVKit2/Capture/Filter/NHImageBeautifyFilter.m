//
//  NHImageBeautifyFilter.m
//  NHCaptureFramework
//
//  Created by nenhall on 2019/3/28.
//  Copyright © 2019 nenhall. All rights reserved.
//
//初始化滤镜
//    let bilateralFilter = GPUImageBilateralFilter()     //磨皮
//    let exposureFilter = GPUImageExposureFilter()       //曝光
//    let brightnessFilter = GPUImageBrightnessFilter()   //美白
//    let satureationFilter = GPUImageSaturationFilter()  //饱和


#import "NHImageBeautifyFilter.h"



@implementation NHImageBeautifyFilter

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    // First pass: face smoothing filter
    _bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    _bilateralFilter.distanceNormalizationFactor = 4.0;
    [self addFilter:_bilateralFilter];
    
    // Second pass: edge detection
    _cannyEdgeFilter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    [self addFilter:_cannyEdgeFilter];
    
    // Third pass: combination bilateral, edge detection and origin
    _combinationFilter = [[NHImageCombinationFilter alloc] init];
    [self addFilter:_combinationFilter];
    
    // Adjust HSB
    _hsbFilter = [[GPUImageHSBFilter alloc] init];
    [_hsbFilter adjustBrightness:1.1];
    [_hsbFilter adjustSaturation:1.1];
    
    [_bilateralFilter addTarget:_combinationFilter];
    [_cannyEdgeFilter addTarget:_combinationFilter];
    
    [_combinationFilter addTarget:_hsbFilter];
    
    self.initialFilters = [NSArray arrayWithObjects:_bilateralFilter, _cannyEdgeFilter, _combinationFilter, nil];
    self.terminalFilter = _hsbFilter;
    
    return self;
}

#pragma makr - private method
- (BOOL)addExposureFilter {
    _exposureFilter = [[GPUImageExposureFilter alloc] init];
    _exposureFilter.exposure = 5;
    [self addFilter:_exposureFilter];
    
    return YES;
}

- (BOOL)removeExposureFilter {
    if (_exposureFilter) {
//        [_exposureFilter removeOutputFramebuffer];
    }
    
    return YES;
}

- (BOOL)addBrightnessFilter {
    _brightnessfilter = [[GPUImageBrightnessFilter alloc] init];
    _brightnessfilter.brightness = 10;
    [self addFilter:_brightnessfilter];
    
    return YES;
}

- (BOOL)removeBrightnessFilter {
    
    return YES;
}

- (BOOL)addSaturationFilter {
    _saturationFilter = [[GPUImageSaturationFilter alloc] init];
    _saturationFilter.saturation = 10;
    [self addFilter:_saturationFilter];
    return YES;
}

- (BOOL)removeSaturationFilter {
    
    
    return YES;
}


- (void)setExposure:(CGFloat)exposure {
    if (_exposureFilter) {
        _exposure = exposure;
        _exposureFilter.exposure = exposure;
    }
}

- (void)setBrightness:(CGFloat)brightness {
    if (_brightnessfilter) {
        _brightness = brightness;
        _brightnessfilter.brightness = brightness;
    }
}

- (void)setSaturation:(CGFloat)saturation {
    if (_saturationFilter) {
        _saturation = saturation;
        _saturationFilter.saturation = saturation;
    }
}



#pragma mark -
#pragma mark GPUImageInput protocol

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
{
    for (GPUImageOutput<GPUImageInput> *currentFilter in self.initialFilters)
    {
        if (currentFilter != self.inputFilterToIgnoreForUpdates)
        {
            if (currentFilter == _combinationFilter) {
                textureIndex = 2;
            }
            [currentFilter newFrameReadyAtTime:frameTime atIndex:textureIndex];
        }
    }
}

- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
{
    for (GPUImageOutput<GPUImageInput> *currentFilter in self.initialFilters)
    {
        if (currentFilter == _combinationFilter) {
            textureIndex = 2;
        }
        [currentFilter setInputFramebuffer:newInputFramebuffer atIndex:textureIndex];
    }
}


@end
