//
//  BOSHRequest.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHRequest.h"
#import "BOSHAPI.h"


@implementation BOSHRequest

- (NSURLRequest *)request
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (NSDictionary *)publicParameters
{
    return @{@"api_key":GIPHYAPIKey};
}

@end
