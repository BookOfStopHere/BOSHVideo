//
//  SSProgressBar.m
//  SSPlayer
//
//  Created by 1 on 16/12/25.
//  Copyright © 2016年 SSPlayer. All rights reserved.
//

#import "SSProgressBar.h"

@implementation SSProgressBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (SSSlider *)slider
{
    if(!_slider)
    {
        _slider = [[SSSlider alloc] init];
        _slider.backgroundColor = [UIColor clearColor];
        [self addSubview:_slider];
    }
    return _slider;
}

- (UILabel *)curTimeLabel
{
    if(!_curTimeLabel)
    {
        _curTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _curTimeLabel.font = [UIFont systemFontOfSize:10];
        _curTimeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_curTimeLabel];
    }
    return _curTimeLabel;
}

- (UILabel *)totalTimeLabel
{
    if(!_totalTimeLabel)
    {
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalTimeLabel.font = [UIFont systemFontOfSize:10];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_totalTimeLabel];
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreen
{
    if(!_fullScreen)
    {
        _fullScreen = [[UIButton alloc] init];
        [_fullScreen addTarget:self action:@selector(screenSizeWillChange:) forControlEvents:UIControlEventTouchUpInside];
        [_fullScreen setImage:[UIImage imageNamed:@"Full_Screen_48"] forState:0];
        [self addSubview:_fullScreen];
    }
    return _fullScreen;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self reLayout];
}

- (void)setCurTime:(double)curTime totalTime:(double)totalTime
{
    self.curTimeLabel.text = [self timeFormatted:curTime];
    self.totalTimeLabel.text = [self timeFormatted:totalTime];
    self.slider.progress = totalTime == 0 ? 0 : curTime/totalTime;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)reLayout
{
    [self.curTimeLabel sizeToFit];
    [self.totalTimeLabel sizeToFit];
    CGRect cFrame = self.curTimeLabel.frame;
    CGRect tFrame = self.totalTimeLabel.frame;
    
    cFrame.origin.x = 10;
    cFrame.origin.y = (self.frame.size.height - (cFrame.size.height + tFrame.size.height + 5))/2;
    
    tFrame.origin.x = 10;
    tFrame.origin.y = cFrame.size.height + cFrame.origin.y + 5;
    
    self.curTimeLabel.frame = cFrame;
    self.totalTimeLabel.frame = tFrame;
    
    CGFloat s_x = MAX(cFrame.size.width + cFrame.origin.x, tFrame.size.width + tFrame.origin.x) + 10;
    self.slider.frame = CGRectMake( s_x, (self.frame.size.height - 20)/2, self.frame.size.width - 60 - s_x, 20);
    self.fullScreen.frame = CGRectMake(self.frame.size.width - 10 - 40, 0, 40, 40);
}

- (NSString *)timeFormatted:(double)totalSeconds
{
    
    int seconds = (long long)totalSeconds % 60;
    int minutes = ((long long)totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


- (void)screenSizeWillChange:(UIButton *)btn
{
    self.screenSizeWillChange ? _screenSizeWillChange() : YES;
}
@end
