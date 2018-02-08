//
//  BOSHEditorLayout.m
//  BOSHVideo
//
//  Created by yang on 2017/11/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHEditorLayout.h"
#import "UIFont+Extension.h"
#import "BOTHMacro.h"
#define kButtonWidth 60
#define kBottomMargin 20
#define kButtonW (32/2)
#define kSpace ((_contentVC.view.width - 3 *kButtonWidth - 15*2)/2 )

@implementation BOSHEditorLayout

- (instancetype)initWithContentVC:(UIViewController *)contentVC
{
    self = [super init];
    if(self)
    {
        _contentVC = contentVC;
    }
    return self;
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

- (BOSHProgressView *)progressView
{
    if(!_progressView)
    {
        BOSHProgressView *progressView = [[BOSHProgressView alloc] initWithFrame:CGRectMake(0, _contentVC.view.height  - kBottomMargin - 60 -  [BOSHProgressView preferHeight], _contentVC.view.width , [BOSHProgressView preferHeight])];
        [_contentVC.view addSubview:progressView];
        _progressView = progressView;
    }
    return _progressView;
}


- (BOTHButton*)ackButton
{
    if(!_ackButton)
    {
        BOTHButton *btn = [[BOTHButton alloc] initWithFrame:CGRectMake(15 + (kSpace + kButtonWidth)*3, _contentVC.view.height - 30 - kBottomMargin, kButtonWidth, 30)];
        [btn setTitle:@"添加" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont adaptFont:12];
        btn.backgroundColor = UIColorFromRGB10(255,119,78);//UIColorFromRGBA(0xffffff, .2);
        [_contentVC.view addSubview:btn];
        _ackButton = btn;
    }
    return _ackButton;
}


- (UIButton*)backButton
{
    if(!_backButton)
    {
        BOTHButton *btn = [[BOTHButton alloc] initWithFrame:CGRectMake(15,BOSHStatusBarHeight, 20, 20)];
        [btn setImage:  [UIImage imageNamed:@"vivavideo_material_close_n"] forState:0];
        [_contentVC.view addSubview:btn];
        _backButton = btn;
    }
    return _backButton;
}

- (UIButton*)filterButton
{
    if(!_filterButton)
    {
        BOTHButton *btn = [[BOTHButton alloc] initWithFrame:CGRectMake(100, BOSHStatusBarHeight, kButtonWidth, kButtonWidth)];
         [btn setImage:[UIImage imageNamed:@"bosh_video_filter"] forState:UIControlStateNormal];
        [_contentVC.view addSubview:btn];
        _filterButton = btn;
    }
    return _filterButton;
}

- (UIButton*)editButton
{
    if(!_editButton)
    {
        BOTHButton *btn = [[BOTHButton alloc] initWithFrame:CGRectMake(15 + (kSpace + kButtonWidth), BOSHStatusBarHeight, kButtonWidth, kButtonWidth)];
       [btn setImage:[UIImage imageNamed:@"bosh_media_edit"] forState:UIControlStateNormal];
        [_contentVC.view addSubview:btn];
        _editButton = btn;
    }
    return _editButton;
}

- (UIButton*)audioButton
{
    if(!_audioButton)
    {
        BOTHButton *btn = [[BOTHButton alloc] initWithFrame:CGRectMake(15 + (kSpace + kButtonWidth)*2, BOSHStatusBarHeight, kButtonWidth, kButtonWidth)];
        btn.layer.cornerRadius = 10 / 2;
        [btn setImage:[UIImage imageNamed:@"bosh_add_music"] forState:UIControlStateNormal];
        [_contentVC.view addSubview:btn];
        _audioButton = btn;
    }
    return _audioButton;
}

- (BOSHTimelineViewController *)timelineVC
{
    if(!_timelineVC)
    {
       _timelineVC = [[BOSHTimelineViewController alloc] initWithFrame:CGRectMake(0, _contentVC.view.height -  64, _contentVC.view.width, 64)];
        [_contentVC.view addSubview:_timelineVC.view];
        [_contentVC addChildViewController:_timelineVC];
    }
    return _timelineVC;
}

//- (UIButton*)overlayButton
//{
//    if(!_overlayButton)
//    {
//        BOTHButton *btn = [[BOTHButton alloc] initWithFrame:CGRectMake(15 + kSpace + kButtonWidth, _contentVC.view.height - 30 - kBottomMargin, kButtonWidth, 30)];
//        btn.layer.cornerRadius = 10 / 2;
//        [btn setImage:[UIImage imageNamed:@"bosh_add_music"] forState:UIControlStateNormal];
//        //        btn.titleLabel.font = [UIFont adaptFont:12];
//        //        btn.backgroundColor = UIColorFromRGBA(0xffffff, .2);
//        [_contentVC.view addSubview:btn];
//        _overlayButton = btn;
//    }
//    return _overlayButton;
//}


- (void)setVideoRatio:(float)ratio
{
    CGFloat width =  _contentVC.view.width ;
    CGFloat height  = _contentVC.view.width/ratio;
    
//    if(ratio  < 1)
//    {
//        height =  _contentVC.view.width;
//        width = height*ratio;
//    }
    
    
    self.playerView.frame = CGRectMake(0, 0, width, width);
    self.playerView.centerX = _contentVC.view.width/2;
    self.playerView.centerY = 64 + _contentVC.view.width/2;
}
@end
