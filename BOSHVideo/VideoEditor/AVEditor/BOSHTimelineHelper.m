//
//  BOSHTimelineHelper.m
//  BOSHVideo
//
//  Created by yang on 2017/11/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTimelineHelper.h"

@implementation BOSHTimelineHelper

- (AVPlayerItem *)test
{
    AVMutableComposition  * mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compsitionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                  preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVMutableCompositionTrack *compositionVideoTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compsitionAudioTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError *error = nil;
    
    
    
    BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:self.timelineAsset.videos[0].media.timeRange
                                                            ofTrack:self.timelineAsset.videos[0].media.videoTrack
                                                             atTime:kCMTimeZero
                                                              error:&error];
    
    
    BOOL adudioInsertResult = [compsitionAudioTrack insertTimeRange:self.timelineAsset.videos[0].media.timeRange
                                                            ofTrack:self.timelineAsset.videos[0].media.audioTrack
                                                             atTime:kCMTimeZero
                                                              error:&error];
    
    
    double videoScaleFactor = 2;//超过（<0.5）两倍就没法播放了，或者慢超过2倍（> 2）也没有声音蛋疼
    CMTime videoDuration = self.timelineAsset.videos[0].media.timeRange.duration;
    
    
    //    [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                               toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
    
    //    [compsitionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                              toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
    
    
    ///
    
    [compositionVideoTrackB insertTimeRange:self.timelineAsset.videos[1].media.timeRange
                                    ofTrack:self.timelineAsset.videos[1].media.videoTrack
                                     atTime:CMTimeSubtract(videoDuration,CMTimeMake(1, 1))
                                      error:&error];
    
    
    [compsitionAudioTrackB insertTimeRange:self.timelineAsset.videos[1].media.timeRange
                                   ofTrack:self.timelineAsset.videos[1].media.audioTrack
                                    atTime:CMTimeSubtract(videoDuration,CMTimeMake(1, 1))
                                     error:&error];
    
    AVMutableVideoComposition *videoComp =  [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
    
    //        movieAsset1.
    //        AVMutableVideoCompositionInstruction *instruction =  [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    
    //        AVMutableVideoCompositionLayerInstruction *layer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    //        MIN(movieAsset1.naturalSize)
    
#define MMAX(A,B) (A > B ? A : B)
    videoComp.renderSize = CGSizeMake(MMAX(compositionVideoTrackB.naturalSize.width,compositionVideoTrack.naturalSize.width), MMAX(compositionVideoTrackB.naturalSize.height,compositionVideoTrack.naturalSize.height));
    
    videoComp.renderSize = CGSizeMake(640,360);
    videoComp.renderScale = 1;
    videoComp.frameDuration = CMTimeMake(1, 30);
    
    NSArray<id <AVVideoCompositionInstruction>> * instructions = videoComp.instructions;
    for(AVMutableVideoCompositionInstruction *ins in instructions)
    {
        NSInteger c = ins.layerInstructions.count;
        NSLog(@"%d",c);
        ins.enablePostProcessing = NO;
        if(ins.layerInstructions.count == 2)
        {
            AVMutableVideoCompositionLayerInstruction *fromLayer = ins.layerInstructions[0];
            AVMutableVideoCompositionLayerInstruction *toLayer =  ins.layerInstructions[1];
            
            
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:ins.timeRange];
            [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:ins.timeRange];
            
            
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                           toEndTransform:CGAffineTransformRotate(CGAffineTransformMakeScale(0,0), M_PI)
                                                timeRange:ins.timeRange];
            
            
            // Set a transform ramp on toLayer from all the way right of the screen to identity.
            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeScale(1, 1)
                                         toEndTransform:CGAffineTransformIdentity
                                              timeRange:ins.timeRange];
        }
    }
    AVPlayerItem * playItem = [AVPlayerItem playerItemWithAsset:mixComposition];
    playItem.videoComposition = videoComp;
    
    return playItem;
}



