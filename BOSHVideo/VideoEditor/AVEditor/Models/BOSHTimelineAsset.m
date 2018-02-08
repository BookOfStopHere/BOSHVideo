//
//  BOSHTimelineAsset.m
//  BOSHVideo
//
//  Created by yang on 2017/11/13.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTimelineAsset.h"

//@implementation BOSHTimelineSetting @end

@implementation BOSHTimelineAsset

+ (instancetype)defaultTimelineAsset
{
    BOSHTimelineAsset *asset = [BOSHTimelineAsset new];
    asset.size = CGSizeMake(640, 360);
    asset.fps = 30;
    asset.volumeBalance = 0.5;
    return asset;
}

@end
