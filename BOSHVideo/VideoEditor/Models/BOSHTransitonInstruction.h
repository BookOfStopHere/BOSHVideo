//
//  BOSHTransitonInstruction.h
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTrack.h"
#import "BOTHMacro.h"
#import "BOSHVideoTrack.h"


@interface BOSHTransitonInstruction : BOSHTrack

@property (nonatomic) BOSHTransitionType transitionType;
@property (nonatomic, readonly) double animationDuration;

/**
 * 无动画效果
 */
+ (instancetype)instruction;

/**
 * 推拉动画
 */
+ (instancetype)pushTransitonWithDuration:(double)duration;

/**
 * 淡入淡出动画
 */
+ (instancetype)fadeTransitionWithDuration:(double)duration;


/**
 * 飞入动画
 */
+ (instancetype)flipFromRightTransitionWithDuration:(double)duration;


/**
 * 默认的转场时间 1s,
 * 在使用的时候需要MIN(1s,media.duration/2)
 */
+ (float)defaultInterval;


@end
