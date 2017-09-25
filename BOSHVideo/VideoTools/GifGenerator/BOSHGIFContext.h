//
//  BOSHGIFContext.h
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOSHGIFCodec : NSObject

@property (nonatomic, assign) NSInteger fps;


@end

@interface BOSHGIFContext : NSObject

@property (nonatomic, readonly) BOSHGIFCodec *gifCodec;
/**
 * 获取默认的context
 */
+ (BOSHGIFContext *)currentContext;

/**
 * 设置编码参数
 */
- (void)setCodec:(BOSHGIFCodec *)codec;


/**
 * 将视频专程GIF，默认在主线程上执行
 */

- (void)makeVideo:(NSURL *)videoURL toGif:(NSString *)gifPath inQueue:(dispatch_queue_t)queue completion:(void(^)(NSError *erro))completion;

@end
