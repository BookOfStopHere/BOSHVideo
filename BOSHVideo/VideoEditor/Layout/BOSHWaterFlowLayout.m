//
//  BOSHWaterFlowLayout.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHWaterFlowLayout.h"

@interface BOSHWaterFlowLayout ()
/** 这个字典用来存储每一列最大的 Y 值(每一列的高度)*/
// 如果coloumnsCount只有3列，那么这个 maxDict 就像如此 @{@"0":@(0), @"1":@(0), @"2":@(2)}
@property (nonatomic,strong) NSMutableDictionary *maxDict;
// 这个数组装载着每一个 UICollectionViewcell 的布局属性
@property (nonatomic,strong) NSMutableArray  *attrsArray;
@end

@implementation BOSHWaterFlowLayout


- (instancetype)init {
    if (self = [super init]) {
        // 如果用户没有设置这些值，我们必须为用户设置一个默认值
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.coloumnsCount = 2;
    }
    return self;
}

- (void)dealloc
{
}

- (NSMutableDictionary *)maxDict
{
    if (!_maxDict ) {
        _maxDict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < self.coloumnsCount; i ++) {
            NSString *column = [NSString stringWithFormat:@"%d",i];
            self.maxDict[column] = @0;
        }
    }
    // @"0" : @(0), @"1" : @(0) , @"2" : @(0) 这种格式来存储这一列最大的 Y 值
    return _maxDict;
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
    
    for (int i = 0; i < self.coloumnsCount; i ++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        self.maxDict[column] = @(0);
    }
    
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
    __block NSString *maxColumn = @"0";
    // 找出 maxDict 字典中最后最大的行的的高度
    [self.maxDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *obj, BOOL * _Nonnull stop) {
        if (self.maxDict[column] > self.maxDict[maxColumn] ) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxDict[maxColumn] floatValue]);
}

// 在指定范围内返回每一个 cell 的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 返回所有布局属性
    return self.attrsArray;
}

// 为indexPath 位置中的 cell 返回一个布局属性，告诉这个 cell 改放在哪一个位置(frame)
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 假设最短的那一列是第0列
    __block NSString *minColum = @"0";
    // 找出最短的那一列
    [self.maxDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] < [self.maxDict[minColum] floatValue]) {
            minColum = column;
        }
    }];
    
    // 计算宽度
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.coloumnsCount - 1) * self.columnMargin ) / self.coloumnsCount;
    CGFloat height = [self.delegate waterflowLayout:self heightForWidth:width atIndexPath:indexPath];
    
    // 计算位置
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColum intValue];
    CGFloat y = self.rowMargin + [self.maxDict[minColum] floatValue];
    
    // 更新这一列最大的 Y 值
    self.maxDict[minColum] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}

@end
