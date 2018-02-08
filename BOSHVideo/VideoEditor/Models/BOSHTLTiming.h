//
//  BOSHTLTiming.h
//  BOSHVideo
//
//  Created by yang on 2017/12/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#ifndef BOSHTLTiming_h
#define BOSHTLTiming_h

#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>


@protocol BOSHTLTiming

@optional
/**
 * 起／止始时间
 */
@property (nonatomic) CMTime startTime;
@property (nonatomic) CMTime endTime;

/**
 * 在时间轴上的区间位置
 */
@property (nonatomic) CMTimeRange timeRange;

@end

#endif /* BOSHTLTiming_h */
