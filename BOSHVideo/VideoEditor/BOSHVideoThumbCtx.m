//
//  BOSHVideoThumbCtx.m
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHVideoThumbCtx.h"

@implementation BOSHVideoThumbCtx

+ (BOSHVideoThumbCtx *)thumbCtxWithVideo:(NSURL *)url
{
    if(url)
    {
        BOSHVideoThumbCtx *ctx = BOSHVideoThumbCtx.new;
         AVURLAsset *asset =  [[AVURLAsset alloc] initWithURL:url options:nil];
        ctx->_asset = asset;
        ctx->_duration = asset.duration.value*1.0f/asset.duration.timescale;
        
        //计算帧率、帧数
        NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [videoTracks firstObject];
        ctx->_videoSize = videoTrack.naturalSize;
        ctx->_nominalFrameRate = videoTrack.nominalFrameRate;
        ctx->_frames = ctx->_duration*ctx->_nominalFrameRate;
        
        return ctx;
    }
    return nil;
}

- (UIImage *)thumbImageAtTime:(NSTimeInterval)time
{
    //字典@{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES/NO),AVURLAssetReferenceRestrictionsKey} 计算duration 是否精确，精确比较费时，传空默认不精确
    NSParameterAssert(_asset);
    NSArray *videoTracks = [_asset tracksWithMediaType:AVMediaTypeVideo];
    if([videoTracks count] > 0)
    {
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc]initWithAsset:_asset];
        generator.appliesPreferredTrackTransform = YES;//截图时调整正确的方向
        
        CMTime cmtime = CMTimeMakeWithSeconds(time, _asset.duration.timescale);//
        CGImageRef imageRef = [generator copyCGImageAtTime:cmtime actualTime:nil error:nil];
        UIImage *captureImage = [UIImage imageWithCGImage:imageRef];
        return captureImage;
    }
    return nil;
}

- (void)thumbImagesWithFPS:(NSInteger)fps atTime:(NSTimeInterval)time  duration:(NSTimeInterval)duration completionHandler:(void(^)(UIImage *image))handler
{
    //计算
    NSUInteger newFrames = (NSUInteger)(duration * fps);
    newFrames = MIN(newFrames, (NSUInteger)((self.duration - time) *  self.nominalFrameRate));

    @autoreleasepool {
        for(int ii =0; ii < newFrames; ii ++)
        {
            if(handler)
            {
                handler([self thumbImageAtTime:(time + ii / (fps + 0.0))]);
            }
        }
    }
}

@end
