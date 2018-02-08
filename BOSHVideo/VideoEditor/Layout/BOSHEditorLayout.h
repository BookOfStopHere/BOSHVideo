//
//  BOSHEditorLayout.h
//  BOSHVideo
//
//  Created by yang on 2017/11/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
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
#import "BOSHOverlay.h"
#import "BOSHProgressView.h"
#import "BOTHPlayerView.h"
#import "BOSHProgressView.h"
#import "BOTHButton.h"
#import "BOSHTimelineViewController.h"

@interface BOSHEditorLayout : NSObject
@property (nonatomic, readonly, weak) UIViewController *contentVC;
@property (nonatomic, strong) BOTHPlayerView *playerView;
@property (nonatomic, strong) BOSHProgressView *progressView;

@property (nonatomic, strong) BOTHButton *backButton;
@property (nonatomic, strong) BOTHButton *ackButton;
@property (nonatomic, strong) BOTHButton *filterButton;
@property (nonatomic, strong) BOTHButton *editButton;
@property (nonatomic, strong) BOTHButton *audioButton;
@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) BOTHButton *overlayButton;
@property (nonatomic, strong) BOSHTimelineViewController *timelineVC;

- (instancetype)initWithContentVC:(UIViewController *)contentVC;

- (void)setVideoRatio:(float)ratio;
@end
