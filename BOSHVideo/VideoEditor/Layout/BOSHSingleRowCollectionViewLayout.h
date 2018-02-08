//
//  BOSHSingleRowCollectionViewLayout.h
//  BOSHVideo
//
//  Created by yang on 2017/12/8.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

//仅仅支持单个section
@class BOSHSingleRowCollectionViewLayout;
@protocol BOSHSingleRowCollectionViewLayoutDelegate <NSObject>
- (CGFloat)layout:(BOSHSingleRowCollectionViewLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)layout:(BOSHSingleRowCollectionViewLayout *)layout widthForColumnAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfColumnsForLayout:(BOSHSingleRowCollectionViewLayout *)layout;
@end

@interface BOSHSingleRowCollectionViewLayout : UICollectionViewFlowLayout

/** 每一列的间距*/
@property (nonatomic, assign) NSInteger columnMargin;
/** 每一行的间距*/
@property (nonatomic, assign) NSInteger rowMargin;
/** 每一组的间距*/
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 有多少列*/
@property (nonatomic, assign) NSInteger coloumnsCount;

@property (nonatomic, weak) id<BOSHSingleRowCollectionViewLayoutDelegate> delegate;


@end
