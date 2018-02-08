//
//  BOTHMacro.h
//  BOSHVideo
//
//  Created by yang on 2017/10/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#ifndef BOTHMacro_h
#define BOTHMacro_h
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#define weakify( ... ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{}@finally {} __weak __typeof__(__VA_ARGS__) weak##__VA_ARGS__ = __VA_ARGS__; \
_Pragma("clang diagnostic pop")

#define strongify(...) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \
try{}@finally {} __strong __typeof__(__VA_ARGS__) strong##__VA_ARGS__ = __VA_ARGS__; \
_Pragma("clang diagnostic pop")

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define UIColorFromRGB10(r,g,b)  [UIColor colorWithRed:((float)(r))/255.0 green:((float)(g))/255.0 blue:((float)(b))/255.0 alpha:1.0]
#define UIColorFromRGBA10(r,g,b,a)  [UIColor colorWithRed:((float)(r))/255.0 green:((float)(g))/255.0 blue:((float)(b))/255.0 alpha:a]

#define override \
compatibility_alias _NSObject NSObject;




#define BOSHIsPhoneX (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) == 812)
#define BOSHStatusBarHeight (BOSHIsPhoneX ? 44 : 20)
#define BOSHBottomOffset  ((BOSHIsPhoneX) ? 40 : 0)
#define BOSHHeaderBarH 44
//LOG
#if DEBUG
#   define XLog(fmt, ...) do{NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}while(0)
#else
#   define XLog(fmt, ...)
#endif

//大于ios8以上
#define BOSHIOS8Later                ([[[UIDevice currentDevice] systemVersion] localizedStandardCompare:@"8.0"] != NSOrderedAscending)
//iOS9及其以上
#define BOSHIOS9Later                 ([[[UIDevice currentDevice] systemVersion] localizedStandardCompare:@"9.0"] != NSOrderedAscending)
//iOS10及其以上
#define BOSHIOS10Later                 ([[[UIDevice currentDevice] systemVersion] localizedStandardCompare:@"10.0"] != NSOrderedAscending)
//iOS11及其以上
#define BOSHIOS11Later                 ([[[UIDevice currentDevice] systemVersion] localizedStandardCompare:@"11.0"] != NSOrderedAscending)


//屏幕宽
#define BOSHScreenW (!BOSHIOS8Later?[UIScreen mainScreen].bounds.size.width:[[[UIScreen mainScreen] fixedCoordinateSpace] bounds].size.width)
//屏幕高
#define BOSHScreenH (!BOSHIOS8Later?[UIScreen mainScreen].bounds.size.height:[[[UIScreen mainScreen] fixedCoordinateSpace] bounds].size.height)


#define kNAVIGATIONH 64
#define kDeviceBottom 0
//放缩
static inline CGFloat BOTHScale()
{
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (width < 375) {
        return 1.0;
    } else if (width < 414) {
        return 1.1;
    } else {
        return 1.2;
    }
}

//计算视频的展示的长度， 每秒116／2
static const float BOSH_PER_SECOND_WIDTH = (54);

static inline Float64 BOSHGetWidthWithTimeRange(CMTimeRange timeRange)
{
    return CMTimeGetSeconds(timeRange.duration)*BOSH_PER_SECOND_WIDTH;
}

static NSString *const AssetCollectionName = @"BOSHVideo";

//缩略图每秒一张
#define kPerThumbnailTime (1)
//缩略图高度固定
#define kThumbnailH 
#define kThumbnailW

#define RandomColor [UIColor colorWithRed:abs(rand())%255/255.0 green:abs(rand())%255/255.0 blue:abs(rand())%255/255.0 alpha:1]

#endif /* BOTHMacro_h */

