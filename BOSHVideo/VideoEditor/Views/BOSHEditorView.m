//
//  BOSHEditorView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHEditorView.h"
#import <Masonry.h>
#import "BOTHMacro.h"
#import "UIView+Geometry.h"

#define kMargin 15
#define kSpace 5
#define kTag 9908

@interface BOSHEditorView ()
{
    UIButton *muteBtn;
    UIButton *textBtn;
    UIButton *pasterBtn;
    UIButton *transitionBtn;
    UIButton *speedBtn;
    UIButton *watermarkBtn;
}
@end

@implementation BOSHEditorView


/**
 *
 *  静音
 *  字幕
 *  贴纸
 *  水印
 * 删除
 * 转场
 *
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self loadSubViews];
    }
    return self;
}


- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = UIColorFromRGB(0x181818);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)loadSubViews
{
    muteBtn = [self createButtonWithTitle:@"静音"]; muteBtn.tag = kTag + BOSHEditorViewActionVolume;
    textBtn = [self createButtonWithTitle:@"字幕"]; textBtn.tag = kTag + BOSHEditorViewActionSubtitles;
    pasterBtn = [self createButtonWithTitle:@"贴纸"]; pasterBtn.tag = kTag + BOSHEditorViewActionPasters;
    transitionBtn = [self createButtonWithTitle:@"转场"]; transitionBtn.tag = kTag + BOSHEditorViewActionTransition;
    speedBtn = [self createButtonWithTitle:@"速度"]; speedBtn.tag = kTag + BOSHEditorViewActionSpeed;
    watermarkBtn = [self createButtonWithTitle:@"水印"]; watermarkBtn.tag = kTag + BOSHEditorViewActionWatermark;
}


- (void)layoutSubviews
{
    CGFloat xwidth = (self.width - kMargin*2  -kSpace*2)/3;
    CGFloat xHeight = xwidth *9/16;
    
    watermarkBtn.frame =  CGRectMake(self.width - kMargin - xwidth, self.height - xHeight - kMargin, xwidth, xHeight);
    speedBtn.frame =  CGRectMake(kMargin + xwidth + kSpace, self.height - xHeight - kMargin, xwidth, xHeight);
    transitionBtn.frame =  CGRectMake(kMargin, self.height - xHeight - kMargin, xwidth, xHeight);
    
    pasterBtn.frame =  CGRectMake(self.width - kMargin - xwidth, self.height - xHeight - kMargin - kSpace - xHeight, xwidth, xHeight);
    textBtn.frame =  CGRectMake(kMargin + xwidth + kSpace,self.height - xHeight - kMargin - kSpace - xHeight, xwidth, xHeight);
    muteBtn.frame =  CGRectMake(kMargin, self.height - xHeight - kMargin - kSpace - xHeight, xwidth, xHeight);
}

#pragma mark --click
- (void)clickAction:(UIButton *)sender
{
    if(_actionHandler)
    {
        _actionHandler(sender.tag - kTag);
    }
}

@end
