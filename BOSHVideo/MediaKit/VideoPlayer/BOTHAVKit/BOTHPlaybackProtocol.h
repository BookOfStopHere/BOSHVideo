//
//  BOTHPlaybackProtocol.h
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayerItem;
@class AVPlayer;
@class AVSynchronizedLayer;

@protocol BOTHPlaybackProtocol <NSObject>

@required

- (void)playWithItem:(AVPlayerItem *)playItem;

- (void)play;

- (void)pause;

- (void)seekTo:(double)time completion:(void(^)(BOOL finished))handler;

- (void)stop;

- (BOOL)isPlaying;

- (void)setMute:(BOOL)isMute;

- (double)currentTime;

- (double)duration;

@optional
- (void)setPlayProgressHandler:(void(^)(float progress))progressHandler;
- (void)setLoadProgressHandler:(void(^)(float progress))progressHandler;

- (BOOL)isPlayEnd;

- (AVPlayer *)player;

- (void)setVideoGravity:(NSString *)videoGravity;


- (AVSynchronizedLayer *)getAVSyncLayer;
@end



