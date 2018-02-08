//
//  BOSHBaseViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOTHMacro.h"
#import "UIView+Geometry.h"

@interface BOSHBaseViewController ()
@property (nonatomic) CGRect frame;
@end

@implementation BOSHBaseViewController


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if(self)
    {
        self.frame = frame;
    }
    return self;
}

- (void)loadView
{
    if(CGRectIsEmpty(self.frame))
    {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BOSHScreenW, BOSHScreenH)];
    }
    else
    {
        self.view = [[UIView alloc] initWithFrame:self.frame];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    self.headerBar = [[BOSHNavigationBar alloc] initWithFrame:CGRectMake(0, 0, BOSHScreenW, BOSHHeaderBarH + BOSHStatusBarHeight)];
    [self.view addSubview:self.headerBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBOSHChildViewController:(UIViewController *)childController
{
    [self.view addSubview:childController.view];
    [self addChildViewController:childController];
}

- (void)addApplicationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)removeApplicationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationWillEnterForegroundNotification object:nil];
}


- (void)applicationWillResignActive:(NSNotification *)notice
{
}

- (void)applicationDidEnterBackground:(NSNotification *)notice
{
}


- (void)applicationWillEnterForeground:(NSNotification *)notice
{
}

- (void)applicationDidBecomeActive:(NSNotification *)notice
{
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dismissSelf
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(self.parentViewController)
    {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    else
    {
        [self.view removeFromSuperview];
    }
}

@end
