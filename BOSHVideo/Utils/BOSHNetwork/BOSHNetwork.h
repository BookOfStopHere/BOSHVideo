//
//  BOSHNetwork.h
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOSHRequest.h"

@interface BOSHNetwork : NSObject
{
    @package
   BOSHRequest *_request;
}

- (void)sendRequest:(BOSHRequest *)request responseHandler:(void(^)(id response, NSError * err))responseHandler;

- (void)sendFileRequest:(BOSHRequest *)request responseHandler:(void(^)(id response, NSError * err))responseHandler;

- (void)cancel;

@end
