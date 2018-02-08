//
//  BOSHTransitionSelectionView.m
//  BOSHVideo
//
//  Created by yang on 2017/12/12.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTransitionSelectionView.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"
#import "BOSHImageCollectionViewCell.h"
static NSString *titleArray[] = {@"无",@"划入",@"渐变",@"推拉",@"溶解",@"窗帘"};
@interface BOSHTransitionSelectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
}

@end

@implementation BOSHTransitionSelectionView

//BOSHTransitionTypeNone,//无
//BOSHTransitionFlipFromRight ,//划入
//BOSHTransitionFade,//渐变
//BOSHTransitionTypePush,//推拉模式
//BOSHTransitionDissovle,//中间逐渐缩小直到溶解
//BOSHTransitionCurtain,//窗帘动画

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self configCollectionView];
    }
    return self;
}


- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.height, self.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    [self addSubview:_collectionView];
    [_collectionView registerClass:[BOSHImageCollectionViewCell class] forCellWithReuseIdentifier:@"BOSHImageCollectionViewCell"];

}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    BOSHImageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"BOSHImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imageButton setTitle:titleArray[indexPath.item] forState:0];
    if(self.selectType == indexPath.item)
    {
        cell.layer.borderWidth = 3;
        cell.layer.borderColor = UIColorFromRGB(0xEE6363).CGColor;
    }
    else
    {
        cell.layer.borderWidth = 0;
        cell.layer.borderColor = nil;
    }
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if(self.selectActionHandler) self.selectActionHandler(indexPath.item);
}

@end
