//
//  UIImage+VideoThumb.h
//  BOSHVideo
//
//  Created by yang on 2017/10/17.
//  Copyright © 2017年 yang. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface UIImage (VideoThumb)

/**
 * Extract frame from on-line video at the very time
 */
+ (UIImage *)getVideoPreviewImageWithURL:(NSString *)videoURL atTime:(NSTimeInterval)posTime;

/**
 * Extract frame from off-line video at the very time
 */
+ (UIImage *)getVideoPreviewImageWithFileURL:(NSString *)videoURL atTime:(NSTimeInterval)posTime;

@end
