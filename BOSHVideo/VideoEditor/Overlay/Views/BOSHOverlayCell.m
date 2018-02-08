//
//  BOSHOverlayCell.m
//  BOSHVideo
//
//  Created by yang on 2017/12/11.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHOverlayCell.h"
#import "BOTHMacro.h"

@implementation BOSHOverlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (DoubleSlider *)slider
{
    if(!_slider)
    {
        _slider = [[DoubleSlider alloc] initWithFrame:CGRectMake(5 + 60, 0, BOSHScreenW - 5 - 60 - 5, 60) barHeight:30];
        [self.contentView addSubview:_slider];
    }
    return _slider;
}

- (UIButton *)titleV
{
    if(!_titleV)
    {
        _titleV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _titleV.userInteractionEnabled = YES;
        [_titleV addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        _titleV.layer.cornerRadius = 8;
        _titleV.clipsToBounds = YES;
        [self.contentView addSubview:_titleV];
    }
    return _titleV;
}


- (void)selectAction:(UIButton *)tap
{
    if(self.selectHandler) self.selectHandler(self.overlay);
}

@end
