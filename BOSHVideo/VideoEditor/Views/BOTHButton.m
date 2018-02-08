//
//  BOTHButton.m
//  BOSHVideo
//
//  Created by yang on 2017/10/31.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHButton.h"
#import "BOTHMacro.h"
#import "UIView+Geometry.h"

@implementation BOTHButton


- (UILabel *)indicatorLabel
{
    if(!_indicatorLabel)
    {
        _indicatorLabel = [[UILabel alloc] init];
        _indicatorLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorLabel.font = [UIFont systemFontOfSize:9];
        _indicatorLabel.textColor = [UIColor whiteColor];
        _indicatorLabel.backgroundColor = [UIColor redColor];
        _indicatorLabel.clipsToBounds = YES;
        _indicatorLabel.layer.masksToBounds = YES;
        [self addSubview:_indicatorLabel];
    }
    return _indicatorLabel;
}


- (void)setNumber:(int)num
{
    NSString *text = [NSString stringWithFormat:@"%d",num];
    CGSize size = [text boundingRectWithSize:CGSizeMake(200,200) options:NSStringDrawingUsesFontLeading attributes:@{
                                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:9],
                                                                                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                       } context:nil].size;
    self.indicatorLabel.text = text;
    _indicatorLabel.layer.cornerRadius = size.height/2;
    _indicatorLabel.frame = CGRectMake(0, 0, size.width + size.height, size.height);
    _indicatorLabel.centerX = self.width - 5;
    _indicatorLabel.centerY = 0;
}
@end
