//
//  BOSHTimelineAsset.h
//  BOSHVideo
//
//  Created by yang on 2017/11/13.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOSHTrack.h"
#import "BOSHAudioTrack.h"
#import "BOSHVideoTrack.h"
#import "BOSHTransitonInstruction.h"
#import "BOSHOverlayTrack.h"
#import "BOSHFilterInstruction.h"

//@interface BOSHTimelineSetting : NSObject
//
///**
// * 视频尺寸
// */
//@property (nonatomic) CGSize size;
//
///**
// * 视频的帧率
// */
//@property (nonatomic) int fps;
//
///**
// * 主辅音调节
// */
//@property (nonatomic) float volumeBalance;
//
//@end

@interface BOSHTimelineAsset : NSObject

/**
 * 视频 (顺序拼接)
 */
@property (nonatomic, strong) NSArray <BOSHVideoTrack *>*videos;

/**
 * 音频
 */
@property (nonatomic, strong) NSArray <BOSHAudioTrack *>*audios;

/**
 * 转场
 */
@property (nonatomic, strong) NSArray <BOSHTransitonInstruction *>*transations;

/**
 * 贴图，歌词、GIF等
 */
@property (nonatomic, strong) NSArray <BOSHOverlayTrack *>*overlays;

/**
 * 滤镜类型 （与视频顺序一致）
 */
@property (nonatomic, strong) NSArray <BOSHFilterInstruction *>*filters;

/**
 * 视频设置
 */
//@property (nonatomic, readonly) BOSHTimelineSetting *setting;

/**
 * @TODO AR ／VR
 */


/**
 * 视频尺寸
 */
@property (nonatomic) CGSize size;

/**
 * 视频的帧率
 */
@property (nonatomic) int fps;

/**
 * 主辅音调节(0~1)
 */
@property (nonatomic) float volumeBalance;


+ (instancetype)defaultTimelineAsset;

@end
