//
//  BOSHGIFContext.m
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHGIFContext.h"
#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "BOSHVideoThumbCtx.h"

@implementation BOSHGIFContext

+ (BOSHGIFContext *)currentContext
{
    static BOSHGIFContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = BOSHGIFContext.new;
    });
    return context;
}

- (void)setCodec:(BOSHGIFCodec *)codec
{
    _gifCodec = codec;
}


- (void)makeVideo:(NSURL *)videoURL toGif:(NSString *)gifPath inQueue:(dispatch_queue_t)queue completion:(void(^)(NSError *erro, NSData *gif))completion
{
    if(queue == nil)  queue = dispatch_get_main_queue();

    dispatch_async(queue, ^{
        
        //先按时间生成缩略图，计算图片的长度 然后再逐个加入，最终生成GIF
        __block NSMutableArray *images = [NSMutableArray array];

        BOSHVideoThumbCtx *thumbCtx  = [BOSHVideoThumbCtx thumbCtxWithVideo:videoURL];
        [thumbCtx thumbImagesWithFPS:30 atTime:100 duration:0.5 completionHandler:^(UIImage *image){
            [images  addObject:image];
        }];
        
//        NSMutableData* imgData = [NSMutableData data];
//        CGImageDestinationRef destination =  CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imgData, kUTTypeGIF, 30, NULL);

        CFURLRef url = CFURLCreateWithFileSystemPath (
                                                      kCFAllocatorDefault,
                                                      (CFStringRef)gifPath,
                                                      kCFURLPOSIXPathStyle,
                                                      false);
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, 15, NULL);
        
        NSDictionary *frameProperties = [NSDictionary
                                         dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0/30], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                         forKey:(NSString *)kCGImagePropertyGIFDictionary];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
        [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
        [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
        [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
                                                                  forKey:(NSString *)kCGImagePropertyGIFDictionary];
        for (UIImage* dImg in images)
        {
            CGImageDestinationAddImage(destination, dImg.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        NSData *gif  = [NSData dataWithContentsOfFile:gifPath];
        
        if(completion)
        {
            if(gif)
            {
                completion(nil,gif);
            }
            else
            {
                completion([NSError errorWithDomain:@"com.bosh.video" code:-1000 userInfo:nil],gif);
            }
        }
    });
}

@end
