//
//  BOTHPlaybackProtocol.h
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BOTHPlayerItem;

@protocol BOTHPlaybackProtocol <NSObject>

@required

- (void)playWithItem:(BOTHPlayerItem *)playItem;

- (void)play;

- (void)pause;

- (void)seekTo:(double)time completion:(void(^)(BOOL success, NSError *erro))handler;

- (void)stop;

@end



