//
//  BOTHCropCommand.h
//  BOSHVideo
//
//  Created by yang on 2017/10/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>
#import "BOTHCommand.h"
/**
 * 用户手动编辑，之后考虑自动剪辑，比如=依据用户感兴趣的点
 * 通过机器学习自动剪辑 加文字描述
 */

@interface BOTHCropCommand : BOTHCommand

@property (nonatomic, assign) CMTimeRange range;
@property  (nonatomic, assign) CGRect cropRect;

@end
