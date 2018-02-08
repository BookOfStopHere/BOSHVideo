//
//  BOSHUtils.h
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef __cplusplus
#if __cplusplus
extern "C"{
#endif
#endif /* __cplusplus */
    
static inline NSString *toBOSHEncode(NSString *str)
{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
    
static inline NSString *toSafeString(id object)
{
    if(object == nil || object == Nil || object == NULL || object == kCFNull) return @"";
    
    if([object isKindOfClass:NSObject.class])
    {
        if([object isKindOfClass:NSNumber.class])
        {
            if([object isKindOfClass:[NSNumber class]])
            {
                const char * pObjCType = [((NSNumber*)object) objCType];
                if (strcmp(pObjCType, @encode(int))  == 0)
                {
                   return [NSString stringWithFormat:@"%d",[object intValue]];
                }
                if (strcmp(pObjCType, @encode(float)) == 0)
                {
                    return [NSString stringWithFormat:@"%f",[object floatValue]];
                }
                if (strcmp(pObjCType, @encode(double))  == 0)
                {
                     return [NSString stringWithFormat:@"%f",[object doubleValue]];
                }
                if (strcmp(pObjCType, @encode(BOOL)) == 0)
                {
                    return [NSString stringWithFormat:@"%i",[object boolValue]];
                }
                if(strcmp(pObjCType, @encode(CGRect)) == 0)
                {
                    return [NSString stringWithFormat:@"%f,%f,%f,%f",[object CGRectValue].origin.x,[object CGRectValue].origin.y,[object CGRectValue].size.width,[object CGRectValue].size.height];
                }
                if(strcmp(pObjCType, @encode(CGPoint)) == 0)
                {
                    return [NSString stringWithFormat:@"%f,%f",[object CGPointValue].x,[object CGPointValue].y];
                }
                if(strcmp(pObjCType, @encode(CGSize)) == 0)
                {
                    return [NSString stringWithFormat:@"%f,%f",[object CGSizeValue].width,[object CGSizeValue].height];
                }
            }
        }
        else if([object isKindOfClass:NSString.class])
        {
            NSString *str = object;
            if([str isEqualToString:@"null"] || [str isEqualToString:@"Null"] ||  [str isEqualToString:@"NULL"] ||  [str isEqualToString:@"NSNull"] )
            {
                return @"";
            }
        }
        else if([object isKindOfClass:NSNull.class])
        {
            return @"";
        }
    }
    return [NSString stringWithFormat:@"%@",object];
}
#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

@interface BOSHUtils : NSObject

+ (NSString *)currentTimeYMDHMS;
+ (void)convertMS:(double)time toHour:(long *)h min:(long*)min sec:(long *)sec ms:(long *)ms;
//把视频写入相册
+ (void)writeVideoToPhotosAlbum:(NSURL *)URL completionHandler:(void(^)(NSURL *assetURL, NSError *error))completion;

@end
