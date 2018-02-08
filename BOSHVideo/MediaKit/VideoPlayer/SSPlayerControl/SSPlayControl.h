//
//  SSPlayControl.h
//  SSPlayer
//
//  Created by 1 on 16/12/25.
//  Copyright © 2016年 SSPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSProgressBar.h"

@interface SSPlayControl : UIView

@property (nonatomic, strong) SSProgressBar *progressBar;
@property (nonatomic, assign) BOOL isFull;
@end
