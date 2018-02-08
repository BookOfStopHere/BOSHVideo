//
//  BOSHVolumeCommand.h
//  BOSHVideo
//
//  Created by yang on 2017/10/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "BOTHCommand.h"

@interface BOSHVolumeCommand : BOTHCommand

@property (nonatomic) CMTimeRange timeRange;
@property (nonatomic) CGFloat startVolume;
@property (nonatomic) CGFloat endVolume;

@end
