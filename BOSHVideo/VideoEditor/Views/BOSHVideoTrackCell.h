//
//  BOSHVideoTrackCell.h
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOSHBaseCell.h"
#import "BOTHMacro.h"

@interface BOSHVideoTrackCell : BOSHBaseCell

@property (nonatomic, strong) UIView *subContentView;
@property (nonatomic, strong) NSArray<UIImage *> *images;

@property (nonatomic) BOOL videoSelected;

- (void)setImage:(UIImage *)image;
@end
