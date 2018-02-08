//
//  BOSHAudioTrack.h
//  BOSHVideo
//
//  Created by yang on 2017/11/9.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTrack.h"
#import "BOSHAudioItem.h"



@interface BOSHAudioTrack : BOSHTrack

@property (nonatomic, strong) BOSHAudioItem *media;

/**
 * 与原始声音占比[0 1]
 */
@property (nonatomic, assign) float volumeRatio;

/**
 * 音频类型
 */
@property (nonatomic, assign) BOSHAudioType audioType;

/**
 * 基于BOSHMediaItem 的初始化
 */
+ (id)modelWithMediaItem:(BOSHMediaItem *)media;


/**
 * 本地文件加载
 */
+ (BOSHAudioTrack *)audioTrackWithTimeRange:(CMTimeRange)range  ofURL:(NSURL *)URL atTime:(CMTime)startTime;

/**
 * 加载本地文件
 */
+ (BOSHAudioTrack *)audioTrackOfURL:(NSURL *)URL atTime:(CMTime)startTime;

@end
