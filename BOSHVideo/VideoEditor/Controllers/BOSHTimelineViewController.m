//
//  BOSHTimelineViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/11/13.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTimelineViewController.h"
//#import "EasyTableView.h"
#import "UIView+Geometry.h"
#import "BOSHTimelineDataSource.h"
#import "BOSHVideoItem.h"
#import "BOSHVideoTrack.h"
#import "BOSHTransitonInstruction.h"
#import "BOSHSingleRowCollectionViewLayout.h"
#import "BOSHTransitionSelectionView.h"
#import "BOSHOverlayViewController.h"
#import "BOSHEditorItemsView.h"

@interface BOSHTimelineViewController ()
{
    BOSHVideoItem *media;
    NSMutableArray *array;
    CGRect _rect;
    CAShapeLayer *shapeLayer;
    
    UIView *snapView;
    NSIndexPath *originalCellIndexPath;
}
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BOSHTimelineDataSource *dataSource;
@property (nonatomic, strong) NSMutableArray *viewModels;
@property (nonatomic, strong) UIButton *addButton;//添加视频
@property (nonatomic,  strong) UIView *line;
@property (nonatomic, strong) BOSHSingleRowCollectionViewLayout *layout;
@property (nonatomic, strong) BOSHTransitionSelectionView *tSelectView;
@property (nonatomic, strong) BOSHEditorItemsView *editorItemView;
//需要记录当前所有的Trasntion类型
//需

@end

@implementation BOSHTimelineViewController


- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super init])
    {
        _rect = frame;
    }
    return self;
}


- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:_rect];
    self.view.backgroundColor = UIColorFromRGBA(0x101010,.35);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 10, 0, 60, 44)];
//    [self.rightBtn setTitle:@"确定" forState:0];
//    [self.view addSubview:self.rightBtn];
//    [self.rightBtn addTarget:self action:@selector(ackHandler) forControlEvents:UIControlEventTouchUpInside];

    
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 50, self.view.height - 64, 50, 64)];
    [self.addButton setImage:[UIImage imageNamed:@"more_editor"] forState:0];
    [self.view addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64, self.view.width, 0.5)];
    self.line.backgroundColor = UIColorFromRGB(0xD1D1D1);
    [self.view addSubview:self.line];
    
//    [self addCollectionView];
    
    
    BOSHSingleRowCollectionViewLayout *layout = [BOSHSingleRowCollectionViewLayout new];
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5,self.view.height - 5  - BOSH_PER_SECOND_WIDTH, self.view.width - 5 - 50, BOSH_PER_SECOND_WIDTH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    self.dataSource = [BOSHTimelineDataSource dataSourceWithTarget:_collectionView];
    [self.collectionView  reloadData];
    
    @weakify(self);
    [self.dataSource setClickActionHandler:^(NSIndexPath *index) {
//        [weakself showTransitonSelectionView];
//        [weakself showEditorItemView];
        if(weakself.segmentActionHandler)
        {
            weakself.segmentActionHandler(BOSHTimelineActionAddGIF);
        }
    }];
}

- (void)showTransitonSelectionView
{
    if(self.tSelectView)
    {
        [self.tSelectView removeFromSuperview];
        self.tSelectView = nil;
    }
    CGRect frame = self.view.bounds;
    frame.origin.x += frame.size.width;
    self.tSelectView = [[BOSHTransitionSelectionView alloc] initWithFrame:frame];
    self.tSelectView.backgroundColor = UIColorFromRGB(0x101010);
    [self.view addSubview:self.tSelectView];
     @weakify(self);
    CGRect oFrame = frame;
    [self.tSelectView setSelectActionHandler:^(BOSHTransitionType type) {
        [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            weakself.tSelectView.frame = oFrame;
        } completion:^(BOOL finished) {
            [weakself.tSelectView removeFromSuperview];
            weakself.tSelectView = nil;
        }];
    }];
    
    
    frame = self.view.bounds;
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakself.tSelectView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BOSHCollectionViewCell" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:9909];
    if(!label)
    {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.tag = 9909;
        [cell addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"%d",indexPath.item];
    
    cell.layer.borderColor = [UIColor redColor].CGColor;
    cell.layer.borderWidth = 2;
    
    return cell;
}



- (BOSHTimelineAsset *)timelineAsset
{
    return nil;//实时
}
#pragma mark actions
- (void)ackHandler
{
    [self dismissSelf];
}

//更多选项
- (void)moreAction
{
    //调起相册浏览器
    
    BOSHOverlayViewController *overlay = [BOSHOverlayViewController new];
    
}

