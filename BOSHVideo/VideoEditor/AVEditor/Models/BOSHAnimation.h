//
//  BOSHAnimation.h
//  BOSHVideo
//
//  Created by yang on 2017/11/21.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BOSHAnimationType){
    BOSHAnimationTypeNone,//
    BOSHAnimationTypeRotation,//
    BOSHAnimationTypeOpacity,//
    BOSHAnimationTypeTransform,//
};

@interface BOSHAnimation : NSObject
@property (nonatomic) BOSHAnimationType animationType;
@property (nonatomic) NSTimeInterval beginTime;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) CAAnimation *animation;

+ (instancetype)animationWithType:(BOSHAnimationType)type;

@end





