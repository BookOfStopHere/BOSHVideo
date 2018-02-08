//
//  BOSHPassthoughSegment.m
//  BOSHVideo
//
//  Created by yang on 2017/11/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHPassthoughSegment.h"
#import "BOSHTimelineHelper.h"
#import "BOTHMacro.h"
@implementation BOSHPassthoughSegment


- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.preferTransform = CGAffineTransformIdentity;
    }
    return self;
}

- (NSArray<AVAudioMixInputParameters *> *)audioMixInputParameters
{
    AVMutableAudioMixInputParameters *parameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.audioTrack];
    [parameters setVolume:self.volume atTime:self.timeRange.start];
    return parameters ? @[parameters] : nil;
}

- (AVMutableVideoCompositionInstruction *)videoCompositionInstruction
{
    AVMutableVideoCompositionInstruction *instruction = BOSHVideoSingleInstruction(self.videoTrack,self.timeRange);
    AVMutableVideoCompositionLayerInstruction *layer = (AVMutableVideoCompositionLayerInstruction *)instruction.layerInstructions[0];
    
    XLog(@"Passthrough <%f  %f>",CMTimeGetSeconds(self.timeRange.start),CMTimeGetSeconds(self.timeRange.duration));
    //还需要检测当前视频的转向（这个放在添加时处理）
    CGAffineTransform baseTranform = BOSHSizeTransfrom(self.trackSize, self.targetSize, 0);
//        [layer setOpacityRampFromStartOpacity:1 toEndOpacity:1 timeRange:self.timeRange];
    if(!CGAffineTransformEqualToTransform(self.preferTransform, CGAffineTransformIdentity))
    {
        baseTranform = CGAffineTransformConcat(baseTranform, self.preferTransform);
    }
    [layer setTransform:baseTranform atTime:self.timeRange.start];
    return instruction;
}

@end
