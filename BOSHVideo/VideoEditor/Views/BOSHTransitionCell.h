//
//  BOSHTransitionCell.h
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOSHTransitonInstruction.h"
#import "BOSHBaseCell.h"
@interface BOSHTransitionCell : BOSHBaseCell

@property (nonatomic, strong) UIButton *transitionButton;
@property (nonatomic) BOSHTransitionType transtionType;

@end
