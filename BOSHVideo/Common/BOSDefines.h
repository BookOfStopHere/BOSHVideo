//
//  BOSDefines.h
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

//错误相关
#define CustomErrorDomain @"com.both.video"
typedef enum {
    BOTHDefultFailed = -1000,
    BOTHENVError,//输入参数
    BOTHErrorPath,//路径错误
    BOTHExportFileFailed,
}BOTHErrorFailed;

#define BOTHERROR(A) [NSDictionary dictionaryWithObject:@A forKey:NSLocalizedDescriptionKey]

//define log
#ifdef DEBUG
#define BLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define BLog(...)
#endif


#define BOSHIMG(A) [UIImage imageNamed:@A]

//事件类型
typedef enum{
    BOSH_ACTION_JOIN_LONG_PICTURE = 0,//拼长图
    BOSH_ACTION_CREATE_GIF,
    BOSH_ACTION_EDIT_VIDEO,
    BOSH_ACTION_HELP,
    BOSH_ACTION_LAUNCH_CAMARA,
};
