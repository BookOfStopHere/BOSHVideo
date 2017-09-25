//
//  BOSHUtils.m
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHUtils.h"

@implementation BOSHUtils


+ (NSString *)libraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)homePath
{
    return NSHomeDirectory();
}

@end
