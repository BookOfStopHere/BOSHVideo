//
//  QNNavigationViewController.h
//  QYVerticalNews
//
//  Created by JU CHANGLONG on 16/8/16.
//  Copyright © 2016年 iQiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNNavigationViewController : UINavigationController

/// The gesture recognizer that actually handles interactive pop.
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *fd_fullscreenPopGestureRecognizer;

/// A view controller is able to control navigation bar's appearance by itself,
/// rather than a global way, checking "fd_prefersNavigationBarHidden" property.
/// Default to YES, disable it if you don't want so.
@property (nonatomic, assign) BOOL fd_viewControllerBasedNavigationBarAppearanceEnabled;
//下拉退出
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *qn_pulldownGestureRecognizer;

@property (nonatomic, strong, readonly) UIView *qn_pulldownMaskView;

@property (nonatomic, assign, readonly) BOOL is_qn_pulldownTransition;
@end

/// Allows any view controller to disable interactive pop gesture, which might
/// be necessary when the view controller itself handles pan gesture in some
/// cases.
@interface UIViewController (FDFullscreenPopGesture)

/// Whether the interactive pop gesture is disabled when contained in a navigation
/// stack.
@property (nonatomic, assign) BOOL fd_interactivePopDisabled;

/// Indicate this view controller prefers its navigation bar hidden or not,
/// checked when view controller based navigation bar's appearance is enabled.
/// Default to NO, bars are more likely to show.
@property (nonatomic, assign) BOOL fd_prefersNavigationBarHidden;

/// Max allowed initial distance to left edge when you begin the interactive pop
/// gesture. 0 by default, which means it will ignore this limit.
@property (nonatomic, assign) CGFloat fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;


@end
//pop direction definition
typedef NS_ENUM(NSInteger, QNFullscreenPopDirection) {
    QNFullscreenPopDirectionRightOut = 0,//default
//    QNFullscreenPopDirectionLeftOut, //左边滑出 //TODO
    QNFullscreenPopDirectionBottomOut,//下边滑动出
};
//add by yang
@interface UIViewController (QNFullscreenPopDirection)

//pop top viewcontroller from which direction. default pop from right
@property (nonatomic, assign) QNFullscreenPopDirection qn_popDirection;
//when pan gestures conflict, indicate whether response to pull down gesture
- (BOOL)shouldRecognizePulldownGestureSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
//whether VC contains player
- (BOOL) isContainerPlayer;
//clear player from VC
- (void) clearPlayerWhenPulldown;
//reboot player when Pulldown is cancelled
- (void) rebootPlayerWhenPulldownCancelled;
@end


@interface UIResponder (QNPullDownGestureDispatch)

- (BOOL)dispatchPullDownGesture:(UIPanGestureRecognizer *)pullDownGesture toResponder:(UIResponder *)responder;

@end
