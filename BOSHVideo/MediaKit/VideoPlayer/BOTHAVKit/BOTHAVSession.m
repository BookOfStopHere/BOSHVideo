//
//  BOTHAVSession.m
//  BOSHVideo
//
//  Created by yang on 2017/10/18.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHAVSession.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation BOTHAVSession

+ (void)setVolume:(float)vol
{
    MPVolumeView *volumeView =[MPVolumeView new];
    UISlider *volumeViewSlider;
    for(UIView *view in[volumeView subviews])
    {
        if([[[view class] description] isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider =(UISlider*)view;
            break;
        }
    }
    [volumeViewSlider setValue:vol animated:NO];
}

+ (float)getVolume
{
    return [[AVAudioSession sharedInstance] outputVolume];
}

+ (BOOL)setAudioActive:(BOOL)isActive
{
    [[AVAudioSession sharedInstance] setActive:isActive error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionMixWithOthers error:nil];
    return YES;
}

@end
