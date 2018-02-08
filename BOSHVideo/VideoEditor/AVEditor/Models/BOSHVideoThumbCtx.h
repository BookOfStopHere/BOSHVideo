//
//  BOSHVideoThumbCtx.h
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


/**
 * 生成缩略图
 */

@interface BOSHVideoThumbCtx : NSObject

@property (nonatomic, readonly) AVURLAsset *asset;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) CGSize videoSize;
@property (nonatomic, readonly) NSInteger frames;

@property (nonatomic, readonly) float nominalFrameRate;


+ (BOSHVideoThumbCtx *)thumbCtxWithVideo:(NSURL *)url;

- (UIImage *)thumbImageAtTime:(NSTimeInterval)time;

- (void)thumbImagesWithFPS:(NSInteger)fps atTime:(NSTimeInterval)time  duration:(NSTimeInterval)duration completionHandler:(void(^)(UIImage *image))handler;

@end