- (NSMutableArray *)viewModels
{
    if(!_viewModels)
    {
        _viewModels = [NSMutableArray array];
    }
    return _viewModels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)addCollectionView
//{
//    BOSHSingleRowCollectionViewLayout *layout = [BOSHSingleRowCollectionViewLayout new];
//    layout.delegate = self;
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5,self.view.height - 5  - BOSH_PER_SECOND_WIDTH, self.view.width - 5 - 50, BOSH_PER_SECOND_WIDTH) collectionViewLayout:layout];
//    _collectionView.backgroundColor = [UIColor clearColor];
//    [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"BOSHCollectionViewCell"];
//    [self.view addSubview:_collectionView];
//        [_collectionView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)]];
//        _collectionView.delegate = _collectionView.dataSource = self;
//}
//- (UICollectionView *)table
//{
//    if(!_table)
//    {
//        BOSHSingleRowCollectionViewLayout *layout = [BOSHSingleRowCollectionViewLayout new];
//        layout.delegate = self;
//        _table = [[UICollectionView alloc] initWithFrame:CGRectMake(5,self.view.height - 5  - BOSH_PER_SECOND_WIDTH, self.view.width - 5 - 50, BOSH_PER_SECOND_WIDTH) collectionViewLayout:layout];
//        _table.backgroundColor = [UIColor clearColor];
//        [_table registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"BOSHCollectionViewCell"];
//        [self.view addSubview:_table];
//    }
//    return _table;
//}

- (void)addVideo:(BOSHVideoItem *)video
{
    [self.viewModels addObject:video];
    for(int ii =0; ii < 10; ii ++)
        [_dataSource addVideo:video];
    
    [_collectionView reloadData];
}

#pragma mark UILongPressGestureRecognizer
// 长按则进入删除模式
- (void)longPressHandler:(UILongPressGestureRecognizer *)longPress
{
    CGPoint location = [longPress locationInView:longPress.view];
    NSIndexPath *indexPath =  [self.collectionView indexPathForItemAtPoint:location];
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        
//        UICollectionViewCell *cell = [self.table cellForItemAtIndexPath:indexPath];
//        if(cell)
//        {
//            snapView = [cell snapshotViewAfterScreenUpdates:YES];
//            snapView.center = cell.center;
//
////            shapeLayer = [CAShapeLayer layer];
////            shapeLayer.strokeColor = [UIColor redColor].CGColor;
////            shapeLayer.fillColor = [UIColor blackColor].CGColor;
////            shapeLayer.lineWidth = 5;
////            shapeLayer.lineJoin = kCALineJoinRound;
////            shapeLayer.lineCap = kCALineCapRound;
////
////            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.contentView.layer.bounds cornerRadius:10];
////            shapeLayer.path = path.CGPath;
////            shapeLayer.lineDashPattern = @[@6, @10];//画虚线
////            //add it to our view
////            [ cell.contentView.layer addSublayer:shapeLayer];
////            cell.contentView.layer;
//            cell.alpha = 0;
//            [self.table addSubview:snapView];
//            originalCellIndexPath = indexPath;
//            _dataSource.isEditing = YES;
//        }
//        [_table reloadData];
        NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
        if (index == nil) {
            return;
        }
        
        
        BOOL isYES = [self.collectionView beginInteractiveMovementForItemAtIndexPath:index];
        NSLog(@"————————————isYES %d",isYES);
    }
    else if(longPress.state == UIGestureRecognizerStateChanged)
    {
//        if(indexPath)
//        {
//            snapView.center = location;
////            [self.dataSource movItemAtIndexPath:originalCellIndexPath toIndexPath:indexPath];
////            [self.table moveItemAtIndexPath:originalCellIndexPath toIndexPath:indexPath]; // swaps cells
////            originalCellIndexPath = indexPath;
//        }
        
        [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
    }
    else if(longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled)
    {
//        [self.dataSource movItemAtIndexPath:originalCellIndexPath toIndexPath:indexPath];
//        [self.table moveItemAtIndexPath:originalCellIndexPath toIndexPath:indexPath]; // swaps cells
        [self.collectionView endInteractiveMovement];
//        UICollectionViewCell *cell = [self.table cellForItemAtIndexPath:indexPath];
//        cell.alpha = 1;
//        [shapeLayer removeFromSuperlayer];
//        [snapView removeFromSuperview];
    }
    else
    {
        [self.collectionView cancelInteractiveMovement];
    }
}

@end
