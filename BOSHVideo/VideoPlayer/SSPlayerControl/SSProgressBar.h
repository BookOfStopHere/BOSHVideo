//
//  SSProgressBar.h
//  SSPlayer
//
//  Created by 1 on 16/12/25.
//  Copyright © 2016年 SSPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSSlider.h"

@interface SSProgressBar : UIView

@property (nonatomic) UILabel *curTimeLabel;
@property (nonatomic) UILabel *totalTimeLabel;
@property (nonatomic, strong) SSSlider *slider;
@property (nonatomic, strong) UIButton *fullScreen;

@property (nonatomic, copy) void (^screenSizeWillChange)(void);

- (void)setCurTime:(double)curTime totalTime:(double)totalTime;
@end
