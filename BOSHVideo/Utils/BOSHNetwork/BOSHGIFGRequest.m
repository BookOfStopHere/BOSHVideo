//
//  BOSHGIFGRequest.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHGIFGRequest.h"
#import "BOSHUtils.h"
//https://api.giphy.com/v1/gifs/search?api_key=y8yRT21TjV6uoPt4o5sGOX8jGAn7Gq5b&q=meinv&limit=25&offset=0&rating=G&lang=zh-CN

@implementation BOSHGIFGRequest

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.limit = 30;
        self.offset = 0;
    }
    return self;
}

- (NSURLRequest *)request
{
    NSMutableURLRequest *multiRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"https://api.giphy.com/v1/gifs/search" parameters:self.parameters error:nil];
    return multiRequest;
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self.publicParameters];
    [mutableDic setObject:toBOSHEncode(self.q) forKey:@"q"];
    [mutableDic setObject:@(self.limit) forKey:@"limit"];
    [mutableDic setObject:@(self.offset) forKey:@"offset"];
    return mutableDic;
}

- (NSDictionary *)publicParameters
{
    NSDictionary *dic = [super publicParameters];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic] ;
     [mutableDic addEntriesFromDictionary:@{@"rating":@"G",@"lang":@"zh-CN"}] ;
    return mutableDic;
}
@end
