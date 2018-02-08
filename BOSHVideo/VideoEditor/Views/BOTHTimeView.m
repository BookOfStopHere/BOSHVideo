//
//  BOTHTimeView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/3.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHTimeView.h"
#import "BOTHMacro.h"
#import "BOSHUtils.h"

@implementation BOTHTimeView

- (void)setCurTime:(double)curTime andDuration:(double)duration
{
    self.attributedText =  [self covertPlayTimeWithCurTime:curTime duration:duration];
}

- (void)setTime:(double)time
{
    [self setTime:time addPrefixString:@"截取时长:"];
}

- (void)setTime:(double)time addPrefixString:(NSString *)prefix;
{
    prefix = prefix == nil ? @"" : prefix;
    NSMutableAttributedString *attrSting = [[NSMutableAttributedString alloc] init];
    
    long  s,h,m,ms;
    [BOSHUtils convertMS:time toHour:&h min:&m sec:&s ms:&ms];
    NSString *curTimeString = @"";
    if(time/1000 < 60*60)
    {
        curTimeString = [NSString stringWithFormat:@"%@%.2ld:%.2ld", prefix,m,s];
    }
    else
    {
        curTimeString = [NSString stringWithFormat:@"%@%.2ld:%.2ld:%.2ld", prefix,h,m,s];
    }
    
    NSAttributedString *curAttr = [[NSAttributedString alloc] initWithString:curTimeString attributes:@{
                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:9],
                                                                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x666666),
                                                                                                        }];
    [attrSting appendAttributedString:curAttr];

     self.attributedText = attrSting;
}

- (NSAttributedString *)covertPlayTimeWithCurTime:(double)curTime duration:(double)duration
{
    
    NSMutableAttributedString *attrSting = [[NSMutableAttributedString alloc] init];
    
    NSString *curTimeString = @"";
    NSString *durationString = @"";
    long  s,h,m,ms;
     long  ds,dh,dm,dms;
    [BOSHUtils convertMS:curTime toHour:&h min:&m sec:&s ms:&ms];
    [BOSHUtils convertMS:duration toHour:&dh min:&dm sec:&ds ms:&dms];
    if(duration/1000 < 60*60)
    {
        curTimeString = [NSString stringWithFormat:@"%.2ld:%.2ld.%.1ld",m,s,ms/100];
        durationString = [NSString stringWithFormat:@"/%.2ld:%.2ld.%.1ld",dm,ds,dms/100];
    }
    else
    {
        curTimeString = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld.%.1ld",h,m,s,ms/100];
        durationString = [NSString stringWithFormat:@"/%.2ld:%.2ld:%.2ld.%.1ld",dh,dm,ds,dms/100];
    }
    
    NSAttributedString *curAttr = [[NSAttributedString alloc] initWithString:curTimeString attributes:@{
                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x666666),
                                                                                                        }];
    NSAttributedString *durAttr = [[NSAttributedString alloc] initWithString:durationString attributes:@{
                                                                                                         NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                                                         NSForegroundColorAttributeName:UIColorFromRGB(0x666666),
                                                                                                         }];

    [attrSting appendAttributedString:curAttr];
    [attrSting appendAttributedString:durAttr];
    return attrSting;
}

- (void)showTimeInHighPrecision:(double)time
{
    NSMutableAttributedString *attrSting = [[NSMutableAttributedString alloc] init];
    
    long  s,h,m,ms;
    [BOSHUtils convertMS:time toHour:&h min:&m sec:&s ms:&ms];
    NSString *curTimeString = @"";
    if(time/1000 < 60*60)
    {
        curTimeString = [NSString stringWithFormat:@"%.2ld:%.2ld.%.2ld",m,s,ms/10];
    }
    else
    {
        curTimeString = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld.%.2ld",h,m,s,ms/10];
    }
    
    NSAttributedString *curAttr = [[NSAttributedString alloc] initWithString:curTimeString attributes:@{
                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:9],
                                                                                                        NSForegroundColorAttributeName:UIColorFromRGB(0xffffff),
                                                                                                        }];
    [attrSting appendAttributedString:curAttr];
    
    self.attributedText = attrSting;
}

@end
