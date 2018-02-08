//
//  BOSHWaterFlowLayout.h
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BOSHWaterFlowLayout;
@protocol BOSHWaterFlowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(BOSHWaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)waterflowLayout:(BOSHWaterFlowLayout *)waterflowLayout widthForHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;
@end

@interface BOSHWaterFlowLayout : UICollectionViewLayout
/** 每一列的间距*/
@property (nonatomic, assign) NSInteger columnMargin;
/** 每一行的间距*/
@property (nonatomic, assign) NSInteger rowMargin;
/** 每一组的间距*/
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 有多少列*/
@property (nonatomic, assign) NSInteger coloumnsCount;

@property (nonatomic, weak) id<BOSHWaterFlowLayoutDelegate> delegate;

@end
