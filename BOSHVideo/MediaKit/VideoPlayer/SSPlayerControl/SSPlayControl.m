//
//  SSPlayControl.m
//  SSPlayer
//
//  Created by 1 on 16/12/25.
//  Copyright © 2016年 SSPlayer. All rights reserved.
//

#import "SSPlayControl.h"

@interface SSPlayControl ()
@end

@implementation SSPlayControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.progressBar.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40);
}


- (void)showProgressBar
{
    [self.progressBar.layer removeAllAnimations];
    self.progressBar.alpha = 1;
    [self dismissProgressBar:YES delay:5 duration:1];
}

- (void)dismissProgressBar:(BOOL)animation delay:(CGFloat)delay duration:(CGFloat)duration
{
    if(animation)
    {
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakself.progressBar.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self.progressBar.layer removeAllAnimations];
        self.progressBar.alpha = 0;
    }
}

- (SSProgressBar *)progressBar
{
    if(!_progressBar)
    {
        _progressBar = [SSProgressBar new];
        _progressBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_progressBar];
    }
    return _progressBar;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showProgressBar];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
