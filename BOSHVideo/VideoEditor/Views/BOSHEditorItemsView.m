//
//  BOSHEditorItemsView.m
//  BOSHVideo
//
//  Created by yang on 2017/12/12.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHEditorItemsView.h"
static NSString *titleArray[] = {@"静音",@"翻转",@"文字",@"贴图",@"配音",@"滤镜",@"置换",@"插入"};

@interface BOSHEditorItemsView () <UICollectionViewDelegate, UICollectionViewDataSource>
@end

@implementation BOSHEditorItemsView

+ (CGFloat)height
{
    return 64 + 48 + 5;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = YES;
        [self addFoldButton];
        [self configCollectionView];
    }
    return self;
}

- (void)addFoldButton
{
    self.foldButton = [[UIButton alloc] initWithFrame:CGRectMake((self.width - 48)/2, 0, 48, 48)];
    [self.foldButton addTarget:self action:@selector(foldAction) forControlEvents:UIControlEventTouchUpInside];
    [self.foldButton setImage:[UIImage imageNamed:@"editItems_fold"] forState:0];
    [self addSubview:self.foldButton];
}
- (void)configCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(64, 64);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 48, self.width - 20, 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
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
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    BOSHImageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"BOSHImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imageButton setTitle:titleArray[indexPath.item] forState:0];
    cell.layer.borderWidth = 3;
    cell.layer.borderColor = UIColorFromRGB(0xEE6363).CGColor;
    cell.layer.cornerRadius = 64/2;
    cell.clipsToBounds = YES;
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if(self.segmentActionHandler)
    {
        self.segmentActionHandler(indexPath.item +1);
    }
}



- (void)foldAction
{
    if(self.foldHandler) self.foldHandler();
}
@end