- (AVPlayerItem *)testDIY
{
    AVMutableComposition  * mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compsitionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                  preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVMutableCompositionTrack *compositionVideoTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compsitionAudioTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError *error = nil;
    
    CMTime comStartTime = CMTimeMake(1, 1);
    
    BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:self.timelineAsset.videos[0].media.timeRange
                                                            ofTrack:self.timelineAsset.videos[0].media.videoTrack
                                                             atTime:comStartTime
                                                              error:&error];
    
    
    BOOL adudioInsertResult = [compsitionAudioTrack insertTimeRange:self.timelineAsset.videos[0].media.timeRange
                                                            ofTrack:self.timelineAsset.videos[0].media.audioTrack
                                                             atTime:comStartTime
                                                              error:&error];
    
    
    double videoScaleFactor = 2;//超过（<0.5）两倍就没法播放了，或者慢超过2倍（> 2）也没有声音蛋疼
    CMTime videoDuration = self.timelineAsset.videos[0].media.timeRange.duration;
    
    
    //    [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                               toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
    
    //    [compsitionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                              toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
    
    
    ///
    comStartTime = CMTimeAdd(comStartTime, CMTimeSubtract(videoDuration,CMTimeMake(1, 1)));
    
    [compositionVideoTrackB insertTimeRange:self.timelineAsset.videos[1].media.timeRange
                                    ofTrack:self.timelineAsset.videos[1].media.videoTrack
                                     atTime:comStartTime
                                      error:&error];
    
    
    [compsitionAudioTrackB insertTimeRange:self.timelineAsset.videos[1].media.timeRange
                                   ofTrack:self.timelineAsset.videos[1].media.audioTrack
                                    atTime:comStartTime
                                     error:&error];
    
    AVMutableVideoComposition *videoComp =  [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
    
    //        movieAsset1.
    //        AVMutableVideoCompositionInstruction *instruction =  [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    
    //        AVMutableVideoCompositionLayerInstruction *layer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    //        MIN(movieAsset1.naturalSize)
    
#define MMAX(A,B) (A > B ? A : B)
    videoComp.renderSize = CGSizeMake(MMAX(compositionVideoTrackB.naturalSize.width,compositionVideoTrack.naturalSize.width), MMAX(compositionVideoTrackB.naturalSize.height,compositionVideoTrack.naturalSize.height));
    
    videoComp.renderSize = self.timelineAsset.size;
    videoComp.renderScale = 1;
    videoComp.frameDuration = CMTimeMake(1, 30);
    
    
    float scale = self.timelineAsset.size.height/self.timelineAsset.videos[0].media.videoSize.height;//MAX(self.timelineAsset.size.width/self.timelineAsset.videos[1].media.videoSize.width,self.timelineAsset.size.height/self.timelineAsset.videos[1].media.videoSize.height);
    CGAffineTransform Scale = CGAffineTransformMakeScale(scale,scale);
    CGAffineTransform Move = CGAffineTransformMakeTranslation(-(self.timelineAsset.videos[0].media.videoSize.width*scale - self.timelineAsset.size.width)/2,-(self.timelineAsset.videos[0].media.videoSize.height*scale - self.timelineAsset.size.height)/2);
    
    CGAffineTransform transfrom1 = CGAffineTransformConcat(Scale, Move);
    
    float scale2 = //self.timelineAsset.size.height/self.timelineAsset.videos[1].media.videoSize.height;//
    MAX(self.timelineAsset.size.width/self.timelineAsset.videos[1].media.videoSize.width,self.timelineAsset.size.height/self.timelineAsset.videos[1].media.videoSize.height);
    CGAffineTransform Scale2 = CGAffineTransformMakeScale(scale2,scale2);
    CGAffineTransform Move2 = CGAffineTransformMakeTranslation(-(self.timelineAsset.videos[1].media.videoSize.width*scale2 - self.timelineAsset.size.width)/2,-(self.timelineAsset.videos[1].media.videoSize.height*scale2 - self.timelineAsset.size.height)/2);
    CGAffineTransform transfrom2 = CGAffineTransformConcat(Scale2, Move2);
    
    
    AVMutableVideoCompositionInstruction * zeroPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    zeroPass.timeRange = CMTimeRangeMake(kCMTimeZero,CMTimeMake(1, 1));
    AVMutableVideoCompositionLayerInstruction *zeroPasslayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    [zeroPasslayerInstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange:zeroPass.timeRange];
    zeroPass.layerInstructions = @[zeroPasslayerInstruction];
    
    
    CMTime curTime = CMTimeMake(1, 1);
    //pass through 1
    AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    firstPass.timeRange = CMTimeRangeMake(curTime, CMTimeSubtract(videoDuration,CMTimeMake(1, 1)));
    AVMutableVideoCompositionLayerInstruction *firstPasslayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    [firstPasslayerInstruction setTransform:transfrom1 atTime:kCMTimeZero];
    firstPass.layerInstructions = @[firstPasslayerInstruction];
    
    curTime = CMTimeAdd(curTime, CMTimeSubtract(videoDuration,CMTimeMake(1, 1)));
    
    //transition
    AVMutableVideoCompositionInstruction * transitionPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    transitionPass.timeRange = CMTimeRangeMake(curTime, CMTimeMake(1, 1));
    
    AVMutableVideoCompositionLayerInstruction *fromLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    
    AVMutableVideoCompositionLayerInstruction *toLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrackB];
    [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionPass.timeRange ];
    [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:transitionPass.timeRange ];
    
    
    [fromLayer setTransformRampFromStartTransform:transfrom1
                                   toEndTransform:CGAffineTransformRotate(CGAffineTransformMakeScale(0,0), M_PI)
                                        timeRange:transitionPass.timeRange ];
    
    
    // Set a transform ramp on toLayer from all the way right of the screen to identity.
    [toLayer setTransformRampFromStartTransform:transfrom2
                                 toEndTransform:transfrom2
                                      timeRange:transitionPass.timeRange ];
    
    
    transitionPass.layerInstructions = @[fromLayer,toLayer];
    
    curTime = CMTimeAdd(curTime, CMTimeMake(1, 1));
    //pass through 2
    
    
    ///  此处可以封装一个方法  便于复用  同时防止人为因素导致的错误编码 嗷嗷啊 啊啊啊
    
    AVMutableVideoCompositionInstruction * secondPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    ////拷贝代码时将secondPass  搞成了  firstPass 的   时间上搞的不对啊啊啊 啊啊啊
    secondPass.timeRange = CMTimeRangeMake(curTime, CMTimeSubtract(self.timelineAsset.videos[1].media.timeRange.duration,CMTimeMake(1, 1)));
    AVMutableVideoCompositionLayerInstruction *secondPasslayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrackB];
    
    [secondPasslayerInstruction setTransform:transfrom2 atTime:curTime];
    secondPass.layerInstructions = @[secondPasslayerInstruction];
    
    videoComp.instructions = @[zeroPass,firstPass,transitionPass,secondPass];
    
    AVPlayerItem * playItem = [AVPlayerItem playerItemWithAsset:mixComposition];
    playItem.videoComposition = videoComp;
    
    return playItem;
}



@end
