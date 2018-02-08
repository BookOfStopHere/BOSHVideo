//
//  BOSHTransitionSegment.h
//  BOSHVideo
//
//  Created by yang on 2017/11/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "BOSHTransitonInstruction.h"
#import <UIKit/UIKit.h>
#import "BOSHTimelineHelper.h"

/**
 * 功能：音视频的过渡特效处理
 * 音频：此类处理的是视频文件中自带的音频分段，不涉及后期添加的音频（如录音+ music）
 * 也就是只处理AudioTrack0 和 AudioTrack1
 * 视频：处理输入的视频分段，VideoTrack0 和 VideoTrack1 （目前我们只有这两种Track，如果以后增加了"画中画"我们会增加新的Track单独处理这种情况）
 */

@interface BOSHTransitionSegment : NSObject

@property (nonatomic) CMTimeRange timeRange;
@property (nonatomic, strong) AVMutableCompositionTrack *fromVideoTrack;
@property (nonatomic, strong) AVMutableCompositionTrack *toVideoTrack;
@property (nonatomic, strong) AVMutableCompositionTrack *fromAudioTrack;
@property (nonatomic, strong) AVMutableCompositionTrack *toAudioTrack;

@property (nonatomic) BOSHTransitionType transitionType;

@property (nonatomic) CGSize fromTrackSize;
@property (nonatomic) CGSize toTrackSize;
@property (nonatomic) CGSize targetSize;

//原始
@property (nonatomic) float volume;

- (NSArray<AVAudioMixInputParameters *> *)audioMixInputParameters;
- (AVMutableVideoCompositionInstruction *)videoCompositionInstruction;

@end
