//
//  BOSHTimelineViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/11/13.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOSHVideoTrack.h"
#import "BOSHTransitonInstruction.h"
#import "BOSHTimelineAsset.h"
#import "BOSHDefines.h"

/**
 * 添加视频操作
 */
@interface BOSHTimelineViewController : BOSHBaseViewController

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 * 插入视频分段
 */
- (void)addVideo:(BOSHVideoItem *)video;

/**
 * 生成timelineasset 结构
 * 包含[视频分段（包含音频是否静音） 转场
 */
- (BOSHTimelineAsset *)timelineAsset;


@property (nonatomic, copy) void(^segmentActionHandler)(BOSHTimelineAction actionType);

@end
