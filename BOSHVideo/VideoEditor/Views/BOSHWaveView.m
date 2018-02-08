//
//  BOSHWaveView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHWaveView.h"

@implementation BOSHWaveView

//- (void)drawRect:(CGRect)rect
//{
//     //坐标变换
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, 0.0f, (self.bounds.size.height));
//    CGContextScaleCTM(context, 1.0f, -1.0f);
//    //绘制曲线
//    CGColorRef colorRef = [[UIColor redColor] CGColor];
//    // [UIColor redColor] 红色 OC的红色 OC类型的
//    // CGColor转化成C语言的iOS类型的红色
//    CGContextSetStrokeColorWithColor(context, colorRef);
//    CGContextSetLineWidth(context, 1.0f);
//    CGContextClearRect(context, self.bounds);
//    // 清除context画布上上面 self.bounds区域
//    
//    CGPoint firstPoint = CGPointMake(0.0f, [[averagePointArray objectAtIndex:0] floatValue]);
//    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
//    
//    for (int i = 1; i < [peakPointArray count]; i++)
//    {
//        CGPoint point = CGPointMake(i, ([[averagePointArray objectAtIndex:i] floatValue]*self.bounds.size.height));
//        CGContextAddLineToPoint(context, point.x, point.y);
//    }
//    CGContextStrokePath(context);
//}

@end
