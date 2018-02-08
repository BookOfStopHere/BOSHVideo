//
//  BOSHAudioRecorder.m
//  BOSHVideo
//
//  Created by yang on 2017/11/17.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHAudioRecorder.h"

@implementation BOSHAudioRecorder

+ (NSDictionary *)defaultSettings
{
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                    nil];
    return recordSettings;
}

- (instancetype)initWithURL:(NSURL *)url settings:(NSDictionary<NSString *,id> *)settings error:(NSError  **)outError
{
    self = [super initWithURL:url settings:settings error:outError];
    if(self)
    {
        [self setAudioSession];
        [self setMeteringEnabled:YES];
    }
    return self;
}

- (void)setAudioSession
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}


@end
