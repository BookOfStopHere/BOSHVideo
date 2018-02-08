//
//  BOSHTransitionSelectionView.h
//  BOSHVideo
//
//  Created by yang on 2017/12/12.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOSHTrack.h"

@interface BOSHTransitionSelectionView : UIView

@property (nonatomic) BOSHTransitionType selectType;

@property (nonatomic, copy) void(^selectActionHandler)(BOSHTransitionType type);

@end
