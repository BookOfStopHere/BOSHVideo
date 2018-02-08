//
//  AVPlayerItem+ThumbImage.h
//  BOSHVideo
//
//  Created by yang on 2017/10/17.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AVPlayerItem (ThumbImage)

/**
 * get image at current time
 * Should addoput First
 */
- (UIImage *)getCurrentFrame;


@end
