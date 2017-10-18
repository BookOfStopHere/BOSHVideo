//
//  BOSHUtils.m
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHUtils.h"

@implementation BOSHUtils


+ (NSString *)libraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)homePath
{
    return NSHomeDirectory();
}


+ (NSString *)currentTimeYMDHMS
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:[NSDate date]];
    
    int year = (int)[comps year];
    int month =  (int)[comps month];
    int day = (int) [comps day];
    int hour =  (int)[comps hour];
    int min =  (int)[comps minute];
    int sec =  (int)[comps second];
    
    return [NSString stringWithFormat:@"%d-%d-%d-%d-%d-%d",year,month,day,hour,min,sec];
}
@end
