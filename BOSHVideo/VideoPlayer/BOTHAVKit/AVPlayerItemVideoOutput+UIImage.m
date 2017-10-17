//
//  AVPlayerItemVideoOutput+UIImage.m
//  BOSHVideo
//
//  Created by yang on 2017/10/17.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "AVPlayerItemVideoOutput+UIImage.h"

@implementation AVPlayerItemVideoOutput (UIImage)

- (UIImage *)getImageAtTime:(CMTime)itemTime
{
    if([self hasNewPixelBufferForItemTime:itemTime])
    {
        CVPixelBufferRef pixelBuffer = [self copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        CGImageRef videoImage = [temporaryContext
                                 createCGImage:ciImage
                                 fromRect:CGRectMake(0, 0,
                                                     CVPixelBufferGetWidth(pixelBuffer),
                                                     CVPixelBufferGetHeight(pixelBuffer))];
        
        UIImage *currentframe = [UIImage imageWithCGImage:videoImage];
        CGImageRelease(videoImage);
        return currentframe;
    }
    return nil;
}

@end
