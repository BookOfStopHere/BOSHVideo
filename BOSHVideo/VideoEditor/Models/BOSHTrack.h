//
//  BOSHTrack.h
//  BOSHVideo
//
//  Created by yang on 2017/11/9.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "BOSHTLTiming.h"

typedef NS_ENUM(NSInteger, BOSHTransitionType){
    BOSHTransitionTypeNone,//无
    BOSHTransitionFlipFromRight ,//划入
    BOSHTransitionFade,//渐变
    BOSHTransitionTypePush,//推拉模式
    BOSHTransitionDissovle,//中间逐渐缩小直到溶解
    BOSHTransitionCurtain,//窗帘动画
    
};

typedef NS_ENUM(NSInteger, BOSHFilterType){
    BOSHFilterTypeNone,//无
    BOSHFilterType1 ,//
    BOSHFilterType2,//
    BOSHFilterType3,//
};

typedef NS_ENUM(NSInteger, BOSHAudioType){
    BOSHAudioTypeFile,//文件
    BOSHAudioTypeRecord ,//录音
};

typedef NS_ENUM(NSInteger, BOSHTrackType){
    BOSHTimelineTypeVideo,//视频
    BOSHTimelineTypeAudio ,//音频
    BOSHTimelineTypeTransition,//转场
    BOSHTimelineTypeOverlay,//贴纸
    BOSHTimelineTypeFilter,//滤镜
};


@interface BOSHTrack : NSObject <BOSHTLTiming>
{
    @public
    CGFloat _widthInTimeline;
    CGFloat _maxWidthInTimeline;
    CGPoint _positionInTimeline;
}
/**
 * 快/慢
 */
@property (nonatomic) float timeScale;

/**
 * 轨(只针对音视频字幕，其他invalid)
 * 在自定义 转场动画，或者获取真正的Track时 灰常关键
 */
@property (nonatomic) CMPersistentTrackID trackID;


/**
 * 在时间轴上的默认物理长度 54
 */
@property (nonatomic) CGFloat preferedWidthInTimeline;

/**
 * 在时间轴上的物理长度
 */
@property (nonatomic) CGFloat widthInTimeline;

/**
 * 最大的视频长度
 */
@property (nonatomic) CGFloat maxWidthInTimeline;//

/**
 * 计算位置， 根据此计算startrange
 */
@property (nonatomic) CGPoint positionInTimeline;

/**
 * 类型
 */
@property (nonatomic) BOSHTrackType itemType;

@end
