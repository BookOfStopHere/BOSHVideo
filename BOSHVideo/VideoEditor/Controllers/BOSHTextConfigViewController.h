//
//  BOSHTextConfigViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"

@interface BOSHTextConfigViewController : BOSHBaseViewController
//初始化字体参数
//颜色
//字体
//大小
@property (nonatomic, copy) void(^completitionHandler)(void);
@end
