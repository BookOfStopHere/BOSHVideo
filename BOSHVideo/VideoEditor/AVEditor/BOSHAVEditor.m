//
//  BOSHAVEditor.m
//  BOSHVideo
//
//  Created by yang on 2017/10/18.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHAVEditor.h"
#import "BOSHTransitionSegment.h"
#import "BOSHPassthoughSegment.h"
#import "BOSHTimelineHelper.h"
//  video  and audio editor

#define kVideoTrack 0
#define kAudioTrack 1

/**
 *
 *
 */

/**
 * 现在规定 音频目前设置三个轨，
 * Source0 原声轨道
 * Source1 原声轨道
 * Source2  配音轨道(添加音频轨道)
 */
#define kAudioTrackSource0 (self.audioTracks[0])
#define kAudioTrackSource1 (self.audioTracks[1])
#define kAudioTrackSource2  (self.audioTracks[2])

/*
 * 视频目前只有2轨道
 */

@interface BOSHAVEditor ()
{
    
}
//During playback or other processing, such as export, without the use of an AVVideoComposition only the first enabled video track will be processed. Other video tracks are effectively ignored. To control the compositing of multiple enabled video tracks, you must create and configure an instance of AVVideoComposition and set it as the value of the videoComposition property of the AVFoundation object you're using to control processing, such as an AVPlayerItem or AVAssetExportSession.
@property (nonatomic, strong) AVMutableComposition *mixComposition;
@property (nonatomic, strong)  AVMutableVideoComposition *videoComposition;
@property (nonatomic, strong)  AVMutableAudioMix *audioMix;
@property (nonatomic, strong)  BOSHTimelineAsset *timelineAsset;
@property (nonatomic, strong) NSArray <AVMutableCompositionTrack *> *videoTracks;
@property (nonatomic, strong) NSArray <AVMutableCompositionTrack *> *audioTracks;
@property (nonatomic, strong)  CALayer *parentLayer;
@end

@implementation BOSHAVEditor


+ (id)editorWithTimelineAsset:(BOSHTimelineAsset *)timelineAsset
{
    return  [[self alloc] initWithTimelineAsset:timelineAsset];
}

- (id)initWithTimelineAsset:(BOSHTimelineAsset *)timelineAsset
{
    if(timelineAsset)
    {
        self = [super init];
        self.timelineAsset = timelineAsset;
    }
    return self;
}

- (void)buildVideoTracks
{
    self.videoTracks = BOSHAllocVideoCompositionTrack(self.mixComposition,2);
}

- (void)buildAudioTracks
{
    int count = 2 + 1;//(self.timelineAsset.audios.count > 0);
    self.audioTracks = BOSHAllocAudioCompositionTrack(self.mixComposition,count);
}

- (void)buildComposition
{
    self.mixComposition = [AVMutableComposition composition];
    [self buildAudioTracks];
    [self buildVideoTracks];
    [self buildAudioMix];
    [self insertAudios];//先
    //添加video 并计算transition
    NSArray *transitions = [self insertVideos];
    self.videoComposition =  [AVMutableVideoComposition videoComposition];
    self.videoComposition.renderSize = self.timelineAsset.size;
    self.videoComposition.renderScale = 1;
    self.videoComposition.frameDuration = CMTimeMake(1, self.timelineAsset.fps);
    [self buildTransitions:transitions];
    XLog(@"合成时间 %f",CMTimeGetSeconds(self.mixComposition.duration));
}

///加上transiton 总是不显示画面 ～～～
//1.时间不对
//2.
- (void)buildTransitions:(NSArray *)transitions
{
    NSMutableArray *audioMixInputParameters = [NSMutableArray array];
    NSMutableArray *videoInstructions = [NSMutableArray array];
    for(NSObject *obj in transitions)
    {
        if([obj isKindOfClass:BOSHPassthoughSegment.class])
        {
            NSArray<AVAudioMixInputParameters *> *parameters =  ((BOSHPassthoughSegment*)obj).audioMixInputParameters;
            AVMutableVideoCompositionInstruction *ins = ((BOSHPassthoughSegment*)obj).videoCompositionInstruction;
            if(parameters)
            {
                 [audioMixInputParameters addObjectsFromArray:parameters];
            }
            if(ins)
            {
                [videoInstructions addObject:ins];
            }
        }
        else if([obj isKindOfClass:BOSHTransitionSegment.class])
        {
            NSArray<AVAudioMixInputParameters *> *parameters =  ((BOSHTransitionSegment*)obj).audioMixInputParameters;
            AVMutableVideoCompositionInstruction *ins = ((BOSHTransitionSegment*)obj).videoCompositionInstruction;
            if(parameters)
            {
                [audioMixInputParameters addObjectsFromArray:parameters];
            }
            if(ins)
            {
                [videoInstructions addObject:ins];
            }
        }
    }
    
    self.videoComposition.instructions = videoInstructions;
    [self addAudioMixParameters:audioMixInputParameters];
}


