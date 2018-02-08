//
//  BOSHPermissionRequest.h
//  BOSHVideo
//
//  Created by yang on 2017/11/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BOSHAuthorizationStatus) {
    BOSHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
    BOSHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
    // The user cannot change this application’s status, possibly due to active restrictions
    //   such as parental controls being in place.
    BOSHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
    BOSHAuthorizationStatusAuthorized         // User has authorized this application to access photos data.
};


typedef NS_ENUM(NSInteger, BOSHAuthorizationRequestType) {
    BOSHAuthorizationRequestTypePhotoLibrary = 0, // User has not yet made a choice with regards to this application
};


@interface BOSHPermissionRequest : NSObject

+ (BOSHAuthorizationStatus)requestPermission:(BOSHAuthorizationRequestType)type;

@end


@interface BOSHPermissionRequest (Settings)
+ (void)gotoApplicationSetting;
@end
