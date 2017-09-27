//
//  QNNavigationViewController.m
//  QYVerticalNews
//
//  Created by JU CHANGLONG on 16/8/16.
//  Copyright © 2016年 iQiYi. All rights reserved.
//

#import "QNNavigationViewController.h"

#import "QNBaseViewController.h"
#import <objc/runtime.h>
#import "QNMacros.h"
#import "QNFeedShare.h"

@interface QNPullDownMaskView : UIView
@end

@implementation QNPullDownMaskView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end

@interface _FDFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation _FDFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.fd_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

@end

//pull down gesture delegate
@interface _QNPulldownGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) UIPanGestureRecognizer *pullDownGesture;
@end

@implementation _QNPulldownGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if(topViewController.qn_popDirection != QNFullscreenPopDirectionBottomOut)
    {
        return NO;
    }
    if (((QNNavigationViewController *)self.navigationController).is_qn_pulldownTransition ) {
        return NO;
    }
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.y > 0 && translation.x <= 0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == self.pullDownGesture && [otherGestureRecognizer.view isDescendantOfView:self.navigationController.topViewController.view])
    {
         return [self.navigationController.topViewController shouldRecognizePulldownGestureSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}
//以后做事件分发操作 利用UIResoponse 进行实现即可
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isDescendantOfView:self.navigationController.topViewController.view])
    {
        return [touch.view dispatchPullDownGesture:(id )gestureRecognizer toResponder:(id)touch.view];
    }
    return NO;
}

@end


@implementation  UIResponder (QNPullDownGestureDispatch)

- (BOOL)dispatchPullDownGesture:(UIPanGestureRecognizer *)pullDownGesture toResponder:(UIResponder *)responder
{
    if(self.nextResponder && [self.nextResponder respondsToSelector:@selector(dispatchPullDownGesture:toResponder:)])
    {
        return [self.nextResponder dispatchPullDownGesture:pullDownGesture toResponder:responder];
    }
    return YES;
}

@end


typedef void (^_FDViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (FDFullscreenPopGesturePrivate)

@property (nonatomic, copy) _FDViewControllerWillAppearInjectBlock fd_willAppearInjectBlock;

@end

@implementation UIViewController (FDFullscreenPopGesturePrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(fd_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)fd_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self fd_viewWillAppear:animated];
    
    if (self.fd_willAppearInjectBlock) {
        self.fd_willAppearInjectBlock(self, animated);
    }
}

