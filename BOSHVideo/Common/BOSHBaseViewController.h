//
//  BOSHBaseViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOSHNavigationBar.h"
#import "UIViewController+BOSHAlert.h"
@interface BOSHBaseViewController : UIViewController
@property (nonatomic, strong) BOSHNavigationBar *headerBar;
@property (nonatomic, assign) BOOL headerBarHidden;


- (instancetype)initWithFrame:(CGRect)frame;

- (void)addApplicationObserver;
- (void)removeApplicationObserver;
- (void)applicationWillResignActive:(NSNotification *)notice;
- (void)applicationDidEnterBackground:(NSNotification *)notice;
- (void)applicationWillEnterForeground:(NSNotification *)notice;
- (void)applicationDidBecomeActive:(NSNotification *)notice;


- (void)addBOSHChildViewController:(UIViewController *)childController;

- (void)dismissSelf;
@end
