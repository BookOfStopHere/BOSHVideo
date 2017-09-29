//
//  BOTHPlayer.m
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHPlayer.h"
#import "BOTHPlayerItem.h"
#import <AVFoundation/AVFoundation.h>


@interface BOTHPlayer ()
{
    AVPlayer *_player;
}

@end


@implementation BOTHPlayer


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
