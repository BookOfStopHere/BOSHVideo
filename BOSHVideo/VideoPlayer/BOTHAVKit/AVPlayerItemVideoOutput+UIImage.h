//
//  AVPlayerItemVideoOutput+UIImage.h
//  BOSHVideo
//
//  Created by yang on 2017/10/17.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AVPlayerItemVideoOutput (UIImage)

/**
 * Get Image At Time
 */
- (UIImage *)getImageAtTime:(CMTime)itemTime;

@end
