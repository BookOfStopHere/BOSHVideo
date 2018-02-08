//
//  BOSHTransitonInstruction.m
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//
#define kTransitionH 30
#define kTransitionW 30
#import "BOSHTransitonInstruction.h"

@implementation BOSHTransitonInstruction

+ (instancetype)instruction
{
    return [[self alloc] initWithTransitionType:BOSHTransitionTypeNone andDuration:0];
}


+ (instancetype)pushTransitonWithDuration:(double)duration
{
    return [[self alloc] initWithTransitionType:BOSHTransitionTypePush andDuration:duration];
}

+ (instancetype)fadeTransitionWithDuration:(double)duration
{
    return [[self alloc] initWithTransitionType:BOSHTransitionFade andDuration:duration];
}

+ (instancetype)flipFromRightTransitionWithDuration:(double)duration
{
    return [[self alloc] initWithTransitionType:BOSHTransitionFlipFromRight andDuration:duration];
}

- (id)initWithTransitionType:(BOSHTransitionType)transitionType andDuration:(double)duration
{
    self = [super init];
    if (self)
    {
        self.itemType = BOSHTimelineTypeTransition;
        self.maxWidthInTimeline = kTransitionW;
        _transitionType = transitionType;
        _animationDuration = duration;
    }
    return self;
}

- (CGFloat)widthInTimeline
{
    return kTransitionW;
}

- (CGFloat) preferedWidthInTimeline
{
    return kTransitionW;
}

+ (float)defaultInterval
{
    return 1.0;
}

@end
