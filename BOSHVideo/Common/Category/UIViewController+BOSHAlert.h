//
//  UIViewController+BOSHAlert.h
//  BOSHVideo
//
//  Created by yang on 2017/12/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BOSHAlert)

- (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles completion:(void(^)(int index))completionHandler;

@end
