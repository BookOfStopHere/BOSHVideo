//
//  BOSHTextConfigViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTextConfigViewController.h"
#import "BOTHMacro.h"
#import "UIView+Geometry.h"
#import <Masonry/Masonry.h>
#define kNoticeString @"com.both.video.text.config"
#define kFontString @"kFontString"
#define kColorString @"kColorString"
#define kBgString @"kBgString"
#define kWidth 60
#define kHeight 30
#define kFontSize 15
#define kFontSizeMIN 10
#define kFontSizeMAX 30

@interface MYButton : UIButton
@property (nonatomic, copy) NSString *identifier;
@end

@implementation MYButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:kNoticeString object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)notice:(NSNotification *)notice
{
    MYButton *btn = notice.object;
    if([btn.identifier isEqualToString:self.identifier])
    {
        if(btn == self)
        {
            self.layer.borderColor = UIColorFromRGB(0x111111).CGColor;
            self.layer.borderWidth = 4;
        }
        else
        {
            self.layer.borderWidth = 2;
            self.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        }
    }
}


@end

@interface BOSHTextConfigViewController ()
{
    UILabel *_fontSizeLabel;
}
@property (nonatomic, strong) UILabel *fontNameLabel;
@property (nonatomic, strong) UILabel *colorNameLabel;
@property (nonatomic, strong) UILabel *bgNameLabel;

//@property (nonatomic, strong) UILabel *bgNameLabel;

@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *selectedBgColor;

@property (nonatomic) int fontSize;
@end

@implementation BOSHTextConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0x101010);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 10, 0, 60, 44)];
    [btn setTitle:@"确定" forState:0];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(ackHandler) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"menu_back"] forState:0];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(backHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.fontSize = kFontSize;
    _fontSizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _fontSizeLabel.font = [UIFont systemFontOfSize:kFontSize];
     _fontSizeLabel.frame = CGRectMake(leftBtn.right + 30, (44 - (_fontSizeLabel.font.lineHeight + 4))/2, _fontSizeLabel.font.lineHeight + 4, _fontSizeLabel.font.lineHeight+4);
//    _fontSizeLabel.layer.cornerRadius = (_fontSizeLabel.font.lineHeight+4)/2;
    _fontSizeLabel.textAlignment = NSTextAlignmentCenter;
    _fontSizeLabel.textColor = UIColorFromRGB(0xffffff);
    _fontSizeLabel.layer.borderColor = UIColorFromRGB(0xCDCDC1).CGColor;
    _fontSizeLabel.layer.borderWidth = 2;
    _fontSizeLabel.clipsToBounds = YES;
    _fontSizeLabel.text = [NSString stringWithFormat:@"%d",self.fontSize];
    [self.view addSubview:_fontSizeLabel];
    
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftBtn.right + 30  + 30 + 15, 12, 20, 20)];
    addBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    addBtn.layer.borderWidth = 2;
     addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addBtn setTitle:@"+" forState:0];
    [addBtn addTarget:self action:@selector(addFontAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    UIButton *minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftBtn.right + 30 + 30 + 15 + 30 + 5, 12, 20, 20)];
    minusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    minusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [minusBtn setTitle:@"-" forState:0];
    minusBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    minusBtn.layer.borderWidth = 2;
    [minusBtn addTarget:self action:@selector(minusFontAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:minusBtn];
    
    self.fontNameLabel = [self createLabelWithString:@"字体"];
    self.colorNameLabel = [self createLabelWithString:@"颜色"];
    self.bgNameLabel = [self createLabelWithString:@"背景"];
    
    CGFloat x_start = 10;
    CGFloat y_start = 44 + 10;
    
    CGFloat ySpace =  (self.navigationController.view.height - y_start - 10 - 3*kHeight)/2;
    CGFloat xSpace = (self.navigationController.view.width - 10 - kWidth - 20  -10 - 4*kWidth)/3;
    
    self.fontNameLabel.frame = CGRectMake(10, y_start, kWidth, kHeight);
    self.colorNameLabel.frame = CGRectMake(10, self.fontNameLabel.bottom + ySpace, kWidth, kHeight);
    self.bgNameLabel.frame = CGRectMake(10, self.colorNameLabel.bottom + ySpace, kWidth, kHeight);
    
    //字体
   x_start = self.fontNameLabel.right + 20;
//    [UIFont fontWithName:@"LiuJian-Mao-Cao-2.0" size:30]

    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames )
    {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames )
        {
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
    //NSArray *fonts = @[[UIFont fontWithName:@"winman-tu2k3do3" size:16.0],[UIFont fontWithName:@"DorovarFLF-Carolus" size:16.0],[UIFont fontWithName:@"MicrosoftYaHei" size:16.0],[UIFont fontWithName:@"Degrassi" size:16.0]];
    
        NSArray *fonts = @[[UIFont fontWithName:@"winman-tu2k3do3" size:16.0],[UIFont fontWithName:@"-hyw" size:16.0],[UIFont fontWithName:@"MicrosoftYaHei" size:16.0],[UIFont fontWithName:@"Degrassi" size:16.0]];
    

    for(int ii = 0; ii < 4; ii ++)
    {
        MYButton *btn = [self createButton];
        btn.identifier = kFontString;
        [btn setTitle:@"字体" forState:0];
        btn.titleLabel.font = fonts[ii];
        btn.frame = CGRectMake(x_start, y_start, kWidth, kHeight);
        x_start += xSpace + kWidth;
    }
    //颜色
    NSArray *fontcolors = @[UIColorFromRGBA(0xffffff,.3),UIColorFromRGB(0xFF6A6A),UIColorFromRGB(0xEEB422),UIColorFromRGB(0xCD3333)];
    x_start = self.colorNameLabel.right + 20;
    y_start = self.colorNameLabel.top;
    for(int ii = 0; ii < 4; ii ++)
    {
        MYButton *btn = [self createButton];
        btn.identifier = kColorString;
        btn.backgroundColor = fontcolors[ii];
        btn.frame = CGRectMake(x_start, y_start, kWidth, kHeight);
        x_start += xSpace + kWidth;
    }
    
    //背景
    NSArray *colors = @[UIColorFromRGBA(0xffffff,.3),UIColorFromRGB(0xF5F5DC),UIColorFromRGB(0xEEA9B8),UIColorFromRGB(0xFF83FA)];
    x_start = self.bgNameLabel.right + 20;
    y_start = self.bgNameLabel.top;
    for(int ii = 0; ii < 4; ii ++)
    {
        MYButton *btn = [self createButton];
         btn.identifier = kBgString;
        btn.backgroundColor = colors[ii];
        btn.frame = CGRectMake(x_start, y_start, kWidth, kHeight);
        x_start += xSpace + kWidth;
    }
    
}

