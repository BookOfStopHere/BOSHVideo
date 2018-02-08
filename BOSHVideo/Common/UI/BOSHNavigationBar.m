//
//  BOSHNavigationBar.m
//  BOSHVideo
//
//  Created by yang on 2017/12/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHNavigationBar.h"
#import "BOTHMacro.h"
#import "UIView+Geometry.h"

@interface BOSHNavigationBar ()
{
    UIButton *_leftItemBar;
    UIButton *_rightItemBar;
    UILabel *_titleLabel;
//     UIView *_headerBar;
}
@end

@implementation BOSHNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

//@property (nonatomic) BOOL leftItemHidden;
- (void)setLeftItemHidden:(BOOL)leftItemHidden
{
    _leftItemHidden = leftItemHidden;
    self.leftItemBar.hidden = leftItemHidden;
}

- (void)setRightItemHidden:(BOOL)rightItemHidden
{
    _rightItemHidden = rightItemHidden;
    self.rightItemBar.hidden = rightItemHidden;
}


- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65 + 5, self.height - 44, self.width - 65 -65 - 10, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)rightItemBar
{
    if(!_rightItemBar)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 60 - 5, self.height - 44, 60, 44)];
        [btn setTitle:@"确定" forState:0];
         [btn addTarget:self action:@selector(dispatchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _rightItemBar = btn;
    }
    return _rightItemBar;
}


- (UIButton *)leftItemBar
{
    if(!_leftItemBar)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, self.height - 44, 60, 44)];
        [btn setImage:[UIImage imageNamed:@"menu_back"] forState:0];
        [btn addTarget:self action:@selector(dispatchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _leftItemBar = btn;
    }
    return _leftItemBar;
}




- (void)dispatchAction:(UIButton *)button
{
    if(self.leftItemBar == button)
    {
        if(_leftActionHandler) _leftActionHandler();
    }
    else if(self.rightItemBar == button)
    {
        if(_rightActionHandler) _rightActionHandler();
    }
}
@end
