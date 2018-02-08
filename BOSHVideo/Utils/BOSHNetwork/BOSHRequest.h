//
//  BOSHRequest.h
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface BOSHRequest : NSObject

//需要子类覆盖
@property (nonatomic, readonly) NSURLRequest *request;

/**
 * 公共参数(定制化请覆盖)
 */
@property (nonatomic, strong) NSDictionary *publicParameters;

@end
