//
//  BOTHLaunchEngine.m
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHLaunchEngine.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

@implementation BOTHLaunchEngine


+ (BOOL) launchingWithOptions:(NSDictionary *)launchOptions
{
/**初始化ShareSDK应用
 @param activePlatforms
 使用的分享平台集合
 @param importHandler (onImport)
 导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
 @param configurationHandler (onConfiguration)
 配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
 */
    [ShareSDK registerActivePlatforms:@[
                                    @(SSDKPlatformTypeSinaWeibo),
                                    @(SSDKPlatformTypeMail),
                                    @(SSDKPlatformTypeSMS),
                                    @(SSDKPlatformTypeCopy),
                                    @(SSDKPlatformTypeWechat),
                                    @(SSDKPlatformTypeQQ)
                                    ]
    onImport:^(SSDKPlatformType platformType)
    {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
    }
    onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
    {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;

                default:
                   break;
            }
    }];
    
    return YES;
}

@end
