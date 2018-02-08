//
//  BOSHTransition.h
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

typedef NS_ENUM(NSInteger,  BOTHTransitionType){
    BOTHTransitionTypeNone,//无动画
    BOTHTransitionTypePush,//默认从右只左滑出
    BOTHTransitionTypeFade,//淡入淡出
    BOTHTransitionTypeRotate//旋转
};

@interface BOSHTransition : NSObject

/**
 * 类型
 */
@property (nonatomic) BOTHTransitionType transitionType;

/**
 * 变换
 */
@property (nonatomic) CGAffineTransform transform;

/**
 * 动画的时间参数
 */
@property (nonatomic) CMTimeRange timeRange;

/**
 * 默认的
 */
+ (instancetype)transiton;

/**
 * 推拉动画
 */
+ (instancetype)pushTransitonWithDuration:(CMTime)duration;

/**
 * 淡入淡出动画
 */
+ (instancetype)fadeTransitionWithDuration:(CMTime)duration;


/**
 * 旋转动画
 */
+ (instancetype)rotateTransitionWithDuration:(CMTime)duration;

@end
