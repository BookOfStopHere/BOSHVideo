//
//  BOSHFile.h
//  BOSHVideo
//
//  Created by yang on 2017/11/28.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOSHUtils.h"
#ifdef __cplusplus
#if __cplusplus
extern "C"{
#endif
#endif /* __cplusplus */
    
    
   NSString *libraryPath();
    NSString *tempPath();
    NSString *documentPath();
    NSString *homePath();
    NSString *videoCachePath();
    NSString *m4aFileNameForRecord();
    NSURL *autoExportPath();
    BOOL removeFile(NSString *filePath);
    
//    BOOL writeGIFToCache()
#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */
