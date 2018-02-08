//
//  BOSHMaskView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHMaskView.h"

@implementation BOSHMaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if([view isDescendantOfView:self])
    {
        for(UIView *passView in self.passthroughViews)
        {
            CGRect rect = [self convertRect:passView.bounds fromView:passView];
            if(CGRectContainsPoint(rect, point))
            {
                return nil;
            }
        }
    }
    return view;
}

@end
