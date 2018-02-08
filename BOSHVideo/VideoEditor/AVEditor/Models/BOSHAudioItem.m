//
//  BOSHAudioItem.m
//  BOSHVideo
//
//  Created by yang on 2017/10/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHAudioItem.h"

@implementation BOSHAudioItem

+ (BOSHAudioItem *)videoItemWithURL:(NSURL *)URL
{
    return [[self alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super initWithURL:url];
    if(self)
    {
    }
    return self;
}

- (AVAssetTrack *)anyTrack
{
    NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
    return  [audioTracks firstObject];
}

- (void)preparedWithHandler:(BOTHMediaCompletionHandler)handler
{
    handler ? handler(YES) : YES;
}

@end
