//
//  BOSHVideoTrack.m
//  BOSHVideo
//
//  Created by yang on 2017/11/9.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHVideoTrack.h"
#import "BOTHMacro.h"

@implementation BOSHVideoTrack

+ (id)modelWithMediaItem:(BOSHMediaItem *)media
{
    return [[self alloc] initWithTimelineItem:media];
}

- (id)initWithTimelineItem:(BOSHMediaItem *)media
{
    self = [super init];
    if (self)
    {
        _media = media;
        self.itemType = BOSHTimelineTypeVideo;
        CMTimeRange maxTimeRange = CMTimeRangeMake(kCMTimeZero, _media.timeRange.duration);
        self.maxWidthInTimeline = BOSHGetWidthWithTimeRange(maxTimeRange);
        self.timeRange = _media.timeRange;
    }
    return self;
}

- (CGFloat)widthInTimeline
{
    if (_widthInTimeline == 0.0f)
    {
        _widthInTimeline = BOSHGetWidthWithTimeRange(_media.timeRange);
    }
    return _widthInTimeline;
}

- (CGFloat) preferedWidthInTimeline
{
    return BOSH_PER_SECOND_WIDTH;
}


+ (id)videoTrackWithMediaItem:(BOSHMediaItem *)media  atTime:(CMTime)startTime
{
    BOSHVideoTrack *track = [self modelWithMediaItem:media];
    track.startTime = startTime;
    track.timeRange = CMTimeRangeMake(startTime, media.timeRange.duration);
    return track;
}

/**
 * 本地文件加载
 */
+ (BOSHVideoTrack *)videoTrackWithTimeRange:(CMTimeRange)range  ofURL:(NSURL *)URL atTime:(CMTime)startTime
{
    if(!URL) return nil;
    BOSHVideoItem *videoItem = [BOSHVideoItem videoItemWithURL:URL];
    BOSHVideoTrack *video = [BOSHVideoTrack modelWithMediaItem:videoItem];
    [videoItem prepareMediaAsynchronouslyForKeys:@[BOTHAVAssetTracksKey,BOTHAVAssetDurationKey] completionHandler:^(BOOL isYES) {
    }];
    video.timeRange = CMTimeRangeGetIntersection(videoItem.timeRange,range);
    video.startTime = startTime;
    
    return video;
}

/**
 * 加载本地文件
 */
+ (BOSHVideoTrack *)videoTrackOfURL:(NSURL *)URL atTime:(CMTime)startTime
{
    if(!URL) return nil;
    BOSHVideoItem *videoItem = [BOSHVideoItem videoItemWithURL:URL];
    BOSHVideoTrack *video = [BOSHVideoTrack modelWithMediaItem:videoItem];
    [videoItem prepareMediaAsynchronouslyForKeys:@[BOTHAVAssetTracksKey,BOTHAVAssetDurationKey] completionHandler:^(BOOL isYES) {
    }];
    video.timeRange = videoItem.timeRange;
    video.startTime = startTime;
    
    return video;
}

@end
