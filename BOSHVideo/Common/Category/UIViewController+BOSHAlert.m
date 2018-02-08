//
//  UIViewController+BOSHAlert.m
//  BOSHVideo
//
//  Created by yang on 2017/12/4.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "UIViewController+BOSHAlert.h"
#import "NYAlertViewController.h"

@implementation UIViewController (BOSHAlert)

- (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles completion:(void(^)(int index))completionHandler
{

    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] init];
    
    // Set a title and message
    alertViewController.title = title;
    alertViewController.message = message;
    
    // Customize appearance as desired
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:19.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    
    // Add alert actions
    if(otherButtonTitles)
    {
        [alertViewController addAction:[NYAlertAction actionWithTitle:otherButtonTitles
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(NYAlertAction *action) {
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                      if(completionHandler) completionHandler(1);
                                                                  }];
                                                              }]];
    }
    
    if(cancelButtonTitle)
    {
        [alertViewController addAction:[NYAlertAction actionWithTitle:cancelButtonTitle
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(NYAlertAction *action) {
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                      if(completionHandler) completionHandler(0);
                                                                  }];
                                                              }]];
    }
    
    // Present the alert view controller
    [self presentViewController:alertViewController animated:YES completion:nil];
    
}


@end
