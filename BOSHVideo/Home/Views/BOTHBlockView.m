//
//  BOTHBlockView.m
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHBlockView.h"

@implementation BOTHBlockView

//- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
//{
////    self.actionButton
//}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if([view isDescendantOfView:self])
    {
        return self;
    }
    return view;
}
@end
