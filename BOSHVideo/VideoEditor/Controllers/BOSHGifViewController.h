//
//  BOSHGifViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOSHGIFModel.h"
@interface BOSHGifViewController : BOSHBaseViewController
@property (nonatomic, copy) void(^selectedHandler)(BOSHGIFModel *model);

@end
