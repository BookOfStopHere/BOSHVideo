//
//  AVPlayerItem+ThumbImage.m
//  BOSHVideo
//
//  Created by yang on 2017/10/17.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "AVPlayerItem+ThumbImage.h"

@implementation AVPlayerItem (ThumbImage)

- (UIImage *)getCurrentFrame
{
    if(self.outputs.count)
    {
        AVPlayerItemOutput *output = [self.outputs firstObject];
        if(output && [output isKindOfClass:AVPlayerItemVideoOutput.class])
        {
            AVPlayerItemVideoOutput *videoOut = (AVPlayerItemVideoOutput *)output;
            if([videoOut hasNewPixelBufferForItemTime:self.currentTime])
            {
                CVPixelBufferRef pixelBuffer = [videoOut copyPixelBufferForItemTime:self.currentTime itemTimeForDisplay:nil];
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
        }
    }
    return nil;
}

@end
