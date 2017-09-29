//
//  BOSHHomeLayoutManager.h
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BOSHHomeLayoutManager : NSObject

@property (nonatomic, weak) UIView *containerView;


- (instancetype)initWithTarget:(UIView *)target model:(NSArray <NSString *> *)stringSets;

@end
