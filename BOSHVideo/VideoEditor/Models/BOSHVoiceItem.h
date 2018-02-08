//
//  BOSHVoiceItem.h
//  BOSHVideo
//
//  Created by yang on 2017/11/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTrack.h"
#import "BOTHRange.h"
@interface BOSHVoiceItem : BOSHTrack

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign)CMTime duration;


@property (nonatomic, assign) double start_time;
@property (nonatomic, assign) double end_time;
 // 在进度条上的位置
@property (nonatomic, assign) CGFloat startPoint;
@property (nonatomic, assign) CGFloat endPoint;

@property (nonatomic, strong) BOTHRange *timeRangeused;

@end
