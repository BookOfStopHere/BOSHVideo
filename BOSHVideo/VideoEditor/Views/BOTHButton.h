//
//  BOTHButton.h
//  BOSHVideo
//
//  Created by yang on 2017/10/31.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOTHButton : UIButton

@property (nonatomic, strong) UILabel *indicatorLabel;

- (void)setNumber:(int)num;

@end