- (void)addFontAction
{
    if(self.fontSize >= kFontSizeMAX) return;
    _fontSizeLabel.text = [NSString stringWithFormat:@"%d",++self.fontSize];
    _fontSizeLabel.font = [UIFont systemFontOfSize:self.fontSize];
    
     _fontSizeLabel.frame = CGRectMake(_fontSizeLabel.left, (44 - (_fontSizeLabel.font.lineHeight + 4))/2, _fontSizeLabel.font.lineHeight + 4, _fontSizeLabel.font.lineHeight+4);
//    _fontSizeLabel.layer.cornerRadius = (_fontSizeLabel.font.lineHeight +4 )/2;
}

- (void)minusFontAction
{
    if(self.fontSize <= kFontSizeMIN) return;
    _fontSizeLabel.text = [NSString stringWithFormat:@"%d",--self.fontSize];
     _fontSizeLabel.font = [UIFont systemFontOfSize:self.fontSize];
    _fontSizeLabel.frame = CGRectMake(_fontSizeLabel.left, (44 - (_fontSizeLabel.font.lineHeight + 4))/2, _fontSizeLabel.font.lineHeight + 4, _fontSizeLabel.font.lineHeight+4);
//    _fontSizeLabel.layer.cornerRadius = (_fontSizeLabel.font.lineHeight +4 )/2;
}

- (void)backHandler
{
    [self dismissSelf];
}

- (void)ackHandler
{
    if(self.completitionHandler) self.completitionHandler();
    [self dismissSelf];
}

- (UILabel *)createLabelWithString:(NSString *)string
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.textColor = UIColorFromRGB(0xffffff);
    lab.font = [UIFont systemFontOfSize:18];
    lab.text = [NSString stringWithFormat:@"%@",string];
    [self.view addSubview:lab];
    return lab;
}


- (MYButton *)createButton
{
    MYButton *btn = [[MYButton alloc] initWithFrame:CGRectZero];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
//
}


- (void)selectAction:(MYButton *)sender
{
    if([sender.identifier isEqualToString:kFontString])
    {
        self.selectedFont = sender.titleLabel.font;
    }
    else if([sender.identifier isEqualToString:kColorString])
    {
        self.selectedColor = sender.titleLabel.textColor;
    }
    else if([sender.identifier isEqualToString:kBgString])
    {
        self.selectedBgColor = sender.backgroundColor;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeString object:sender];
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
