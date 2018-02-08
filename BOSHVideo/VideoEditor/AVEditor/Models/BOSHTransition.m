//
//  BOSHTransition.m
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTransition.h"

@implementation BOSHTransition

+ (instancetype)transiton
{
    return  self.new;
}

+ (instancetype)pushTransitonWithDuration:(CMTime)duration
{
    return [self transiton];
}

+ (instancetype)fadeTransitionWithDuration:(CMTime)duration
{
     return [self transiton];
}

+ (instancetype)rotateTransitionWithDuration:(CMTime)duration
{
     return [self transiton];
}


@end
