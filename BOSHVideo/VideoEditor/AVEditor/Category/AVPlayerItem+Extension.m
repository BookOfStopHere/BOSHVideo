//
//  AVPlayerItem+Extension.m
//  BOSHVideo
//
//  Created by yang on 2017/10/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "AVPlayerItem+Extension.h"

@implementation AVPlayerItem (Extension)

- (AVAudioMix *)buildAudioMixWithLevel:(CGFloat)level
{
    NSMutableArray *params = [NSMutableArray array];
    for (AVPlayerItemTrack *track in self.tracks) {
        if ([track.assetTrack.mediaType isEqualToString:AVMediaTypeAudio]) {
            AVMutableAudioMixInputParameters *parameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track.assetTrack];
            [parameters setVolume:level atTime:kCMTimeZero];
            [params addObject:parameters];
        }
    }
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = params;
    return audioMix;
}

- (void)setMixVolume:(float)volume
{
    self.audioMix = [self buildAudioMixWithLevel:volume];
}

@end
