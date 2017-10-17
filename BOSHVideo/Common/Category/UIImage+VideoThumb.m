//
//  UIImage+VideoThumb.m
//  BOSHVideo
//
//  Created by yang on 2017/10/17.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "UIImage+VideoThumb.h"
#include <AVFoundation/AVFoundation.h>

@implementation UIImage (VideoThumb)


+ (UIImage *)getVideoPreviewImageWithURL:(NSString *)videoURL atTime:(NSTimeInterval)posTime
{
    if(videoURL.length <= 0) return nil;
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSArray<AVAssetTrack *> *track = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(posTime,  [track firstObject].nominalFrameRate );
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    asset = nil;
    return thumb;
}


+ (UIImage *)getVideoPreviewImageWithFileURL:(NSString *)videoURL atTime:(NSTimeInterval)posTime
{
    if(videoURL.length <= 0) return nil;
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSArray<AVAssetTrack *> *track = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(posTime,  [track firstObject].nominalFrameRate );
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    asset = nil;
    return thumb;
}

@end
