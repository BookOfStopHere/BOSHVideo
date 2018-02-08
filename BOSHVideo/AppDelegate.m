//
//  AppDelegate.m
//  BOSHVideo
//
//  Created by yang on 2017/9/22.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "AppDelegate.h"
 #import <Bugly/Bugly.h>
#import "BOTHLaunchEngine.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BOSHHomeViewController.h"
#import "MMDrawerController.h"
#import "BOTHMineViewController.h"
static float origin_sys_volume;
static float current_app_vol;
#define MYRELEASE 1
@interface AppDelegate ()

@end

const NSString *EA_string = @"mL1LZWWkBtDs3RlhuI3uzyK70tQ9yIBIokXrIOQdUe7zfFkzUyCVYcwHPswqrLuzUldv2G2WIbQ8BP4xXEidzwCA42E9o8DWxa778bi2IxRtJIvlPvCUKVAF8uK94v2KSIDoVvdDtZYI1H9kYwr1g4SahSeY53HhJgM6NS1ybadeqGgYFeAZjloiN6YfjN2tajLaAARe";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    origin_sys_volume =  [[AVAudioSession sharedInstance] outputVolume];
    [BOTHLaunchEngine launchingWithOptions:launchOptions];

//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#if MYRELEASE
    
    BOTHMineViewController * mineVC = [[BOTHMineViewController alloc] init];
    UIViewController * center = [[UIViewController alloc] init];
    BOSHHomeViewController *homeVC  = BOSHHomeViewController.new;
    
    MMDrawerController *rootVC = [[MMDrawerController alloc]
                        initWithCenterViewController:homeVC
                        leftDrawerViewController:mineVC
                        rightDrawerViewController:nil];
    
    rootVC.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    rootVC.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //5、设置左右两边抽屉显示的多少
    rootVC.maximumLeftDrawerWidth = 200.0;
    rootVC.maximumRightDrawerWidth = 200.0;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    nav.navigationBarHidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
#endif
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
     current_app_vol =  [[AVAudioSession sharedInstance] outputVolume];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [self.class setVolumeLevel:origin_sys_volume];
//      [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     origin_sys_volume = [[AVAudioSession sharedInstance] outputVolume];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    MPVolumeView *volumeView =[MPVolumeView new];
//    [self.window addSubview:volumeView];
//    [self.class setVolumeLevel:current_app_vol];
    
//    [volumeView removeFromSuperview];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