- (void)addAudioMixParameters:(NSArray<AVAudioMixInputParameters *> *)parameters
{
    if(parameters.count <= 0) return;
    NSMutableArray *mixInputParameters = [NSMutableArray array];
    if(self.audioMix.inputParameters.count)
    {
        [mixInputParameters addObjectsFromArray:self.audioMix.inputParameters];
    }
    [mixInputParameters addObjectsFromArray:parameters];
    self.audioMix.inputParameters = mixInputParameters;
}

- (void)buildAudioMix
{
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    self.audioMix = audioMix;
}

//使用的为Timeline时间 插入的时候 就知道时间点
- (void)insertAudios
{
    NSMutableArray <AVMutableAudioMixInputParameters *> *parameters = [NSMutableArray array];
    for(BOSHAudioTrack *audio in self.timelineAsset.audios)
    {
        XLog(@"插入录音: %f,%f    %f, %f",CMTimeGetSeconds(audio.media.timeRange.start),CMTimeGetSeconds(audio.media.timeRange.duration),CMTimeGetSeconds(audio.timeRange.start),CMTimeGetSeconds(audio.timeRange.duration));
        [kAudioTrackSource2 insertTimeRange:audio.media.timeRange ofTrack:audio.media.anyTrack  atTime:audio.timeRange.start error:nil];
        
        AVMutableAudioMixInputParameters *parameter = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:kAudioTrackSource2];
        
        [parameter setVolume:BOSHGetMixBalanceVolume(self.timelineAsset.volumeBalance) atTime:audio.timeRange.start ];
        if(parameter)
        {
            [parameters addObject:parameter];
        }
    }
    [self addAudioMixParameters:parameters];
}

//插入点时间是 根据转场动画来重新计算得到的
- (NSArray *)insertVideos
{
    NSMutableArray *segments = [NSMutableArray array];
    //奇数插入Track0
    // 偶数插入Track1
    CMTime xTimeOffset = kCMTimeZero;
    CMTime lastmixDuration = kCMTimeZero;
    for(int ii = 0; ii < self.timelineAsset.videos.count; ii ++)
    {
        BOSHVideoTrack *vTrack = self.timelineAsset.videos[ii];
        CMTime duration = vTrack.media.timeRange.duration;
      
        int loopCursor = ii%2;
        XLog(@"__duration: %f",CMTimeGetSeconds(self.mixComposition.duration));
        //多轨道需要设置instruction
        XLog(@"插入 %f --%f",CMTimeGetSeconds(vTrack.timeRange.start),CMTimeGetSeconds(vTrack.timeRange.duration));
        [self.videoTracks[loopCursor] insertTimeRange:vTrack.timeRange ofTrack:vTrack.media.videoTrack atTime:xTimeOffset error:nil];
        
        //原始视频中音频部分
        if(vTrack.media.audioTrack)
        {
            [self.audioTracks[loopCursor] insertTimeRange:vTrack.timeRange ofTrack:vTrack.media.audioTrack atTime:xTimeOffset error:nil];
        }
        
        vTrack.timeRange =  CMTimeRangeMake(xTimeOffset, vTrack.timeRange.duration);//设置ranges
        
        BOSHPassthoughSegment *passSegment = [BOSHPassthoughSegment new];
        passSegment.videoTrack = self.videoTracks[loopCursor];
        passSegment.trackSize = vTrack.media.videoSize;
        passSegment.audioTrack = self.audioTracks[loopCursor];
        passSegment.targetSize = self.timelineAsset.size;
        passSegment.volume = BOSHGetSourceBalanceVolume(self.timelineAsset.volumeBalance);
        [segments addObject:passSegment];
        //检测是否有transiton(放在后面编写其实只是考虑了中间转场的情况，并没有考虑片头片尾动画)
        if( (ii + 1)< self.timelineAsset.videos.count && self.timelineAsset.transations.count)//2个及以上才有转场
        {
            BOSHTransitonInstruction *transtionIns = self.timelineAsset.transations[ii];
            if(transtionIns.transitionType != BOSHTransitionTypeNone)
            {
                CMTime transitionTime = CMTimeMake(duration.value *  (transtionIns.animationDuration/CMTimeGetSeconds(duration)),duration.timescale);
                xTimeOffset = CMTimeAdd(xTimeOffset, CMTimeSubtract(vTrack.media.timeRange.duration, transitionTime));

                BOSHTransitionSegment *transitionSegment = [BOSHTransitionSegment new];
                transitionSegment.timeRange = CMTimeRangeMake(xTimeOffset, transitionTime);
                transitionSegment.fromVideoTrack = self.videoTracks[loopCursor];
                transitionSegment.fromAudioTrack = self.audioTracks[loopCursor];
                transitionSegment.toAudioTrack = self.audioTracks[1 - loopCursor];
                transitionSegment.toVideoTrack = self.videoTracks[1 - loopCursor];
                
                BOSHVideoTrack *fromVideo = self.timelineAsset.videos[ii];
                BOSHVideoTrack *toVideo = self.timelineAsset.videos[ii+1];
                transitionSegment.fromTrackSize = fromVideo.media.videoSize;
                transitionSegment.toTrackSize = toVideo.media.videoSize;
                transitionSegment.targetSize = self.timelineAsset.size;
                transitionSegment.volume = BOSHGetSourceBalanceVolume(self.timelineAsset.volumeBalance);
                transitionSegment.transitionType = transtionIns.transitionType;
                [segments addObject:transitionSegment];
            }
            else
            {
                xTimeOffset = CMTimeAdd(xTimeOffset, vTrack.media.timeRange.duration);
            }
        }
        else
        {
             xTimeOffset = CMTimeAdd(xTimeOffset, vTrack.media.timeRange.duration);
        }
        passSegment.timeRange = CMTimeRangeMake(lastmixDuration, CMTimeSubtract(xTimeOffset,lastmixDuration));//这个计算需要注意起点减去transition
        lastmixDuration = self.mixComposition.duration;
    }
    
    return [NSArray arrayWithArray:segments];
}

