//
//  BOSHNoneTouchView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHNoneTouchView.h"

@implementation BOSHNoneTouchView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *v = [super hitTest:point withEvent:event];
    if(v == self)
    {
        return nil;
    }
    return v;
}
@end
