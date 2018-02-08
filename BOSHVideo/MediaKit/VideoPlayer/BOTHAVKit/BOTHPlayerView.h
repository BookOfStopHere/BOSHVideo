//
//  BOTHPlayerView.h
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImageView.h"
#import "BOTHPlaybackProtocol.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(int, BOTHPlayerState) {
    BOTHPlayerStateNone,
    BOTHPlayerStateOnStart,
    BOTHPlayerStateOnFinished,
    BOTHPlayerStateOnLoading,
    BOTHPlayerStateOnError,
    
    BOTHPlayerStateOnSeeking,
    BOTHPlayerStateOnSeekSuccess,
    
    BOTHPlayerStateOnPause,
    BOTHPlayerStateOnPlaying,
};

#if DD
@interface BOTHPlayerView : GPUImageView <BOTHPlaybackProtocol>
#else
@interface BOTHPlayerView : UIView <BOTHPlaybackProtocol>
#endif
@property (nonatomic, copy) void(^progressHandler)(void);

@property (nonatomic, assign) float progress;
@property (nonatomic, assign) BOTHPlayerState playerState;

@property (nonatomic, copy) void(^playerStateHandler)(BOTHPlayerState state);
@property (nonatomic, copy) void(^playActionHandler)(BOOL paused);
@property (nonatomic, strong) NSError *error;

@end
