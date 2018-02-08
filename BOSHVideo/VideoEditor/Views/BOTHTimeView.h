//
//  BOTHTimeView.h
//  BOSHVideo
//
//  Created by yang on 2017/11/3.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOTHTimeView : UILabel

- (void)setCurTime:(double)curTime andDuration:(double)duration;

- (void)setTime:(double)time;
- (void)setTime:(double)time addPrefixString:(NSString *)prefix;

- (void)showTimeInHighPrecision:(double)time;

@end
