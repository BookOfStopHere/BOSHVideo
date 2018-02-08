//
//  BOSHCollectionViewCell.h
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOSHGIFModel.h"
@interface BOSHCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) BOSHGIFModel *gifModel;
@property (nonatomic, strong) UIButton *cacheButton;

@property (nonatomic, copy) void(^downloadActionHandler)(BOSHGIFModel *gifModel);

/**
 * 1表示下载完成
 * 0 表示未下载完成
 */
- (void)setCacheState:(int)state;

@end
