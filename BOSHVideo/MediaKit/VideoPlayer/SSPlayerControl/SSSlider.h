//
//  SSSlider.h
//  SSPlayer
//
//  Created by 1 on 16/12/25.
//  Copyright © 2016年 SSPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SSSliderState) {
    SSSliderSeekingStateNone,
    SSSliderSeekingStateBegin,
    SSSliderSeekingStateChange,
    SSSliderSeekingStateEnd,
};

@interface SSSlider : UIView
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) void(^seekAction)(SSSliderState gestureState,CGFloat progress);

@property (nonatomic, assign) BOOL isSeeking;
@end
