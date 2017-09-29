//
//  BOTHPlayerView.m
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "BOTHPlayer.h"

@interface BOTHPlayerView ()

@property (nonatomic, strong) BOTHPlayer *player;

@end

@implementation BOTHPlayerView

+ (Class)layerClass
{
    return AVPlayerLayer.class;
}

- (void)playWithItem:(BOTHPlayerItem *)playItem
{
    
}

- (void)play
{
    //
}

- (void)pause
{
    //
}

- (void)seekTo:(double)time completion:(void(^)(BOOL success, NSError *erro))handler
{
    //
}

- (void)stop
{
    
}


@end
