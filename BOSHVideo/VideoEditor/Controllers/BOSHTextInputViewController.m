//
//  BOSHTextInputViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTextInputViewController.h"
#import "BOTHMacro.h"
#import "UIView+Geometry.h"

@interface BOSHTextInputViewController () <UITextViewDelegate>
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation BOSHTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x101010);
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    [self prepare];
}

- (void)prepare
{
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 10, 20, 60, 44)];
    [self.rightBtn setTitle:@"确定" forState:0];
    [self.view addSubview:self.rightBtn];
    [self.rightBtn addTarget:self action:@selector(ackHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 60, 44)];
    [self.leftBtn setTitle:@"取消" forState:0];
    [self.view addSubview:self.leftBtn];
    [self.leftBtn addTarget:self action:@selector(backHandler) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64, self.view.width - 20, 300)];
    self.textView.tintColor = [UIColor redColor];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textView];
    self.textView.text = @"";
    self.textView.delegate = self;
    self.textView.font = [UIFont fontWithName:@"-hyw" size:32.0];
    self.textView.textColor = UIColorFromRGB(0xffffff);
    
//    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 10, 20, 60, 44)];
//    [self.rightBtn setTitle:@"字体" forState:0];
//    [self.view addSubview:self.rightBtn];
//    [self.rightBtn addTarget:self action:@selector(ackHandler) forControlEvents:UIControlEventTouchUpInside];
//
//    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 10, 20, 60, 44)];
//    [self.rightBtn setTitle:@"颜色" forState:0];
//    [self.view addSubview:self.rightBtn];
//    [self.rightBtn addTarget:self action:@selector(ackHandler) forControlEvents:UIControlEventTouchUpInside];
//
//    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 10, 20, 60, 44)];
//    [self.rightBtn setTitle:@"位置" forState:0];
//    [self.view addSubview:self.rightBtn];
//    [self.rightBtn addTarget:self action:@selector(ackHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.textView becomeFirstResponder];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    textView.height = MAX(textView.contentSize.height,textView.height);
//    self.height = textView.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark user action
- (void)ackHandler
{
    if(self.textOverlay == nil)
    {
        self.textOverlay = [BOSHTextOverlay overlay];
    }
    self.textOverlay.font =  [UIFont fontWithName:@"-hyw" size:32.0];
    self.textOverlay.textColor =  UIColorFromRGB(0xffffff);
    self.textOverlay.text = self.textView.text;
    self.textOverlay.textAlign = kCAAlignmentCenter;
    
    if(self.inputTextHandler) self.inputTextHandler(self.textOverlay);
    [self backHandler];
}

- (void)backHandler
{
    [self.textView resignFirstResponder];
    [self dismissSelf];
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
