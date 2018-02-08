//
//  BOSHShareManager.h
//  BOSHVideo
//
//  Created by yang on 2017/12/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BOSHShareManager : NSObject
/**
 * 分享视频到微信 暂时没有问题
 */
+ (UIViewController *)shareVideo:(NSURL *)videoURL completion:(void(^)(NSError *erro))completionHandler;

/**
 * 分享GIF 还是有问题  只能用微信等原始的API
 */
//+ (void)shareGIF:(NSURL *)gifURL completion:(void(^)(NSError *erro))completionHandler;


/**
 * 分享图片
 */
+ (UIViewController *)shareImage:(UIImage *)image completion:(void(^)(NSError *erro))completionHandler;

@end
