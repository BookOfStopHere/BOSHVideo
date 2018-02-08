//
//  BOSHGIFModel.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHGIFModel.h"

@implementation BOSHGIFModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"url"  : @"images.downsized.url",
             @"height"  : @"images.downsized.height",
             @"width"  : @"images.downsized.width",
             @"size": @"images.downsized.size",
             @"coverImage":@"images.480w_still.url",
             @"coverH":@"images.480w_still.height",
             @"coverW": @"images.480w_still.width",
             };
}
@end
