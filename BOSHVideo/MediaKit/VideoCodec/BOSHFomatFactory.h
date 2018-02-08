//
//  BOSHFomatFactory.h
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOSHFomatFactory : NSObject

/**
 * 格式转换
 * 将mov 转为mp4
 */
+ (void)async_convertMOV:(NSURL *)movPath  toMP4:(NSString *)mp4Path inQueue:(dispatch_queue_t)queue completitionHandler:(void(^)(NSError *error, BOOL isSuccessed))handler;

@end
