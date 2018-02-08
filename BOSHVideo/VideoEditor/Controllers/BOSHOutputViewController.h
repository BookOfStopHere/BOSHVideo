//
//  BOSHOutputViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/12/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOSHDefines.h"
@interface BOSHOutputViewController : BOSHBaseViewController

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic) BOSHFileType fileType;
@property (nonatomic) CGSize size;
@end
