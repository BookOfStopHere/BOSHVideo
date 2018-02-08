//
//  BOSHVideoTrack.h
//  BOSHVideo
//
//  Created by yang on 2017/11/9.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTrack.h"
#import "BOSHVideoItem.h"

@interface BOSHVideoTrack : BOSHTrack
/**
 * 视频序列
 */
@property (nonatomic, strong) BOSHVideoItem *media;

///**
// * 转场动画，默认 BOSHTransitionTypeNone
// */
//@property (nonatomic, assign) BOSHTransitionType transition;

/**
 * 滤镜类型
 */
@property (nonatomic, assign) BOSHFilterType filterType;


+ (id)modelWithMediaItem:(BOSHMediaItem *)media;

/**
 * 基于插入点生成track
 */
+ (id)videoTrackWithMediaItem:(BOSHMediaItem *)media  atTime:(CMTime)startTime;

/**
 * 本地文件加载
 */
+ (BOSHVideoTrack *)videoTrackWithTimeRange:(CMTimeRange)range  ofURL:(NSURL *)URL atTime:(CMTime)startTime;

/**
 * 加载本地文件
 */
+ (BOSHVideoTrack *)videoTrackOfURL:(NSURL *)URL atTime:(CMTime)startTime;

@end
