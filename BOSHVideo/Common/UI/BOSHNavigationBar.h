//
//  BOSHNavigationBar.h
//  BOSHVideo
//
//  Created by yang on 2017/12/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOSHNavigationBar : UIView

@property (nonatomic, readonly) UIButton *leftItemBar;
@property (nonatomic, readonly) UIButton *rightItemBar;
@property (nonatomic, readonly) UILabel *titleLabel;
//@property (nonatomic, readonly) UIView *headerBar;


@property (nonatomic, copy) void(^leftActionHandler)(void);
@property (nonatomic, copy) void(^rightActionHandler)(void);

@property (nonatomic) BOOL leftItemHidden;
@property (nonatomic) BOOL rightItemHidden;

- (instancetype)initWithFrame:(CGRect)frame;

@end
