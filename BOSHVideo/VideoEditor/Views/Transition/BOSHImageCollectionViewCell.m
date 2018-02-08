//
//  BOSHImageCollectionViewCell.m
//  BOSHVideo
//
//  Created by yang on 2017/12/12.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHImageCollectionViewCell.h"

@implementation BOSHImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageButton = [UIButton new];
        [self addSubview:self.imageButton];
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageButton.frame = self.bounds;
    [super layoutSubviews];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *v = [super hitTest:point withEvent:event];
    if([v isDescendantOfView:self])
    {
        return self;
    }
    return v;
}

@end
