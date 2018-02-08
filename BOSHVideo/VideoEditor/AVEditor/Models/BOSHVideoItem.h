//
//  BOSHVideoItem.h
//  BOSHVideo
//
//  Created by yang on 2017/10/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHMediaItem.h"
#import "BOTHOverlayCommand.h"


@interface BOSHVideoItem : BOSHMediaItem

/**
 * 帧率
 */
@property (nonatomic, readonly) float fps;

/**
 * 每帧时长
 */
@property (nonatomic, readonly) CMTime frameDuration;

/**
 * 视频尺寸
 */
@property (nonatomic, assign) CGSize videoSize;

/**
 * 获取第一个视频Track
 */
@property (nonatomic, strong) AVAssetTrack *anyTrack;

/**
 * 获取第一个视频Track
 */
@property (nonatomic, strong) AVAssetTrack *audioTrack;

/**
 * 获取第一个视频Track
 */
@property (nonatomic, strong) AVAssetTrack *videoTrack;

/**
 * 视频初始的旋转
 */
@property (nonatomic, assign) CGAffineTransform preferTransform;

/**
 * 缩略图
 */
@property (nonatomic, strong) NSArray <UIImage *> *thumbnail;

/**
 * 顶点缩略图
 */
- (UIImage *)thumbImageAtTime:(NSTimeInterval)time;

/**
 * 初始化方法
 */
+ (BOSHVideoItem *)videoItemWithURL:(NSURL *)URL;

@end
