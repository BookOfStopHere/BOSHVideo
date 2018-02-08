//
//  BOSHRippleLineView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHRippleLineView.h"
#import <AVFoundation/AVFoundation.h>

@interface BOSHRippleLineView ()
@property (nonatomic, strong) NSMutableArray *mpointArr;
@end

@implementation BOSHRippleLineView

-(void)drawRect:(CGRect)rect
{
//    http://www.jianshu.com/p/81adddd41dcb
    if (!self.mpointArr)
    {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor blueColor] setStroke];
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, self.frame.size.height/2.0);
    
    for (int i = 0; i < [self.mpointArr count]; i++)
    {
        CGPoint point = [self.mpointArr[i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height/2.0);
    CGContextStrokePath(context);
}

@end
