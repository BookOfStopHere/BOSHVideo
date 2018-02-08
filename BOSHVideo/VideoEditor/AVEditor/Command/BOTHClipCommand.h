//
//  BOTHClipCommand.h
//  BOSHVideo
//
//  Created by yang on 2017/10/26.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "BOTHCommand.h"

typedef NS_ENUM(NSInteger, BOTHVideoOritation) {
    BOTHVideoOritationUp,
    BOTHVideoOritationRight,
    BOTHVideoOritationLeft,
    BOTHVideoOritationDown
};

@interface BOTHClipCommand : BOTHCommand

//在时间线上的位置
@property (nonatomic, assign) CMTime startTimeInTimeline;
//截取片段
@property (nonatomic, assign) CMTimeRange clipRange;
///////////////////////////////////////////////////////////////////////////////
//以下 OnlyForVideo
///////////////////////////////////////////////////////////////////////////////
//旋转
@property (nonatomic, assign) BOTHVideoOritation oritaion;
@property (nonatomic, assign) CGAffineTransform transform;
//目标
@property (nonatomic, assign) CGSize targetSize;
//是否填充
@property (nonatomic, assign) BOOL isFill;

@end
