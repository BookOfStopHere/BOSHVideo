//
//  BOTHPlayerItem.m
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHPlayerItem.h"

@implementation BOTHPlayerItem

+ (BOTHPlayerItem *)defaultItem
{
    BOTHPlayerItem *item = BOTHPlayerItem.new;
    item.endTime = -1;
    item.speedRate = 1;
    return item;
}

@end
