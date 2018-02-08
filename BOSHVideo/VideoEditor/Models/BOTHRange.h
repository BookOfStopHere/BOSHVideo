//
//  BOTHRange.h
//  BOSHVideo
//
//  Created by yang on 2017/11/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BOTHRange : NSObject
@property (nonatomic, assign) double start;
@property (nonatomic, assign) double duration;

+ (BOTHRange *)rangeWithStart:(double) start duration:(double)duration;

- (BOOL)containRange:(BOTHRange *)range;


- (BOTHRange *)intersectionWithRange:(BOTHRange *)range;

- (double)end;

@end
