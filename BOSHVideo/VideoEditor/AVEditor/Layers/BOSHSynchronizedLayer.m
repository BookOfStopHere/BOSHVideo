//
//  BOSHSynchronizedLayer.m
//  BOSHVideo
//
//  Created by yang on 2017/12/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHSynchronizedLayer.h"
@interface BOSHSynchronizedLayer ()
@property (weak,nonatomic) CALayer *sublayerInternal;
@end
@implementation BOSHSynchronizedLayer


- (void)addBOSHSublayer:(CALayer *)sublayer
{
    self.sublayerInternal = sublayer;
    [self addSublayer:sublayer];
}

- (void)layoutSublayers
{
//https://stackoverflow.com/questions/34380649/update-calayer-sublayers-immediately
//    [CATransaction setValue:(__bridge id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//    CGRect rect = CGRectMake(self.insets.left, self.insets.top, self.bounds.size.width - self.insets.left - self.insets.right, self.bounds.size.height - self.insets.top - self.insets.bottom);
//    self.sublayerInternal.frame = rect;
//   [CATransaction commit];
    [super layoutSublayers];
}

- (CGRect)contentRect
{
    CGRect rect = CGRectMake(self.insets.left, self.insets.top, self.bounds.size.width - self.insets.left - self.insets.right, self.bounds.size.height - self.insets.top - self.insets.bottom);
    return  [self convertRect:rect toLayer:self.superlayer];
}

@end
