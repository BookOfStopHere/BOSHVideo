//
//  BOTHSingleEditorLayout.h
//  BOSHVideo
//
//  Created by yang on 2017/11/2.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOTHPlayerView.h"
#import "BOTHEditorRulerView.h"
#import "BOTHTimeView.h"
#import "BOTHButton.h"
@interface BOTHSingleEditorLayout : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton*backButton;
@property (nonatomic, strong) UIButton*rotateButton;
@property (nonatomic, strong) UIButton*cropButton;
@property (nonatomic, strong) UIButton*clipButton;
@property (nonatomic, strong) BOTHButton*addButton;
@property (nonatomic, strong) BOTHPlayerView *playerView;
@property (nonatomic, strong) BOTHEditorRulerView *rulerView;
@property (nonatomic, readonly, weak) UIViewController *contentVC;
@property (nonatomic, strong) BOTHTimeView  *timeLabel;

- (instancetype)initWithContentVC:(UIViewController *)contentVC;

- (UILabel *)titleLabel;

- (UIButton*)backButton;

- (UIButton*)rotateButton;

- (UIButton*)cropButton;

- (UIButton*)clipButton;

- (BOTHButton*)addButton;

- (BOTHEditorRulerView *)rulerView;

- (BOTHPlayerView *)playerView;

- (BOTHTimeView *)timeLabel;


///宽高比
- (void)setVideoRatio:(float)ratio;

@end
