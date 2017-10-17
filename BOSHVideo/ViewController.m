//
//  ViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/9/22.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "ViewController.h"
#import "BOSHVideoThumbCtx.h"
#import "BOSHGIFContext.h"
#import "BOSHUtils.h"
#import "UIImage+GIF.h"
#import "BOSHHomeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "BOTHPlayerView.h"

@interface ViewController ()
{
    UIScrollView *scroll ;BOSHVideoThumbCtx *ctx;
    
    UIImageView *imageView;
    
    BOTHPlayerView *playerView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200)];
    [self.view addSubview:imageView];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
    scroll.layer.borderWidth = 2;
    [self.view addSubview:scroll];
    
    
    
    
}

- (IBAction)playAction:(id)sender {
    
    if(playerView == nil)
    {
        playerView = [[BOTHPlayerView alloc] initWithFrame:CGRectMake(200, 90, (self.view.frame.size.width - 200), (self.view.frame.size.width - 200)*9/16)];
        [self.view addSubview:playerView];
    }
    
    AVAsset *com = [AVAsset assetWithURL:[[NSBundle mainBundle] URLForResource:@"112169" withExtension:@"mp4"]];
    
    AVPlayerItem * playItem = [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"112169" withExtension:@"mp4"]];
    playItem = [AVPlayerItem playerItemWithAsset:com];
    
    [playerView playWithItem:playItem];
    [playerView play];
}

- (IBAction)click:(id)sender {
    
    __block CGFloat x_offset = 0;
    ctx  = [BOSHVideoThumbCtx thumbCtxWithVideo:[[NSBundle mainBundle] URLForResource:@"112169" withExtension:@"mp4"]];
    [ctx thumbImagesWithFPS:1 atTime:100 duration:30 completionHandler:^(UIImage *image){
        
        UIImageView *imv = [[UIImageView alloc] initWithImage:image];
        CGFloat w  = 200 * image.size.width/image.size.height;
        imv.frame = CGRectMake(x_offset, 0, w, 200);
        x_offset += w;
//        imv.contentMode =
        [scroll addSubview:imv];
    }];
    
    scroll.contentSize = CGSizeMake(x_offset, 200);
    
    
    
    [[BOSHGIFContext currentContext] makeVideo:[[NSBundle mainBundle] URLForResource:@"112169" withExtension:@"mp4"] toGif:[[BOSHUtils libraryPath] stringByAppendingPathComponent:@"k.gif"] inQueue:nil completion:^(NSError *erro, NSData *gif) {
        imageView.image = [UIImage sd_animatedGIFWithData:gif];
    }];
    
    
    BOSHHomeViewController *vc  = BOSHHomeViewController.new;
    [self presentViewController:vc animated:YES
                     completion:nil];
}

- (IBAction)click2:(id)sender {
    
    NSArray* imageArray = @[[UIImage imageNamed:@"bgStory"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
