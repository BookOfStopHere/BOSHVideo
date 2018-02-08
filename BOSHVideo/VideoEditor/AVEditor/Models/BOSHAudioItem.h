//
//  BOSHAudioItem.h
//  BOSHVideo
//
//  Created by yang on 2017/10/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHMediaItem.h"

@interface BOSHAudioItem : BOSHMediaItem

/**
 * 音频的第一个Track
 */
@property (nonatomic, strong) AVAssetTrack *anyTrack;

/**
 * 音频增益
 */
@property (nonatomic, assign) float volume;

/**
 * 初始化方法
 */
+ (BOSHAudioItem *)videoItemWithURL:(NSURL *)URL;

@end
