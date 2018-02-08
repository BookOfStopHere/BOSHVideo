//
//  BOTHRange.m
//  BOSHVideo
//
//  Created by yang on 2017/11/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHRange.h"

@implementation BOTHRange

+ (BOTHRange *)rangeWithStart:(double) start duration:(double)duration
{
   return [[self alloc] initWithStart:start duration:duration];
}


- (instancetype)initWithStart:(double) start duration:(double)duration
{
    self = [super init];
    if(self)
    {
        self.start = start;
        self.duration = duration;
    }
    return self;
}

- (double)end
{
    return self.duration + self.start;
}

- (BOOL)containRange:(BOTHRange *)range;
{
    BOOL isYES = [self isEqual:range];
    if(!isYES && range)
    {
        if(range.start >= self.start && self.end >= range.end)
        {
            isYES = YES;
        }
    }
    return isYES;
}

- (BOTHRange *)intersectionWithRange:(BOTHRange *)range
{
    if(range)
    {
        if(self.end <= range.start || self.start >= range.end)
        {
            return nil;
        }
        return [BOTHRange rangeWithStart:MAX(self.start,range.start) duration:MIN(self.end,range.end)];
    }
    return nil;
}


- (BOOL)isEqual:(id)object
{
    if(object && [object isKindOfClass:BOTHRange.class])
    {
      if(object == self) return YES;
        
       if(  ((BOTHRange*)object).start == self.start && ((BOTHRange*)object).duration == self.duration)
       {
           return YES;
       }
        
    }
    return NO;
}

@end
