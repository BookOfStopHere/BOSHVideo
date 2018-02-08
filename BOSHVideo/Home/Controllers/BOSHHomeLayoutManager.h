//
//  BOSHHomeLayoutManager.h
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//事件类型
typedef enum BOSH_FUNCTION_ACTION{
    BOSH_ACTION_Settings,
    BOSH_ACTION_JOIN_Camera,
    BOSH_ACTION_JOIN_LONG_PICTURE,//拼长图
    BOSH_ACTION_CREATE_GIF,
    BOSH_ACTION_EDIT_VIDEO,
    BOSH_ACTION_HELP,
    BOSH_ACTION_LAUNCH_CAMARA,
}BOSH_FUNCTION_ACTION;


@interface BOSHHomeLayoutManager : NSObject

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, copy) void(^actionHandler)(BOSH_FUNCTION_ACTION actionTye);

- (instancetype)initWithTarget:(UIView *)target model:(NSArray <NSString *> *)stringSets;

@end
