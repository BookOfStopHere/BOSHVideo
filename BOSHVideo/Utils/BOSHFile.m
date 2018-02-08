//
//  BOSHFile.m
//  BOSHVideo
//
//  Created by yang on 2017/11/28.
//  Copyright © 2017年 yang. All rights reserved.
//
#define kVideoCacheDir @"bothvideo"
#import "BOSHFile.h"

NSString *libraryPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *tempPath()
{
    return NSTemporaryDirectory();
}

NSString *documentPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *homePath()
{
    return NSHomeDirectory();
}

NSString *videoCachePath()
{
    NSString *vCachePath = [libraryPath() stringByAppendingPathComponent:kVideoCacheDir];
    if(![[NSFileManager defaultManager] fileExistsAtPath:vCachePath])
    {
        //不存在则创建
        BOOL isYes =  [[NSFileManager defaultManager] createDirectoryAtPath:vCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!isYes)
        {
            [[NSFileManager defaultManager] removeItemAtPath:vCachePath error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:vCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return vCachePath;
}

NSString *m4aFileNameForRecord()
{
    NSString *m4aName = [NSString stringWithFormat:@"%@.m4a",[BOSHUtils currentTimeYMDHMS]];
    return m4aName;
}

NSURL *autoExportPath()
{
    NSString *mp4 = [NSString stringWithFormat:@"%@.mp4",[BOSHUtils currentTimeYMDHMS]];
    NSString *filePath = [videoCachePath() stringByAppendingPathComponent:mp4];
   removeFile(filePath);
    return filePath.length ?  [NSURL fileURLWithPath:filePath] : nil;
}

BOOL removeFile(NSString *filePath)
{
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return NO;
}
