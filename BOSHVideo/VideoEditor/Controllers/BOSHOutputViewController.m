//
//  BOSHOutputViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/12/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHOutputViewController.h"
#import "BOTHMacro.h"
#import "BOTHPlayerView.h"
#import "UIView+Geometry.h"
#import "BOSHPermissionRequest.h"
#import "BOSHShareManager.h"
#import "UIView+Toast.h"
#import "BOSHUtils.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BOSHOutputViewController ()
@property (nonatomic, strong) BOTHPlayerView *playerView;
@property (nonatomic, strong) NSURL *shareURL;
@end

@implementation BOSHOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden  = YES;
    self.view.backgroundColor = UIColorFromRGB(0x101010);
    // Do any additional setup after loading the view.
    self.size = CGSizeMake(480, 272);
    self.shareURL = [[NSBundle mainBundle] URLForResource:@"ss.mp4" withExtension:nil];
    [self prepare];
}

- (void)prepare
{
    @weakify(self);
    self.headerBar.leftItemHidden = NO;
    [self.headerBar setLeftActionHandler:^{
        [weakself dismissSelf];
    }];
    
    [self addActionButtons];
 
    CGFloat maxH =  (self.view.height - 358/2 - 60) - self.headerBar.bottom - 5 - 5;
    CGFloat maxW = self.view.width;
    
    CGFloat scale = MIN(maxW/self.size.width,maxH/self.size.height);
    
    self.playerView = [[BOTHPlayerView alloc] initWithFrame:CGRectMake((self.view.width - scale * self.size.width)/2, self.headerBar.bottom + 5 + (maxH  - scale * self.size.height)/2, scale * self.size.width, scale * self.size.height)];
    [self.view addSubview:self.playerView];
    
    [self.playerView setPlayActionHandler:^(BOOL paused) {
        
    }];
    
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:self.shareURL];
    
    [self.playerView playWithItem:playItem];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.playerView pause];
}

- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = UIColorFromRGB(0x181818);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

- (void)addActionButtons
{
    //保存本地
    UIButton *storeBtn = [self createButtonWithTitle:@"保存"];
    storeBtn.frame = CGRectMake((self.view.width - 60 - 120)/2, (self.view.height - 358/2 - 60), 60, 60);
    storeBtn.clipsToBounds = YES;
    storeBtn.layer.cornerRadius = 30;
    storeBtn.tag = 9908;
    //分享
    UIButton *shareBtn = [self createButtonWithTitle:@"分享"];
    shareBtn.frame = CGRectMake(storeBtn.right + 60, (self.view.height - 358/2 - 60), 60, 60);
    shareBtn.clipsToBounds = YES;
    shareBtn.layer.cornerRadius = 30;
    shareBtn.tag = 9909;
}

- (void)clickAction:(UIButton *)sender
{
    if(sender.tag == 9909)
    {
        //分享
        UIViewController *vc = [BOSHShareManager shareVideo:self.shareURL completion:^(NSError *erro) {
            
        }];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }
    if(sender.tag == 9908)
    {
        //保存
        @weakify(self);
        if([BOSHPermissionRequest requestPermission:BOSHAuthorizationRequestTypePhotoLibrary] == BOSHAuthorizationStatusAuthorized)
        {
            //已经授权
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [BOSHUtils writeVideoToPhotosAlbum:self.shareURL completionHandler:^(NSURL *assetURL, NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if(!error)
                {
                    [weakself.view makeToast:@"保存成功！"];
                }
                else
                {
                    [weakself.view makeToast:@"保存失败！"];
                }
            }];
        }
        else
        {
            [self showWithTitle:nil message:@"请进入系统设置页面开启相册权限 " cancelButtonTitle:@"去设置" otherButtonTitles:@"取消" completion:^(int index) {
                if(index == 0)
                {
                    [BOSHPermissionRequest gotoApplicationSetting];
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
