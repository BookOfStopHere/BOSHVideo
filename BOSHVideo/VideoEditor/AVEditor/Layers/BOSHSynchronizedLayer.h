//
//  BOSHSynchronizedLayer.h
//  BOSHVideo
//
//  Created by yang on 2017/12/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface BOSHSynchronizedLayer : AVSynchronizedLayer

@property (nonatomic) UIEdgeInsets insets;



//已经转换成父坐标系
- (CGRect)contentRect;


- (void)addBOSHSublayer:(CALayer *)sublayer;

@end