- (_FDViewControllerWillAppearInjectBlock)fd_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFd_willAppearInjectBlock:(_FDViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(fd_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


@implementation UIViewController (FDFullscreenPopGesture)

- (BOOL)fd_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(fd_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fd_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(fd_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)fd_interactivePopMaxAllowedInitialDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    SEL key = @selector(fd_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (QNFullscreenPopDirection)

- (void)setQn_popDirection:(QNFullscreenPopDirection)qn_popDirection
{
    objc_setAssociatedObject(self, @selector(qn_popDirection), @(qn_popDirection), OBJC_ASSOCIATION_ASSIGN);
}

- (QNFullscreenPopDirection)qn_popDirection
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)shouldRecognizePulldownGestureSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (BOOL) isContainerPlayer
{
    return NO;
}

- (void) clearPlayerWhenPulldown
{
    //@override
}

- (void) rebootPlayerWhenPulldownCancelled
{
    //@override
}

@end

@interface QNNavigationViewController ()
@property (nonatomic, assign) BOOL internal_is_qn_pulldownTransition;
@end

@implementation QNNavigationViewController
{
    CGPoint startPoint;
    UIViewController *lastVC;
}

//- (BOOL)shouldAutorotate{
//    
//    return NO;
////    BOOL should = [self.viewControllers.lastObject shouldAutorotate];
////    
////    return should;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
////    UIInterfaceOrientationMask should = [self.viewControllers.lastObject supportedInterfaceOrientations];
////    
////    return should;
//}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if(![self.viewControllers lastObject]){
        return UIInterfaceOrientationMaskPortrait;
    }
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    if(![self.viewControllers lastObject]){
        return UIInterfaceOrientationPortrait;
    }
    
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

+ (void)load
{
    // Inject "-pushViewController:animated:"
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(fd_pushViewController:animated:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

- (void)fd_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fd_fullscreenPopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.fd_fullscreenPopGestureRecognizer.delegate = self.fd_popGestureRecognizerDelegate;
        [self.fd_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self addPulldownGestureWithVC:viewController];//by yang
    // Handle perferred navigation bar appearance.
    [self fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    if (![self.viewControllers containsObject:viewController]) {
        [self fd_pushViewController:viewController animated:animated];
    }
}

- (void)addPulldownGestureWithVC:(UIViewController *)viewController
{
    if(viewController.qn_popDirection == QNFullscreenPopDirectionBottomOut)//when make setting that flow from bottom
    {
        if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.qn_pulldownGestureRecognizer])
        {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.qn_pulldownGestureRecognizer];
            [self.qn_pulldownGestureRecognizer addTarget:self action:@selector(qn_pulldownHandlePan:)];
            self.qn_pulldownGestureRecognizer.delegate = self.qn_pulldownGestureRecognizerDelegate;
            self.qn_pulldownGestureRecognizerDelegate.pullDownGesture = self.qn_pulldownGestureRecognizer;
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
//    else
//    {
//        if ([self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.qn_pulldownGestureRecognizer])
//        {
//            [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.qn_pulldownGestureRecognizer];
//        }
//    }
}
- (void)fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.fd_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _FDViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.fd_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.fd_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.fd_willAppearInjectBlock) {
        disappearingViewController.fd_willAppearInjectBlock = block;
    }
}

- (_FDFullscreenPopGestureRecognizerDelegate *)fd_popGestureRecognizerDelegate
{
    _FDFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[_FDFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)fd_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (BOOL)fd_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    //    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
    return NO;
}

- (void)setFd_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(fd_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark 下滑关闭

- (UIPanGestureRecognizer *)qn_pulldownGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (_QNPulldownGestureRecognizerDelegate *)qn_pulldownGestureRecognizerDelegate
{
    _QNPulldownGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[_QNPulldownGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIView *)qn_pulldownMaskView
{
    UIView *maskView = objc_getAssociatedObject(self, _cmd);
    
    if (!maskView) {
        maskView = [[QNPullDownMaskView alloc] initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
        objc_setAssociatedObject(self, _cmd, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        maskView.backgroundColor = UIColorFromRGBA(0x0,0.3);
    }
    return maskView;
}


- (void)qn_pulldownHandlePan:(UIPanGestureRecognizer *)pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        self.internal_is_qn_pulldownTransition = YES;
        startPoint = [pan locationInView:pan.view];
        lastVC = self.topViewController;
        [self popViewControllerAnimated:NO];
        CGRect frame = lastVC.view.frame;
        frame.origin.x = frame.origin.y = 0;
        lastVC.view.frame = frame;
        self.qn_pulldownMaskView.alpha = 1.0;
        [self.topViewController.view addSubview:self.qn_pulldownMaskView];
        [self.topViewController.view addSubview:lastVC.view];
        if([lastVC isContainerPlayer])
        {
            [lastVC clearPlayerWhenPulldown];
            [QNFeedShare shareInstance].start_pull = YES;
        }
    }
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint location = [pan locationInView:pan.view];
        CGFloat dy = location.y - startPoint.y;
        if(dy <=0 ) return;
        CGRect frame = lastVC.view.frame;
        frame.origin.y = dy;
        lastVC.view.frame = frame;
        [pan setTranslation:CGPointZero inView:self.fd_fullscreenPopGestureRecognizer.view];
    }
    if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed)
    {
        weakObj(self);
        if(fabsf(lastVC.view.frame.origin.y) > QNMainH*0.2)
        {
            __block CGRect frame = lastVC.view.frame;
            weakObj(lastVC);
            [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                frame.origin.y = QNMainH;
                weaklastVC.view.frame = frame;
            } completion:^(BOOL finished) {
                [weaklastVC.view removeFromSuperview];
                
                [UIView beginAnimations:@"closeMaskView" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:.35];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(showLoadingDidStop:finished:context:)];
                weakself.qn_pulldownMaskView.alpha = 0.0;
                [UIView commitAnimations];
                
                [QNFeedShare shareInstance].start_pull = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qn_pull_down_end" object:nil userInfo:nil];
                 weakself.internal_is_qn_pulldownTransition = NO;
                lastVC = nil;
            }];
        }
        else
        {
            __block CGRect frame = lastVC.view.frame;
            weakObj(lastVC);
            [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                frame.origin.y = 0;
                weaklastVC.view.frame = frame;
            } completion:^(BOOL finished) {
                [weakself.qn_pulldownMaskView removeFromSuperview];
                [weaklastVC.view removeFromSuperview];
                [weakself pushViewController:weaklastVC animated:NO];
                if([weaklastVC isContainerPlayer])
                {
                    [weaklastVC rebootPlayerWhenPulldownCancelled];
                }
                
                [QNFeedShare shareInstance].start_pull = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qn_pull_down_end" object:nil userInfo:nil];
                weakself.internal_is_qn_pulldownTransition = NO;
                lastVC = nil;
            }];
        }
    }
}

- (BOOL) is_qn_pulldownTransition
{
    return _internal_is_qn_pulldownTransition;
}
#pragma mark loadingview delegate
- (void)showLoadingDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self.qn_pulldownMaskView removeFromSuperview];
}

#pragma mark statusbar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    return [self.topViewController prefersStatusBarHidden];
}
@end
