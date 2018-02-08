//
//  BOSHProgressView.h
//  BOSHVideo
//
//  Created by yang on 2017/11/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "BOTHRange.h"
#import "BOTHTimeView.h"
#import "BOSHNoneTouchView.h"

@interface BOSHProgressView : UIView <UIScrollViewDelegate>
{
    @public
      CGFloat _thumbLength;
}
@property (nonatomic, strong) BOSHNoneTouchView *indicatorView;
@property (nonatomic, assign) BOOL isSeeking;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BOTHTimeView *timeLabel;

@property (nonatomic, assign) float duration;
@property (nonatomic, copy) void(^seekHandler)(double time, int state);

- (void)setImages:(NSArray <UIImage *> *)images;

+ (CGFloat)preferHeight;

- (double)getCurrentTime;

- (void)setCurTime:(double)curTime;
@end
