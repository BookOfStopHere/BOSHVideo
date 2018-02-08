//
//  BOTHEditorRulerView.h
//  BOSHVideo
//
//  Created by yang on 2017/10/31.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
//固定6张图
typedef NS_ENUM(NSInteger, BOTHEditorRulerSlideState) {
    BOTHEditorRulerSlideIdle,
    BOTHEditorRulerSlideBegin,
    BOTHEditorRulerSlideMoving,
    BOTHEditorRulerSlideEnd
};

@interface BOTHEditorRulerView : UIView

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIView *leftMaskView;

@property (nonatomic, strong) UIView *rightMaskView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, assign) float leftProgress;
@property (nonatomic, assign) float rightProgress;
@property (nonatomic, assign) float middleProgress;

@property (nonatomic, copy) void(^sideSliderHandler)(BOTHEditorRulerSlideState state, float progress);
@property (nonatomic, copy) void(^middleSliderHandler)(BOTHEditorRulerSlideState state, float progress);


@property (nonatomic, assign) double min;
@property (nonatomic, assign) double max;

@property (nonatomic, assign) float limitDistance;//default 0


@property (nonatomic, copy) void(^cursorActionHandler)(int state, double progress);

- (void)setImages:(NSArray<UIImage *> *)images;

- (void)setSingleProgress:(double)progress;

- (UIImageView *)snapShot;

+ (CGFloat)preferHeight;
@end
