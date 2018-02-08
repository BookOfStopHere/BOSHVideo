//
//  BOSHTimelineDataSource.m
//  BOSHVideo
//
//  Created by yang on 2017/11/13.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTimelineDataSource.h"
#import "UIView+Geometry.h"
#import "BOSHVideoTrackCell.h"
#import "BOSHVideoTrack.h"
#import "BOSHTransitionCell.h"
#import "BOSHVideoItem.h"
#import "BOSHCollectionViewCell.h"
#import "BOSHTrack.h"

/***
 * 如果当前videotrack 移动或者被删除则将instruction 设置成none
 */
static NSString *cell_BOSHVideoTrackCell_ID = @"cell_BOSHVideoTrackCell_ID";
static NSString *cell_BOSHTransitionCell_ID = @"cell_BOSHTransitionCell_ID";

@interface BOSHTimelineDataSource () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray <BOSHTrack *>*timelineModel;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray <BOSHVideoTrack *> *videoTracks;
@property (nonatomic, strong) NSMutableArray <BOSHTransitonInstruction *> *instructions;
@property (nonatomic) CMTime lastTime;//
@end

@implementation BOSHTimelineDataSource


- (NSMutableArray *)timelineModel
{
    if(!_timelineModel)
    {
        _timelineModel = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _timelineModel;
}

+ (id)dataSourceWithTarget:(UICollectionView *) table
{
    return [[self alloc] initWithTarget:table];
}

- (instancetype)initWithTarget:(UICollectionView *) table
{
    self = [super init];
    if(self)
    {
        self.table = table;
        self.table.delegate = self;
        self.table.dataSource = self;
        ((BOSHSingleRowCollectionViewLayout*)self.table.collectionViewLayout).delegate = self;
        [self registerCellForTable];
        self.selectIndex = -1;//in
        self.videoTracks = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

- (void)setTimelineModels:(NSArray <BOSHTrack *>*)timelineModels
{
    if(timelineModels.count > 0)
    {
        [self.timelineModel  removeAllObjects];
        [self.timelineModel addObjectsFromArray:timelineModels];
    }
}

- (void)movItemAtIndexPath:(NSIndexPath *)fromIndex toIndexPath:(NSIndexPath *)toIndex
{
    if(fromIndex == nil || toIndex == nil) return;
    
    NSString *origin = self.timelineModel[fromIndex.item];
    if(toIndex.item < fromIndex.item)
    {
        [self.timelineModel removeObjectAtIndex:fromIndex.item];
        [self.timelineModel insertObject:origin atIndex:toIndex.item];
    }
    else
    {
        [self.timelineModel removeObjectAtIndex:fromIndex.item];
        [self.timelineModel insertObject:origin atIndex:toIndex.item -1];
    }
}
//主要用于更改时间线
- (void)refreshTimeline
{
    //不断需要更新的地方 考虑到过渡动画
    CMTime startTime = kCMTimeZero;
    for(int ii = 0; ii < self.videoTracks.count; ii++)
    {
        BOSHVideoTrack *track = self.videoTracks[ii];
        track.startTime = startTime;
        track.endTime = CMTimeAdd(startTime, track.media.timeRange.duration);
        startTime = track.endTime;
        if((ii +1 ) < self.videoTracks.count)
        {
            BOSHTransitonInstruction *ins = self.instructions[ii];//
            startTime = CMTimeSubtract(startTime, CMTimeMake(ins.animationDuration, startTime.timescale));
        }
        //增加视频
    }
}

- (void)movVideoTrack:(BOSHVideoTrack *)track toIndex:(NSUInteger)index
{
    //
    NSInteger index0 = [self.videoTracks indexOfObject:track];
    if(index0 == index) return;
    
//    if(index == 0)
//    {
//        BOSHTransitonInstruction *ins = self.instructions[index0 -1];
//        [self.instructions insertObject:[BOSHTransitonInstruction instruction] atIndex:MAX(0,index -1)];
//        [self.instructions removeObject:ins];
//    }
    [self.videoTracks insertObject:track atIndex:index];
    [self.videoTracks removeObjectAtIndex:index0];
}

- (void)deleteVideoTrack:(BOSHVideoTrack *)track
{
    NSInteger index = [self.videoTracks indexOfObject:track];
    if(index +1 < self.videoTracks.count)
    {
       if(index == 0)
       {
           [self.instructions removeObjectAtIndex:0];
       }
        else
        {
             [self.instructions removeObjectAtIndex:index -1];
        }
    }
}


- (void)setVideoTracks:(NSArray <BOSHVideoTrack *> *)videTracks instructions:(NSArray <BOSHTransitonInstruction *> *)ins
{
    NSMutableArray *array = [NSMutableArray array];
    for(int ii = 0; ii < self.videoTracks.count; ii ++)
    {
        [array addObject:self.videoTracks[ii]];
        if((ii + 1) < self.videoTracks.count && self.instructions.count)
        {
            [array addObject:self.instructions[ii]];
        }
    }
}

- (void)addVideo:(BOSHVideoItem *)video
{
    if(video)
    {
        //增加视频分
        //创建VideoTrack +  transitonInstruction
        if(self.videoTracks.count)
        {
            BOSHTransitonInstruction *ins = [BOSHTransitonInstruction instruction];
            [self.instructions addObject:ins];
        }
        //增加视频
        BOSHVideoTrack *track = [BOSHVideoTrack videoTrackWithMediaItem:video atTime:self.lastTime];
        [self.videoTracks addObject:track];
        self.lastTime = CMTimeAdd(self.lastTime, video.timeRange.duration);
    }
}


- (BOSHTimelineAsset *)timelineAsset
{
    BOSHTimelineAsset *asset =  [BOSHTimelineAsset defaultTimelineAsset];
    asset.videos = [NSArray arrayWithArray:self.videoTracks];
    asset.transations = [NSArray arrayWithArray:self.instructions];
    return asset;
}

////tableview 数据填充
//#pragma mark------------------------------------------------
//
- (void)registerCellForTable
{
//    for(BOSHTrack *item in self.timelineModel)
//    {
////        NSString *identifier = [self getCellIdentifierWithData:item];
////        [self.table.tableView registerClass: [self cellClassForIdentifier:identifier] forCellReuseIdentifier:identifier];
//    }
    
    [self.table registerClass:BOSHCollectionViewCell.class forCellWithReuseIdentifier:@"BOSHCollectionViewCell"];
}
//
- (Class)cellClassForIdentifier:(NSString *)Identifier
{
    if([Identifier isEqualToString:cell_BOSHVideoTrackCell_ID])
    {
        return BOSHVideoTrackCell.class;
    }
    if([Identifier isEqualToString:cell_BOSHTransitionCell_ID])
    {
        return BOSHTransitionCell.class;
    }
     return BOSHVideoTrackCell.class;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.selectIndex = indexPath.item;
    if(self.clickActionHandler)
    {
        self.clickActionHandler(indexPath);
    }
    [collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoTracks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOSHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BOSHCollectionViewCell" forIndexPath:indexPath];
    if(indexPath.item %2 == 0)
    {
        cell.gifImageView.image = ((BOSHVideoTrack *)self.videoTracks[indexPath.item/2]).media.thumbnail[0];
    }
    else
    {
        cell.gifImageView.image = nil;
    }
    if(indexPath.item == self.selectIndex)
    {
        [cell setSelected:YES];
    }
    else
    {
        [cell setSelected:NO];
    }
    return cell;
}

- (CGFloat)layout:(BOSHSingleRowCollectionViewLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  (indexPath.item %2) ? 30 : 54;
}

- (CGFloat)layout:(BOSHSingleRowCollectionViewLayout *)layout widthForColumnAtIndexPath:(NSIndexPath *)indexPath
{
    return  ( indexPath.item %2) ? 30 : 54;
}

- (NSInteger)numberOfColumnsForLayout:(BOSHSingleRowCollectionViewLayout *)layout
{
    return self.videoTracks.count;
}

//编辑状态
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//- (BOOL)collectionView:(UICollectionView *)collectionView dragSessionAllowsMoveOperation:(id<UIDragSession>)session
//{
//    return YES;
//}



@end
