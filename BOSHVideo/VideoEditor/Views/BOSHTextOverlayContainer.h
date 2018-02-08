//
//  BOSHTextOverlayContainer.h
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "OverlayContainer.h"
@interface BOSHTextOverlayContainer : OverlayContainer
@property (nonatomic, strong) UITextView *textView;

- (void)showKeyborad;
- (void)dismissKeyborad;

@end
