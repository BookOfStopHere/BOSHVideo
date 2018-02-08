//
//  BOSHTransitionSegment.m
//  BOSHVideo
//
//  Created by yang on 2017/11/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTransitionSegment.h"
#import "BOSHTimelineHelper.h"
#import "BOTHMacro.h"

@implementation BOSHTransitionSegment

- (NSArray<AVAudioMixInputParameters *> *)audioMixInputParameters
{
    AVMutableAudioMixInputParameters *fromParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.fromAudioTrack];
    AVMutableAudioMixInputParameters *toParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.toAudioTrack];
    [fromParameters setVolumeRampFromStartVolume:self.volume toEndVolume:0 timeRange:_timeRange];
    [toParameters setVolumeRampFromStartVolume:0 toEndVolume:self.volume timeRange:_timeRange];
    
    return fromParameters && toParameters ? @[fromParameters,toParameters] : nil;
}

- (AVMutableVideoCompositionInstruction *)videoCompositionInstruction
{
    AVMutableVideoCompositionInstruction *instruction = BOSHVideoTwoInstructions(self.fromVideoTrack, self.toVideoTrack,self.timeRange);
    AVMutableVideoCompositionLayerInstruction *fromLayer = (AVMutableVideoCompositionLayerInstruction *)instruction.layerInstructions[0];
    AVMutableVideoCompositionLayerInstruction *toLayer = (AVMutableVideoCompositionLayerInstruction *)instruction.layerInstructions[1];
    XLog(@"Transiton <%f  %f>",CMTimeGetSeconds(self.timeRange.start),CMTimeGetSeconds(self.timeRange.duration));
    //还需要检测当前视频的转向（这个放在添加时处理）
    CGAffineTransform fromBaseTranform = BOSHSizeTransfrom(self.fromTrackSize, self.targetSize, 0);
    CGAffineTransform toBaseTranform = BOSHSizeTransfrom(self.toTrackSize, self.targetSize, 0);
    
    if(self.transitionType == BOSHTransitionTypePush)
    {
        //推拉
        CGAffineTransform fromPushOutTranform = CGAffineTransformMakeTranslation(-self.targetSize.width, 0);
        CGAffineTransform toPushInTranform = CGAffineTransformMakeTranslation(self.targetSize.width, 0);
   
        [fromLayer setTransformRampFromStartTransform:fromBaseTranform toEndTransform: CGAffineTransformConcat(fromBaseTranform, fromPushOutTranform) timeRange:self.timeRange];
        [toLayer setTransformRampFromStartTransform:CGAffineTransformConcat(toBaseTranform, toPushInTranform) toEndTransform:toBaseTranform  timeRange:self.timeRange];
    }
    else if(self.transitionType == BOSHTransitionFade)
    {
        //渐变
        [fromLayer setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange:self.timeRange];
        [toLayer setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange:self.timeRange];
        //调整尺寸
        [fromLayer setTransform:fromBaseTranform atTime:self.timeRange.start];
        [toLayer setTransform:toBaseTranform atTime:self.timeRange.start];
    }
    else if(self.transitionType == BOSHTransitionDissovle)
    {
        //注意这个变换：Scale变换 要写在Translation 之前！！！！！
        CGAffineTransform fromOutTranform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.0,0.),CGAffineTransformMakeTranslation(self.targetSize.width/2, self.targetSize.height/2));
        
        //基于中心点旋转不好操作!!!!!!!
//        CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI),CGAffineTransformMakeTranslation(self.targetSize.width/2, self.targetSize.height/2)) ;
        
//        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(M_PI);
//        CGAffineTransform fromOutTranform = CGAffineTransformTranslate(rotationTransform,self.targetSize.width/2, self.targetSize.height/2);
//        CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformMakeScale(0.01,0.01),CGAffineTransformMakeTranslation(self.targetSize.height/2, self.targetSize.width/2)),CGAffineTransformMakeRotation(M_PI)) ;
        [fromLayer setTransformRampFromStartTransform:fromBaseTranform toEndTransform:fromOutTranform timeRange:self.timeRange];
        [toLayer setTransform:toBaseTranform atTime:self.timeRange.start];
    }
    else if(self.transitionType == BOSHTransitionFlipFromRight)
    {
        CGAffineTransform toPushInTranform = CGAffineTransformMakeTranslation(self.targetSize.width, 0);
        [fromLayer setTransform:fromBaseTranform atTime:self.timeRange.start];
        [fromLayer setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange:self.timeRange];
        [toLayer setTransformRampFromStartTransform:CGAffineTransformConcat(toBaseTranform, toPushInTranform) toEndTransform:toBaseTranform  timeRange:self.timeRange];
    }
    else if(self.transitionType == BOSHTransitionCurtain)
    {
        CGAffineTransform fromScaleTranform = CGAffineTransformMakeScale(0.01, 1);
        [fromLayer setTransformRampFromStartTransform:fromBaseTranform toEndTransform: CGAffineTransformConcat(fromBaseTranform, fromScaleTranform) timeRange:self.timeRange];
        [fromLayer setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange:self.timeRange];
        [toLayer setTransform:toBaseTranform atTime:self.timeRange.start];
    }
    
    return instruction;
}



@end
