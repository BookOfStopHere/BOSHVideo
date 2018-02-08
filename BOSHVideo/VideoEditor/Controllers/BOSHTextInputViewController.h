//
//  BOSHTextInputViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOSHOverlay.h"

@interface BOSHTextInputViewController : BOSHBaseViewController

@property (nonatomic, strong) BOSHTextOverlay *textOverlay;

@property (nonatomic, copy) void(^inputTextHandler)(BOSHTextOverlay *textOverlay);
@end
