//
//  BOTHSpeedCommand.h
//  BOSHVideo
//
//  Created by yang on 2017/10/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHLayer.h"
#include <CoreMedia/CoreMedia.h>
#import "BOTHCommand.h"
//参考实例
/***********************************************************************************************************************************
AVURLAsset * movieAsset = [[AVURLAsset alloc] initWithURL:myMovieURL options:nil];

AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                               preferredTrackID:kCMPersistentTrackID_Invalid];
AVMutableCompositionTrack *compsitionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                              preferredTrackID:kCMPersistentTrackID_Invalid];
NSError *error = nil;

BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration)
                                                        ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                         atTime:kCMTimeZero
                                                          error:&error];


BOOL adudioInsertResult = [compsitionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration)
                                                        ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                         atTime:kCMTimeZero
                                                          error:&error];

if (!videoInsertResult || nil != error) {
    //handle error
    return;
}

if (!adudioInsertResult || nil != error) {
    //handle error
    return;
}

double videoScaleFactor = 0.1;
CMTime videoDuration = movieAsset.duration;


[compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
                           toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];

[compsitionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
                          toDuration:CMTimeMake(videoDuration.value, videoDuration.timescale)];
***********************************************************************************************************************************/

@interface BOTHSpeedCommand : BOTHCommand
@property (assign) CMTimeRange timeRange;
@property (assign) float speed; //(0.5 ~ 2)
@end
