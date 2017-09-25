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


- (void)makeVideo:(NSURL *)videoURL toGif:(NSString *)gifPath inQueue:(dispatch_queue_t)queue completion:(void(^)(NSError *erro))completion
{
    dispatch_queue_t cQueue = queue;
    if(queue == nil)  queue = dispatch_get_main_queue();
    
    
//    dispatch_async(queue, ^{
//        
//        //先按时间生成缩略图，计算图片的长度 然后再逐个加入，最终生成GIF
//        
//        
//        NSMutableData* imgData = [NSMutableData data];
//        CGImageDestinationRef destination =  CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imgData, kUTTypeGIF, imgs.count, NULL);
//        
//        NSString* path = [[[DataCenter sharedDataCenter] getLibraryPath] stringByAppendingPathComponent:@"test.gif"];
//        CFURLRef url = CFURLCreateWithFileSystemPath (
//                                                      kCFAllocatorDefault,
//                                                      (CFStringRef)path,
//                                                      kCFURLPOSIXPathStyle,
//                                                      false);
//        destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imgs.count, NULL);
//        NSDictionary *frameProperties = [NSDictionary
//                                         dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:duration], (NSString *)kCGImagePropertyGIFDelayTime, nil]
//                                         forKey:(NSString *)kCGImagePropertyGIFDictionary];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
//        [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
//        [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
//        [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
//        [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
//        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
//                                                                  forKey:(NSString *)kCGImagePropertyGIFDictionary];
//        for (UIImage* dImg in imgs)
//        {
//            UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), FALSE, 1);
//            UIView* gifBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//            gifBgView.backgroundColor = [UIColor clearColor];
//            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//            [imgView setBackgroundColor:[UIColor clearColor]];
//            [imgView setContentMode:UIViewContentModeScaleAspectFill];
//            [imgView setImage:self.image];
//            imgView.center = gifBgView.center;
//            [gifBgView addSubview:imgView];
//            
//            UIImageView* dImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//            dImgView.center = imgView.center;
//            [dImgView setBackgroundColor:[UIColor clearColor]];
//            [dImgView setImage:dImg];
//            [dImgView setContentMode:UIViewContentModeScaleAspectFill];
//            [gifBgView addSubview:dImgView];
//            
//            [[gifBgView layer] renderInContext:UIGraphicsGetCurrentContext()];
//            
//            UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            CGImageDestinationAddImage(destination, img.CGImage, (__bridge CFDictionaryRef)frameProperties);
//        }
//        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
//        CGImageDestinationFinalize(destination);
//        CFRelease(destination);
//        imgData = [NSData dataWithContentsOfFile:[[[DataCenter sharedDataCenter] getLibraryPath] stringByAppendingPathComponent:@"test.gif"]];
//        return imgData;
//
//    });
}

@end
