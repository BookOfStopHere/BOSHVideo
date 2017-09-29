//
//  BOTHPlayerItem.h
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BOTHPlayerItem : NSObject

@property (nonatomic, copy) NSString *playURL;
@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, assign) CGSize videoSize;

@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) double endTime;

@property (nonatomic, assign) float speedRate;


@property (nonatomic, weak) id priv;

+ (BOTHPlayerItem *)defaultItem;

@end
