//
//  BOSHFileRequest.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHFileRequest.h"

@implementation BOSHFileRequest

- (NSURLRequest *)request
{
    NSMutableURLRequest *multiRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    return multiRequest;
}

@end
