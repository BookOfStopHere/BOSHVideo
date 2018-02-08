//
//  BOSHTimelineHelper.h
//  BOSHVideo
//
//  Created by yang on 2017/11/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "BOSHTimelineAsset.h"
/********************************************************************************************
 * 以下方法仅为 timeline使用，不具有通用性
 * 处理特殊场景下的功能
 ********************************************************************************************/

/**
 * 中心点变换
 * scale 传0 时默认scale = MIN(toSize.height/fromSize.height,toSize.width/fromSize.width)
 */
static inline CGAffineTransform BOSHSizeTransfrom(CGSize fromSize, CGSize toSize, float scale)
{
    scale = scale <= 0 ? MIN(toSize.height/fromSize.height,toSize.width/fromSize.width) : scale;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale,scale);
    CGAffineTransform movTransform = CGAffineTransformMakeTranslation((toSize.width - fromSize.width*scale)/2,(toSize.height - fromSize.height*scale)/2);
    return CGAffineTransformConcat(scaleTransform, movTransform);
}

/**
 * 创建Insturction
 */
static inline AVMutableVideoCompositionInstruction *BOSHVideoSingleInstruction(AVAssetTrack *track, CMTimeRange timeRange)
{
    AVMutableVideoCompositionInstruction * compositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    compositionInstruction.timeRange = timeRange;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:track];
    compositionInstruction.layerInstructions = @[layerInstruction];
    return compositionInstruction;
}

static inline AVMutableVideoCompositionInstruction *BOSHVideoTwoInstructions(AVAssetTrack *fromTrack, AVAssetTrack *toTrack, CMTimeRange timeRange)
{
    AVMutableVideoCompositionInstruction * compositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    compositionInstruction.timeRange = timeRange;
    
    AVMutableVideoCompositionLayerInstruction *fromLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:fromTrack];
        AVMutableVideoCompositionLayerInstruction *toLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:toTrack];
    
    compositionInstruction.layerInstructions = @[fromLayerInstruction,toLayerInstruction];
    return compositionInstruction;
}

static inline NSArray <AVMutableCompositionTrack *>* BOSHAllocVideoCompositionTrack(AVMutableComposition  *mixComposition, int count)
{
    NSMutableArray *array = [NSMutableArray array];
    for(int ii = 0; ii < count; ii ++)
    {
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        [array addObject:compositionVideoTrack];
    }
    return array.count ? array : nil;
}

static inline NSArray <AVMutableCompositionTrack *>* BOSHAllocAudioCompositionTrack(AVMutableComposition  *mixComposition,int count)
{
    NSMutableArray *array = [NSMutableArray array];
    for(int ii = 0; ii < count; ii ++)
    {
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        [array addObject:compositionVideoTrack];
    }
    return array.count ? array : nil;
}


/**
 * 时间计算
 */
static inline CMTime BOSHCMTimeMake(double seconds, CMTime referenceTime)
{
    CMTimeValue value = (seconds/CMTimeGetSeconds(referenceTime))* referenceTime.value;
    
    return CMTimeMake(value,referenceTime.timescale);
}

static inline double BOSHSecondsAdd(CMTime addTime1, CMTime addTime2)
{
    return CMTimeGetSeconds(CMTimeAdd(addTime1,addTime2));
}

static inline CMTime BOSHCMTimeAddSeconds(CMTime addTime, double seconds)
{
    return CMTimeAdd(addTime,BOSHCMTimeMake(seconds,addTime));
}

//原始音乐的音量
static inline float BOSHGetSourceBalanceVolume(float balance)
{
    return balance;
}
 //配音的音量
static inline float BOSHGetMixBalanceVolume(float balance)
{
    return 1- balance;
}

//视频加载中的左边转换
static inline CGRect BOSHConvertRectToDevice(CGSize convas,CGRect rect)
{
    return CGRectMake(rect.origin.x,convas.height - rect.origin.y,rect.size.width,rect.size.height);
}

//@property (nonatomic) CMTimeRange timeRange;
//@property (nonatomic, strong) AVMutableCompositionTrack *fromTrack;
//@property (nonatomic, strong) AVMutableCompositionTrack *toTrack;
//@property (nonatomic) BOTHTransitionType transitionType;

@interface BOSHTimelineHelper : NSObject

@property (nonatomic, strong)  BOSHTimelineAsset *timelineAsset;
- (AVPlayerItem *)test;
- (AVPlayerItem *)testDIY;
@end

