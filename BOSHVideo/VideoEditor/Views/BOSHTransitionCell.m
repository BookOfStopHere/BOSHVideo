//
//  BOSHTransitionCell.m
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTransitionCell.h"
#import <Masonry/Masonry.h>
#import "BOTHMacro.h"

@implementation BOSHTransitionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIButton *)transitionButton
{
    if(!_transitionButton)
    {
        _transitionButton = [[UIButton alloc] init];
        [_transitionButton addTarget:self action:@selector(actionHandler:) forControlEvents:UIControlEventTouchUpInside];
        _transitionButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _transitionButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_transitionButton];//加载self 上会导致被旋转
        
        [_transitionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
    }
    return _transitionButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTranstionType:(BOSHTransitionType)transtionType
{
    if(_transtionType == transtionType) return;
    @synchronized (self)
    {
        _transtionType = transtionType;
        switch (_transtionType) {
            case BOSHTransitionTypeNone:
            {
                [self.transitionButton setTitle:@"无" forState:0];
            }
                break;
            case BOSHTransitionTypePush:
            {
                 [self.transitionButton setTitle:@"推拉" forState:0];
            }
                break;
            case BOSHTransitionFade:
            {
                 [self.transitionButton setTitle:@"渐变" forState:0];
            }
                break;
            case BOSHTransitionFlipFromRight:
            {
                 [self.transitionButton setTitle:@"飞渡" forState:0];
            }
                break;
            default:
                break;
        }
        [self setNeedsLayout];
    }
}

- (void)actionHandler:(id)sender
{
    
}

@end