- (void)buildVideoLayer
{
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width,  self.videoComposition.renderSize.height);
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width,  self.videoComposition.renderSize.height);
    [parentLayer addSublayer:videoLayer];
    for(BOSHOverlayTrack *overlay in self.timelineAsset.overlays)
    {
//直接覆盖的方式
//        if(overlay.overlay.type == BOSHOverlayTypeBorder)//处理边框问题
//        {
//            videoLayer.frame = CGRectMake(10, 10, self.videoComposition.renderSize.width - 20,  self.videoComposition.renderSize.height - 20);
//            [parentLayer insertSublayer:overlay.overlayer below:videoLayer];
//        }
//        else
//        {
//            [parentLayer addSublayer:overlay.overlayer];
//        }
        

        [parentLayer addSublayer:overlay.overlayer];
    }
    self.videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

- (CALayer *)overlayer
{
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width,  self.videoComposition.renderSize.height);
    for(BOSHOverlayTrack *overlay in self.timelineAsset.overlays)
    {
        [parentLayer addSublayer:overlay.overlayer];
    }
    return parentLayer;
}


//音量平衡控制
//- (AVAudioMix *)buildAudioMix
//{
//    NSMutableArray *params = [NSMutableArray array];
//
////   AVMutableAudioMixInputParameters *parameters0 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:kSourceAudioTrack];
////   [parameters0 setVolume:MIN(self.timelineAsset.volumeBalance,0.5)*2 atTime:kCMTimeZero];
////   [params addObject:parameters0];
////
////    AVMutableAudioMixInputParameters *parameters1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:kDubAudioTrack];
////    [parameters1 setVolume:(1- MAX(self.timelineAsset.volumeBalance,0.5))*2  atTime:kCMTimeZero];
////    [params addObject:parameters1];
//
//    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
//    audioMix.inputParameters = params;
//    return audioMix;
//}

//生成playItem
- (AVPlayerItem *)playItem
{
    self.videoComposition.animationTool = nil;// 播放器不支持这种Overlay，需要应用CoreAnimation UIKit 处理
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithAsset:self.mixComposition];
    playItem.videoComposition = [self.videoComposition copy];
    playItem.audioMix = self.audioMix;
    return playItem;
}

- (CMTime)duration
{
    return self.mixComposition.duration;
}

//导出质量可配
- (AVAssetExportSession*)assetExportSessionWithPreset:(NSString*)presetName
{
     [self buildVideoLayer];
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[self.mixComposition copy] presetName:presetName];
    exportSession.videoComposition = [self.videoComposition copy];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.audioMix = self.audioMix;
    return exportSession;
}

//默认导出
- (AVAssetExportSession*)assetExportSession
{
    return [self assetExportSessionWithPreset:AVAssetExportPresetMediumQuality];
}
@end
