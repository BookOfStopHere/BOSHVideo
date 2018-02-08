//
//  BOTHSingleEditorLayout.m
//  BOSHVideo
//
//  Created by yang on 2017/11/2.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHSingleEditorLayout.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"
#import "UIFont+Extension.h"

#define kButtonWidth 60
#define kBottomMargin 20
#define kSpace ((_contentVC.view.width - 4 *kButtonWidth - 15*2)/3 )

@implementation BOTHSingleEditorLayout

- (instancetype)initWithContentVC:(UIViewController *)contentVC
{
    self = [super init];
    if(self)
    {
        _contentVC = contentVC;
    }
    return self;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20,_contentVC.view.width - 80 , 20)];
        [titleLabel setFont:[UIFont systemFontOfSize:22]];
        titleLabel.text = @"视频片段剪辑";
        titleLabel.textColor = UIColorFromRGB(0x666666);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentVC.view addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIButton*)backButton
{
    if(!_backButton)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 20, 20)];
        [btn setImage:  [UIImage imageNamed:@"vivavideo_material_close_n"] forState:0];
        [_contentVC.view addSubview:btn];
        _backButton = btn;
    }
    return _backButton;
}

- (UIButton*)rotateButton
{
    if(!_rotateButton)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, _contentVC.view.height - 30 - kBottomMargin, kButtonWidth, 30)];
        btn.layer.cornerRadius = 10 / 2;
        [btn setTitle:@"旋转" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont adaptFont:12];
        btn.backgroundColor = UIColorFromRGBA(0x2B2B2B, .2);
        [_contentVC.view addSubview:btn];
        _rotateButton = btn;
    }
    return _rotateButton;
}

- (UIButton*)cropButton
{
    if(!_cropButton)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + (kSpace + kButtonWidth)*2, _contentVC.view.height - 30 - kBottomMargin, kButtonWidth, 30)];
        btn.layer.cornerRadius = 10 / 2;
        [btn setTitle:@"填充" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont adaptFont:12];
        btn.backgroundColor = UIColorFromRGBA(0x2B2B2B, .2);
        [_contentVC.view addSubview:btn];
        _cropButton = btn;
    }
    return _cropButton;
}

- (UIButton*)clipButton
{
    if(!_clipButton)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + kSpace + kButtonWidth, _contentVC.view.height - 30 - kBottomMargin, kButtonWidth, 30)];
        btn.layer.cornerRadius = 10 / 2;
        [btn setTitle:@"剪切" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont adaptFont:12];
        btn.backgroundColor = UIColorFromRGBA(0x2B2B2B, .2);
        [_contentVC.view addSubview:btn];
        _clipButton = btn;
    }
    return _clipButton;
}

- (BOTHButton*)addButton
{
    if(!_addButton)
    {
        BOTHButton *btn = [[BOTHButton alloc] initWithFrame:CGRectMake(15 + (kSpace + kButtonWidth)*3, _contentVC.view.height - 30 - kBottomMargin, kButtonWidth, 30)];
        btn.layer.cornerRadius = 10 / 2;
        [btn setTitle:@"添加" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont adaptFont:12];
        btn.backgroundColor = UIColorFromRGB10(255,119,78);//UIColorFromRGBA(0xffffff, .2);
        [_contentVC.view addSubview:btn];
        _addButton = btn;
    }
    return _addButton;
}

- (BOTHPlayerView *)playerView
{
    if(!_playerView)
    {
        BOTHPlayerView *playerView = [[BOTHPlayerView alloc] initWithFrame:CGRectMake(0, 125, _contentVC.view.width, _contentVC.view.width *9/16.0)];
        playerView.backgroundColor = [UIColor blackColor];
        [_contentVC.view addSubview:playerView];
        _playerView = playerView;
    }
    return _playerView;
}

- (BOTHEditorRulerView *)rulerView
{
    if(!_rulerView)
    {
        BOTHEditorRulerView *rulerView = [[BOTHEditorRulerView alloc] initWithFrame:CGRectMake(15, _contentVC.view.height - 30 - kBottomMargin - 60 -  [BOTHEditorRulerView preferHeight], _contentVC.view.width - 15 *2 , [BOTHEditorRulerView preferHeight])];
        [_contentVC.view addSubview:rulerView];
        _rulerView = rulerView;
    }
    return _rulerView;
}


- (BOTHTimeView *)timeLabel
{
    if(!_timeLabel)
    {
        BOTHTimeView *titleLabel = [[BOTHTimeView alloc] initWithFrame:CGRectMake(_contentVC.view.width - 250 - 5, _contentVC.view.height - 30 - kBottomMargin - 60 -  [BOTHEditorRulerView preferHeight], 250, 30)];
        titleLabel.text = @"";
        titleLabel.textAlignment = NSTextAlignmentRight;
        [_contentVC.view addSubview:titleLabel];
        _timeLabel = titleLabel;
    }
    return _timeLabel;
}


- (void)setVideoRatio:(float)ratio
{
    CGFloat width =  _contentVC.view.width ;
    CGFloat height  = _contentVC.view.width/ratio;
    
    if(ratio  < 1)
    {
        height =  _contentVC.view.width;
        width = height*ratio;
    }
    
    self.playerView.frame = CGRectMake(0, 0, width, height);
    self.playerView.centerX = _contentVC.view.width/2;
    self.playerView.centerY = 64 + _contentVC.view.width/2;
}

@end
