//
//  BOSHAudioTrack.m
//  BOSHVideo
//
//  Created by yang on 2017/11/9.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHAudioTrack.h"

@implementation BOSHAudioTrack

+ (id)modelWithMediaItem:(BOSHMediaItem *)media
{
    return [[self alloc] initWithMediaItem:media];
}


- (instancetype)initWithMediaItem:(BOSHMediaItem *)media
{
    self = [super init];
    if(self)
    {
        self.media = media;
    }
    return self;
}

+ (BOSHAudioTrack *)audioTrackWithTimeRange:(CMTimeRange)range  ofURL:(NSURL *)URL atTime:(CMTime)startTime
{
    if(!URL) return nil;
    BOSHAudioItem *audioItem = [[BOSHAudioItem alloc] initWithURL:URL];
    BOSHAudioTrack *audio = [BOSHAudioTrack modelWithMediaItem:audioItem];
    [audioItem prepareMediaAsynchronouslyForKeys:@[BOTHAVAssetTracksKey,BOTHAVAssetDurationKey] completionHandler:^(BOOL isYES) {
    }];
    audio.timeRange = CMTimeRangeGetIntersection(audioItem.timeRange,range);
    audio.startTime = startTime;
    
    return audio;
}

+ (BOSHAudioTrack *)audioTrackOfURL:(NSURL *)URL atTime:(CMTime)startTime
{
    if(!URL) return nil;
    BOSHAudioItem *audioItem = [[BOSHAudioItem alloc] initWithURL:URL];
    BOSHAudioTrack *audio = [BOSHAudioTrack modelWithMediaItem:audioItem];
    [audioItem prepareMediaAsynchronouslyForKeys:@[BOTHAVAssetTracksKey,BOTHAVAssetDurationKey] completionHandler:^(BOOL isYES) {
    }];
    audio.timeRange = audioItem.timeRange;
    audio.startTime = startTime;
    
    return audio;
}

@end
