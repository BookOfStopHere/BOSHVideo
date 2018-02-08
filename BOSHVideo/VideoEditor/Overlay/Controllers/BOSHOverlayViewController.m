//
//  BOSHOverlayViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/12/11.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHOverlayViewController.h"
#import "BOSHProgressView.h"
#import "BOTHMacro.h"
#import "UIView+Geometry.h"
#import "BOSHOverlayCell.h"
#import "BOTHBlockView.h"
#import "UIView+Geometry.h"
#import "BOSHDefines.h"
#import "BOSHHomeLayoutManager.h"
#import "MMDrawerController.h"
#import "BOTHMacro.h"
#import "BOTHVideoPickerController.h"
#import "BOTHEditorRulerView.h"
#import "BOTHSegmentEditorViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BOSHProgressView.h"
#import "BOTHPlayerView.h"
#import "BOSHProgressView.h"
#import "BOTHButton.h"
#import "BOSHTimelineViewController.h"

@interface BOSHOverlayViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BOSHProgressView *progressView;
@property (nonatomic, strong) BOTHPlayerView *playerView;
@end

@implementation BOSHOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerBar.backgroundColor = UIColorFromRGB(0x101010);
    self.headerBar.leftItemHidden = NO;
    
    @weakify(self);
    [self.headerBar setLeftActionHandler:^{
        [weakself dismissSelf];
    }];
    // Do any additional setup after loading the view.
//    [self addProgress];
    [self addPlayer];
    [self addTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPlayer
{
//    BOSHProgressView *progressView = [[BOSHProgressView alloc] initWithFrame:CGRectMake(0, kNAVIGATIONH, self.view.width , [BOSHProgressView preferHeight])];
//    [self.view addSubview:progressView];
//    _progressView = progressView;
//    progressView.backgroundColor = UIColorFromRGB(0x101010);
    
    //目前为了快速出第一版本支持方的视频 如苹果clips
    CGFloat maxPlayH = self.view.height - self.progressView.bottom - 64;
    CGRect playerRect = CGRectMake(0, self.progressView.bottom + (maxPlayH - self.view.width)/2, self.view.width, self.view.width);
    BOTHPlayerView *playerView = [[BOTHPlayerView alloc] initWithFrame:playerRect];
    playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:playerView];
    [self.view  sendSubviewToBack:playerView];
    _playerView = playerView;
    [playerView setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)addProgress
{
    self.progressView = [[BOSHProgressView alloc] initWithFrame:CGRectMake(0, BOSHHeaderBarH + BOSHScreenW, BOSHScreenW, [BOSHProgressView preferHeight])];
    [self.view addSubview:self.progressView];
}

- (void)addTable
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.progressView.bottom, BOSHScreenW, BOSHScreenH - self.progressView.bottom) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:BOSHOverlayCell.class forCellReuseIdentifier:@"BOSHOverlayCell"];
    [self.view addSubview:_tableView];
}


#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.outOverlayTracks.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOSHOverlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BOSHOverlayCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
