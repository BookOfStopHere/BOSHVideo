//
//  BOSHEditorItemsView.h
//  BOSHVideo
//
//  Created by yang on 2017/12/12.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Geometry.h"
#import "BOTHMacro.h"
#import "BOSHImageCollectionViewCell.h"
#import "BOSHDefines.h"

@interface BOSHEditorItemsView : UIView
{
    UICollectionView *_collectionView;
}
@property (nonatomic, strong) UIButton *foldButton;

@property (nonatomic, copy) void(^segmentActionHandler)(BOSHTimelineAction actionType);
@property (nonatomic, copy) void(^foldHandler)(void);


+ (CGFloat)height;
@end
