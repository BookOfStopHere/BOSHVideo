//
//  ViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/9/22.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "ViewController.h"
#import "BOSHVideoThumbCtx.h"

@interface ViewController ()
{
    UIScrollView *scroll ;BOSHVideoThumbCtx *ctx;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
    scroll.layer.borderWidth = 2;
    [self.view addSubview:scroll];
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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
