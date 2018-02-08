//
//  BOSHCollectionViewCell.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "BOTHMacro.h"

@implementation BOSHCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.gifImageView =  [UIImageView new];
        [self addSubview:self.gifImageView];
        
        
        self.cacheButton = [[UIButton alloc] init];
        [self.cacheButton addTarget:self action:@selector(cacheAction) forControlEvents:UIControlEventTouchUpInside];
        [self.cacheButton setTitle:@"下载" forState:0];
        self.cacheButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.cacheButton.backgroundColor = UIColorFromRGB(0xff8247);
        self.cacheButton.hidden = YES;
        [self addSubview:self.cacheButton];
        
        [self.cacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(50);
        }];
        [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (void)setCacheState:(int)state
{
    if(state)
    {
        [self.cacheButton setTitle:@"已下载" forState:0];
        self.cacheButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.cacheButton.backgroundColor = UIColorFromRGB(0x666666);
        self.cacheButton.userInteractionEnabled = NO;
    }
    else
    {
        [self.cacheButton setTitle:@"下载" forState:0];
        self.cacheButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.cacheButton.backgroundColor = UIColorFromRGB(0xff8247);
        self.cacheButton.userInteractionEnabled = YES;
    }
}


- (void)setSelected:(BOOL)selected
{
    if(selected)
    {
        self.layer.borderColor = UIColorFromRGB(0x90EE90).CGColor;
        self.layer.borderWidth = 2;
    }
    else
    {
        self.layer.borderColor = nil;
        self.layer.borderWidth = 0;
    }
}
#pragma mark download
- (void)cacheAction
{
    if(self.downloadActionHandler)
    {
        self.downloadActionHandler(self.gifModel);
    }
}

@end
