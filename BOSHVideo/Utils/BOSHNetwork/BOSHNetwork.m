//
//  BOSHNetwork.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHNetwork.h"
#import <AFNetworking/AFNetworking.h>

@interface BOSHNetwork()
@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, strong) BOSHRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation BOSHNetwork

- (AFURLSessionManager *)manager
{
    if(!_manager)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        _manager = manager;
    }
    return _manager;
}

- (void)sendRequest:(BOSHRequest *)request responseHandler:(void(^)(id response, NSError * err))responseHandler
{
    self.request = request;
    [self  cancel];
    NSURLSessionDataTask *downloadTask =
    [self.manager dataTaskWithRequest:_request.request completionHandler:^(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",responseObject);
            if(responseHandler) responseHandler(responseObject,error);
        });
    }];
    [downloadTask resume];
    self.task = downloadTask;
}

- (void)sendFileRequest:(BOSHRequest *)request responseHandler:(void(^)(id response, NSError * err))responseHandler
{
    self.request = request;
    [self  cancel];
    [self.manager  setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    NSURLSessionDataTask *downloadTask =
    [self.manager dataTaskWithRequest:_request.request completionHandler:^(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",responseObject);
            if(responseHandler) responseHandler(responseObject,error);
        });
    }];
    [downloadTask resume];
    self.task = downloadTask;
}

//self.responseSerializer = [AFJSONResponseSerializer serializer];

- (void)cancel
{
    [self.task cancel];
}

@end
