//
//  BOSHHomeViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHHomeViewController.h"
#import "BOTHBlockView.h"
#import "UIView+Geometry.h"
#import "BOSDefines.h"
#import "BOSHHomeLayoutManager.h"

@interface BOSHHomeViewController ()

@property (nonatomic, strong) BOSHHomeLayoutManager *layout;

@end

@implementation BOSHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.layout = [[BOSHHomeLayoutManager alloc] initWithTarget:self.view model:@[]];
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
