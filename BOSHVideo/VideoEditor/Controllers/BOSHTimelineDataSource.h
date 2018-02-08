//
//  BOSHTimelineDataSource.h
//  BOSHVideo
//
//  Created by yang on 2017/11/13.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOSHTrack.h"
#import "BOSHTimelineAsset.h"
#import "BOSHSingleRowCollectionViewLayout.h"

@interface BOSHTimelineDataSource : NSObject <BOSHSingleRowCollectionViewLayoutDelegate>
@property (nonatomic, weak) UICollectionView *table;


@property (nonatomic) BOOL isEditing;
/**
 * 删除视频
 */
@property (nonatomic, copy) void(^deleteVideoActionHandler)(id data);

/**
 * 添加视频
 */
@property (nonatomic, copy) void(^addVideoActionHandler)(void);

/**
 * 变更转场
 */
@property (nonatomic, copy) void(^changeTransitionActionHandler)(void);


/**
 * 点击某段
 */
@property (nonatomic, copy) void(^clickActionHandler)(NSIndexPath *index);


+ (id)dataSourceWithTarget:(UICollectionView *) table;


- (void)movItemAtIndexPath:(NSIndexPath *)fromIndex toIndexPath:(NSIndexPath *)toIndex;

/**
 * 插入视频分段
 */
- (void)addVideo:(BOSHVideoItem *)video;


/**
 * 生成timelineasset 结构
 * 包含[视频分段（包含音频是否静音） 转场
 */
- (BOSHTimelineAsset *)timelineAsset;

@end
