//
//  DoubleSlider.h
//  Sweeter
//
//  Created by Dimitris on 23/06/2010.
//  Copyright 2010 locus-delicti.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleSlider : UIControl {
	float minSelectedValue;
	float maxSelectedValue;
    float valueSpan;
    BOOL latchMin;
    BOOL latchMax;
	
	UIImageView *minHandle;
	UIImageView *maxHandle;
	
	float sliderBarHeight;
    float sliderBarWidth;
	
	CGColorRef bgColor;
}

@property float minSelectedValue;
@property float maxSelectedValue;
@property (nonatomic) float minValue;//0
@property (nonatomic) float maxValue;//1
@property (nonatomic, strong) UIImageView *minHandle;
@property (nonatomic, strong) UIImageView *maxHandle;

//拖动结束
@property (nonatomic, copy) void(^sliderChangedHandler)(void);

- (id) initWithFrame:(CGRect)aFrame barHeight:(float)height;
- (void) moveSlidersToPosition:(NSNumber *)leftSlider:(NSNumber *)rightSlider animated:(BOOL)animated;

@end


/*
Improvements:
 - initWithWidth instead of frame?
 - do custom drawing below an overlay layer
 - add inner shadow to the background and shadow to handles in code
*/
