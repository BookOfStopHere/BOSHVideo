//
//  BOSHOverlayCell.h
//  BOSHVideo
//
//  Created by yang on 2017/12/11.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOSHOverlay.h"
#import "DoubleSlider.h"

@interface BOSHOverlayCell : UITableViewCell
@property (nonatomic, strong) UIButton *titleV;
@property (nonatomic, strong) DoubleSlider *slider;

@property (nonatomic, copy) void(^selectHandler)(BOSHOverlay *overlay);
@property (nonatomic, strong) BOSHOverlay *overlay;

@end
