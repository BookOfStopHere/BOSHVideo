//
//  BOTHTransitionCommand.h
//  BOSHVideo
//
//  Created by yang on 2017/10/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "BOTHCommand.h"

@interface BOTHTransitionCommand : BOTHCommand


@property (nonatomic) CMTimeRange timeRange;

@end
