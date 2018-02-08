//
//  BOSHOverlayTrack.m
//  BOSHVideo
//
//  Created by yang on 2017/11/9.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHOverlayTrack.h"

@implementation BOSHOverlayTrack

+ (instancetype)itemWithOverlay:(BOSHOverlay *)overlay
{
    return [[self alloc] initWithOverlay:overlay];
}

- (instancetype)initWithOverlay:(BOSHOverlay *)overlay
{
    self = [super init];
    if(self)
    {
        self.startTime = kCMTimeZero;
        self.timeRange = kCMTimeRangeZero;
        self.overlay = overlay;
    }
    return self;
}


//增加动画
- (CALayer *)overlayer
{
    return [self getAnimationLayer];
}


- (CALayer *)getAnimationLayer
{
    //    BOSHOverlayTypeNone,//无
    //    BOSHOverlayTypeTEXT,//文字
    //    BOSHOverlayTypePIC,//图片
    //    BOSHOverlayTypeGIF//动态图
    switch (self.overlay.type) {
        case BOSHOverlayTypeNone:
            return self.overlay.overlayer;
        case BOSHOverlayTypeTEXT:
        {
            CALayer *layer = self.overlay.overlayer;
            layer.opacity = 0;
            [layer addAnimation:[self opacityAnimation] forKey:@"opacityAnimation"];
            return layer;
        }
            break;
        case BOSHOverlayTypePIC:
        {
            CALayer *layer = self.overlay.overlayer;
             layer.opacity = 0;
            [layer addAnimation:[self opacityAnimation] forKey:@"opacityAnimation"];
            return layer;
        }
        case BOSHOverlayTypeGIF:
        {
            CALayer *layer = self.overlay.overlayer;
            layer.borderWidth = 3;
            layer.borderColor = [UIColor redColor].CGColor;
             layer.opacity = 0;
            CAAnimation *gifAni = [self gifAnimationWithData:(BOSHGifOverlay *)self.overlay];
            CAAnimation *opAni = [self opacityAnimation];//导致GIF 不显示  DEBUG 半天
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.animations = @[opAni,gifAni];
            group.beginTime = [self animationStartTime];
             if(CMTimeCompare(self.timeRange.duration, kCMTimeZero))
             {
                group.duration = CMTimeGetSeconds(self.timeRange.duration);
                 group.removedOnCompletion = YES;
             }
            else
            {
                group.duration = CGFLOAT_MAX;//需要设置时间,透明度什么的无需设置时间
                 group.removedOnCompletion = NO;
            }
            [layer addAnimation:group forKey:@"gifanimation"];
            return layer;
        }
      case BOSHOverlayTypeBorder:
        {
            CALayer *layer = self.overlay.overlayer;
            return layer;
        }
        default:
            return nil;
    }
}


- (CAAnimation *)gifAnimationWithData:(BOSHGifOverlay *)gifOverlay
{
    CAKeyframeAnimation *gifAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    [gifAnimation setKeyTimes:gifOverlay.timePoints];
    [gifAnimation setBeginTime:self.animationStartTime];
    [gifAnimation setValues:gifOverlay.images];
    //动画信息基本设置
    [gifAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
     if(CMTimeCompare(self.timeRange.duration, kCMTimeZero) && gifOverlay.duration != 0)
     {
          [gifAnimation setRepeatCount:(int)(CMTimeGetSeconds(self.timeRange.duration)/gifOverlay.duration)];
     }
    else
    {
        [gifAnimation setRepeatCount:NSIntegerMax];
    }
    [gifAnimation setDuration: (gifOverlay.duration)];
   
    return gifAnimation;
}

//增加简单动画
- (CAAnimation *)rotationAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
     if(CMTimeCompare(self.timeRange.duration, kCMTimeZero))
     {
        animation.duration=CMTimeGetSeconds(self.timeRange.duration);
         animation.repeatCount=1000;
         animation.autoreverses=NO;
         animation.fromValue=[NSNumber numberWithFloat:0.0];
         animation.toValue=[NSNumber numberWithFloat:(M_PI)];
     }
    else
    {
        animation.fromValue=[NSNumber numberWithFloat:0.0];
        animation.toValue=[NSNumber numberWithFloat:0.0];
    }
    animation.beginTime = self.animationStartTime;
    return animation;
}

- (CAAnimation *)opacityAnimation
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
     if(CMTimeCompare(self.timeRange.duration, kCMTimeZero))
     {
        [baseAnimation setDuration:CMTimeGetSeconds(self.timeRange.duration)];
        [baseAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
        [baseAnimation setToValue:[NSNumber numberWithFloat:0.0]];
     }
    else
    {
        [baseAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
        [baseAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    }
    [baseAnimation setBeginTime:self.animationStartTime ]; // time to show text
    [baseAnimation setRemovedOnCompletion:NO];
    [baseAnimation setFillMode:kCAFillModeForwards];
    return baseAnimation;
}

- (CAAnimation *)transcaleAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    if(CMTimeCompare(self.timeRange.duration, kCMTimeZero))
    {
        scaleAnimation.duration=CMTimeGetSeconds(self.timeRange.duration);
        scaleAnimation.repeatCount=1000;
        scaleAnimation.autoreverses=YES;
        scaleAnimation.fromValue=[NSNumber numberWithFloat:0.15];
        scaleAnimation.toValue=[NSNumber numberWithFloat:1.0];
    }
    else
    {
        scaleAnimation.fromValue=[NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue=[NSNumber numberWithFloat:1.0];
    }

    scaleAnimation.beginTime = [self animationStartTime];
    return scaleAnimation;
}

- (double)animationStartTime
{
    return AVCoreAnimationBeginTimeAtZero + CMTimeGetSeconds(self.startTime);
}

@end
