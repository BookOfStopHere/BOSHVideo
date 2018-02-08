//
//  BOTHAVSession.h
//  BOSHVideo
//
//  Created by yang on 2017/10/18.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOTHAVSession : NSObject

+ (void)setVolume:(float)vol;

+ (float)getVolume;

+ (BOOL)setAudioActive:(BOOL)isActive;

@end
