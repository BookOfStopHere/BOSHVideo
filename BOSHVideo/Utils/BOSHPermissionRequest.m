//
//  BOSHPermissionRequest.m
//  BOSHVideo
//
//  Created by yang on 2017/11/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHPermissionRequest.h"
#import "BOTHMacro.h"
#import "BOSHDefines.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>

static inline BOSHAuthorizationStatus toBOSHStatus(PHAuthorizationStatus phStatus)
{
    switch (phStatus) {
        case PHAuthorizationStatusNotDetermined:
            return BOSHAuthorizationStatusNotDetermined;
        case PHAuthorizationStatusRestricted:
            return BOSHAuthorizationStatusRestricted;
        case PHAuthorizationStatusDenied:
            return BOSHAuthorizationStatusDenied;
        case PHAuthorizationStatusAuthorized:
            return BOSHAuthorizationStatusAuthorized;
        default:
            break;
    }
    
    return BOSHAuthorizationStatusNotDetermined;
}

@implementation BOSHPermissionRequest

+ (BOSHAuthorizationStatus)requestPermission:(BOSHAuthorizationRequestType)type
{
    BOSHAuthorizationStatus status = BOSHAuthorizationStatusNotDetermined;
    if(type == BOSHAuthorizationRequestTypePhotoLibrary)
    {
        status = toBOSHStatus([PHPhotoLibrary authorizationStatus]);
    }
    return status;
}

@end


@implementation BOSHPermissionRequest (Settings)
+ (void)gotoApplicationSetting
{
   if(@available(iOS 8, *))
   {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
   }
}
@end
