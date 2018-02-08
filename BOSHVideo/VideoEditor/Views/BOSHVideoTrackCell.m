//
//  BOSHVideoTrackCell.m
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHVideoTrackCell.h"
#import <Masonry.h>
@implementation BOSHVideoTrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setVideoSelected:(BOOL)videoSelected
{
    _videoSelected = videoSelected;
    [self setNeedsLayout];
}

- (UIView *)subContentView
{
    if(!_subContentView)
    {
        _subContentView = [[UIView alloc] init];
        _subContentView.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;//旋转之后 只能设置这个有效
        [self.contentView addSubview:_subContentView];
        
        [_subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _subContentView;
}


- (void)setImages:(NSArray<UIImage *> *)images
{
    if(images.count > 0)
    {
        if(self.subContentView.subviews.count)
        {
            [self.subContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        CGFloat xWidth =BOSH_PER_SECOND_WIDTH;
        CGFloat xHeight = BOSH_PER_SECOND_WIDTH ;
        CGFloat x_offset = 0;
        for(int ii =0; ii < images.count; ii ++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.subContentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(xWidth);
                make.height.mas_equalTo(xHeight);
                make.left.mas_equalTo(x_offset);
            }];
            imageView.image = images[ii];
            x_offset += xWidth;
        }
        [self setNeedsLayout];
    }
}

- (void)setImage:(UIImage *)image
{
    if(image)
    {
        if(self.subContentView.subviews.count)
        {
            [self.subContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        CGFloat xWidth =BOSH_PER_SECOND_WIDTH;
        CGFloat xHeight = BOSH_PER_SECOND_WIDTH ;
        CGFloat x_offset = 0;
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.subContentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(xWidth);
            make.height.mas_equalTo(xHeight);
            make.left.mas_equalTo(x_offset);
        }];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = image;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews
{
    if(_videoSelected)
    {
        [UIView animateWithDuration:.35 animations:^{
            self.layer.borderWidth = 1;
            self.layer.borderColor = UIColorFromRGB(0xEEC900).CGColor;
        }];
    }
    else
    {
        [UIView animateWithDuration:.35 animations:^{
            self.layer.borderWidth = 0;
            self.layer.borderColor = nil;
        }];
    }
    [super layoutSubviews];
}

@end
