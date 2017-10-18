//
//  BOSHUtils.h
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOSHUtils : NSObject

+ (NSString *)libraryPath;
+ (NSString *)tempPath;
+ (NSString *)documentPath;
+ (NSString *)homePath;

+ (NSString *)currentTimeYMDHMS;
@end
