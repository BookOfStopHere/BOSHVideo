//
//  BOSHFomatFactory.m
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHFomatFactory.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "BOSDefines.h"

@implementation BOSHFomatFactory

+ (void)async_convertMOV:(NSURL *)movPath  toMP4:(NSString *)mp4Path inQueue:(dispatch_queue_t)queue completitionHandler:(void(^)(NSError *error, BOOL isSuccessed))handler
{
    if(movPath == nil || mp4Path == nil)
    {
        handler([NSError errorWithDomain:CustomErrorDomain code:BOTHErrorPath userInfo:BOTHERROR("输入参数错误")],NO);
        return;
    }
    
    if(queue == nil)
    {
        [self convertMOV:movPath toMP4:mp4Path completitionHandler:^(NSError *error, BOOL isSuccessed) {
            handler(error,isSuccessed);
        }];
    }
    else
    {
        dispatch_async(queue, ^{
            [self convertMOV:movPath toMP4:mp4Path completitionHandler:^(NSError *error, BOOL isSuccessed) {
                handler(error,isSuccessed);
            }];
        });
    }
}


+ (void)convertMOV:(NSURL *)movPath  toMP4:(NSString *)mp4Path completitionHandler:(void(^)(NSError *error, BOOL isSuccessed))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movPath options:nil];//compressed using H.264 and the audio will be compressed using AAC.
    NSArray *compatiblePresets=[AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
    {
        
        NSDateFormatter *formater=[[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        NSString *resultPath=[NSTemporaryDirectory() stringByAppendingFormat:@"/convert-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        AVAssetExportSession *exportSession=[[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL=[NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;//AVMediaFormat.h
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"AVAssetExportSessionStatusCancelled");
                    break;
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    BOOL success=[[NSFileManager defaultManager] moveItemAtPath:resultPath toPath:mp4Path error:nil];
                    if(success)
                    {
                        NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:mp4Path error:nil];
                        NSLog(@"%@",files);
                        NSLog(@"success");
                        handler(nil,YES);
                    }
                    else
                    {
                         handler([NSError errorWithDomain:CustomErrorDomain code:BOTHExportFileFailed userInfo:BOTHERROR("mov 转 mp4 失败")],NO);
                    }
                    break;
                }
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed");
                   handler([NSError errorWithDomain:CustomErrorDomain code:BOTHExportFileFailed userInfo:BOTHERROR("mov 转 mp4 失败")],NO);
                    break;
            }
        }];
    }

}
@end
