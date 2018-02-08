//
//  BOSHAudioRecorder.h
//  BOSHVideo
//
//  Created by yang on 2017/11/17.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/OpenAL.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BOSHAudioRecorder : AVAudioRecorder

- (instancetype)initWithURL:(NSURL *)url settings:(NSDictionary<NSString *,id> *)settings error:(NSError **)outError;


+ (NSDictionary *)defaultSettings;

@end
