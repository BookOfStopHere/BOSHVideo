//
//  BOSHAnimation.m
//  BOSHVideo
//
//  Created by yang on 2017/11/21.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHAnimation.h"

@implementation BOSHAnimation


+ (instancetype)animationWithType:(BOSHAnimationType)type
{
    return  [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(BOSHAnimationType)type
{
    self = [super init];
    if(self)
    {
        self.animationType = type;
    }
    return self;
}

 - (CAAnimation *)animation
{
    if(self.animationType == BOSHAnimationTypeTransform)
    {
        return [self transcaleAnimation];
    }
    else if(self.animationType == BOSHAnimationTypeOpacity)
    {
        return [self opacityAnimation];
    }
    else if(self.animationType == BOSHAnimationTypeRotation)
    {
        return [self rotationAnimation];
    }
    else
    {
        return nil;
    }
}

//增加简单动画
- (CAAnimation *)rotationAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration= self.duration;
    animation.repeatCount=1000;
    animation.autoreverses=NO;
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
    animation.beginTime = self.beginTime;
    return animation;
}

- (CAAnimation *)opacityAnimation
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [baseAnimation setDuration:self.duration];
    [baseAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [baseAnimation setToValue:[NSNumber numberWithFloat:0.0]];
    [baseAnimation setBeginTime:self.beginTime ]; // time to show text
    [baseAnimation setRemovedOnCompletion:NO];
    [baseAnimation setFillMode:kCAFillModeForwards];
    return baseAnimation;
}

- (CAAnimation *)transcaleAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration=self.duration;
    scaleAnimation.repeatCount=1000;
    scaleAnimation.autoreverses=YES;
    scaleAnimation.fromValue=[NSNumber numberWithFloat:0.15];
    scaleAnimation.toValue=[NSNumber numberWithFloat:1.0];
    scaleAnimation.beginTime = self.beginTime;
    return scaleAnimation;
}


@end
