//
//  BOSHShareManager.m
//  BOSHVideo
//
//  Created by yang on 2017/12/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHShareManager.h"
#import "BOSHDefines.h"

@interface BOSHShareManager ()
@property (nonatomic, strong) UIActivityViewController *activity;
@end

@implementation BOSHShareManager

+ (UIViewController *)shareVideo:(NSURL *)videoURL completion:(void(^)(NSError *erro))completionHandler
{
    //主要是分享到微信
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[videoURL] applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypePostToVimeo];
    
    activity.excludedActivityTypes = excludeActivities;
    
    if(@available(iOS 8, *))
    {
        [activity setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if(completionHandler) completionHandler(activityError);
        }];
    }
    else
    {
        [activity setCompletionHandler:^(UIActivityType  _Nullable activityType, BOOL completed) {
            NSError *activityError = nil;
            if(!completed)
            {
                activityError = [NSError errorWithDomain:CustomErrorDomain code:BOTHShareFailed userInfo:BOTHERROR("分享失败")];
            }
            if(completionHandler) completionHandler(activityError);
        }];
    }
    
    return activity;
}

//+ (void)shareGIF:(NSURL *)gifURL completion:(void(^)(NSError *erro))completionHandler
//{
//    NSData *animatedGif = [NSData dataWithContentsOfURL:gifURL];
//    NSArray *sharingItems = [NSArray arrayWithObjects: animatedGif, nil];
//    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
//    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
//                                   UIActivityTypePrint,
//                                   UIActivityTypePostToVimeo];
//    
//    activity.excludedActivityTypes = excludeActivities;
//    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:activity animated:YES completion:^{
//        
//    }];
//    
//}

+ (UIViewController *)shareImage:(UIImage *)image completion:(void(^)(NSError *erro))completionHandler
{
    if(image == nil ) return nil;
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypePostToVimeo];
    
    activity.excludedActivityTypes = excludeActivities;
//    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:activity animated:YES completion:^{
//
//    }];
    
    if(@available(iOS 8, *))
    {
        [activity setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
             if(completionHandler) completionHandler(activityError);
        }];
    }
    else
    {
        [activity setCompletionHandler:^(UIActivityType  _Nullable activityType, BOOL completed) {
            NSError *activityError = nil;
            if(!completed)
            {
                activityError = [NSError errorWithDomain:CustomErrorDomain code:BOTHShareFailed userInfo:BOTHERROR("分享失败")];
            }
             if(completionHandler) completionHandler(activityError);
        }];
    }
    
    return activity;
}

@end
