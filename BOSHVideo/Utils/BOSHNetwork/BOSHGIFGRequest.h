//
//  BOSHGIFGRequest.h
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHRequest.h"

@interface BOSHGIFGRequest : BOSHRequest
//https://api.giphy.com/v1/gifs/search?api_key=y8yRT21TjV6uoPt4o5sGOX8jGAn7Gq5b&q=meinv&limit=25&offset=0&rating=G&lang=zh-CN
@property (nonatomic, copy) NSString *q;
@property (nonatomic) int limit;
@property (nonatomic) int offset;


@end
