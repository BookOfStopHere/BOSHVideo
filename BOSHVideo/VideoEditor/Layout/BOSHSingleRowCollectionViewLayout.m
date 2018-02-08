//
//  BOSHSingleRowCollectionViewLayout.m
//  BOSHVideo
//
//  Created by yang on 2017/12/8.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHSingleRowCollectionViewLayout.h"
#import "BOTHMacro.h"
#import "UIView+Geometry.h"

@interface BOSHSingleRowCollectionViewLayout ()
// 这个数组装载着每一个 UICollectionViewcell 的布局属性
@property (nonatomic,strong) NSMutableArray  *attrsArray;
@end

@implementation BOSHSingleRowCollectionViewLayout


- (instancetype)init {
    if (self = [super init]) {
        // 如果用户没有设置这些值，我们必须为用户设置一个默认值
        self.columnMargin = 10;
        self.rowMargin = 0;
        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.coloumnsCount = 2;
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
    }
    return self;
}

- (void)dealloc
{
}

- (NSInteger)coloumnsCount
{
    if(_delegate && [_delegate respondsToSelector:@selector(numberOfColumnsForLayout:)])
    {
        return [_delegate numberOfColumnsForLayout:self];
    }
    return 2;
}

- (NSInteger)rowsCount
{
    return 1;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray ) {
        _attrsArray = [[NSMutableArray alloc]init];
    }
    return _attrsArray;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // 每次布局之前，先把之前的cell 的布局属性都给删掉，然后重新设置
    [self.attrsArray removeAllObjects];
    // 第0组的 item 的数量
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i ++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}


// 返回内容尺寸
- (CGSize)collectionViewContentSize {
    
    CGFloat x_width = self.sectionInset.left;
    for(int ii =0; ii < self.coloumnsCount; ii++)
    {
        x_width += [self.delegate layout:self widthForColumnAtIndexPath: [NSIndexPath indexPathForItem:ii inSection:0]] + self.columnMargin;
    }
    x_width += self.sectionInset.right - self.columnMargin;
    
    return CGSizeMake(x_width,0);
}

// 在指定范围内返回每一个 cell 的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 返回所有布局属性
    return self.attrsArray;
}

// 为indexPath 位置中的 cell 返回一个布局属性，告诉这个 cell 改放在哪一个位置(frame)
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = [self.delegate layout:self widthForColumnAtIndexPath:indexPath];
    
    CGFloat maxHeight = (self.collectionView.height - self.sectionInset.top - self.sectionInset.bottom - (self.rowsCount - 1)*self.rowMargin)/self.rowsCount;
    
    CGFloat height = [self.delegate layout:self heightForRowAtIndexPath:indexPath];
    
    CGFloat x_start = self.sectionInset.left;
    for(int ii =0; ii < indexPath.item; ii++)
    {
        x_start += [self.delegate layout:self widthForColumnAtIndexPath: [NSIndexPath indexPathForItem:ii inSection:0]] + self.columnMargin;
    }
    // 计算位置
    CGFloat x = x_start;
    CGFloat y = self.sectionInset.top + (maxHeight - height)/2;
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}
@end
