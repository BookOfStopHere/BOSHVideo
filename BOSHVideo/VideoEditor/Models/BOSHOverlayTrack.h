//
//  BOSHOverlayTrack.h
//  BOSHVideo
//
//  Created by yang on 2017/11/9.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTrack.h"
#import <UIKit/UIKit.h>
#import "BOSHOverlay.h"

@interface BOSHOverlayTrack : BOSHTrack

/**
 * 支持三种overlay
 * 文字、图片、GIF
 */
@property (nonatomic, strong) BOSHOverlay *overlay;

+ (instancetype)itemWithOverlay:(BOSHOverlay *)overlay;

- (CALayer *)overlayer;

@end



