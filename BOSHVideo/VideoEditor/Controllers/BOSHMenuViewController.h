//
//  BOSHMenuViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOSHTimelineAsset.h"
@class BOSHMenuViewController;
@protocol BOSHMenuViewControllerProtocol <NSObject>
@optional
- (void)menuViewController:(BOSHMenuViewController *)mVC didSelectFontParamters:(id)parameters;

@end

@interface BOSHMenuViewController : BOSHBaseViewController
@property (weak, nonatomic) id<BOSHMenuViewControllerProtocol> delegate;
@property (nonatomic, strong) BOSHTimelineAsset *timelineAsset;
- (instancetype)initWithFrame:(CGRect)frame;

@end
