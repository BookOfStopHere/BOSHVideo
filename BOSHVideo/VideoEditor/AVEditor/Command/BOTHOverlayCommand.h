//
//  BOTHOverlayCommand.h
//  BOSHVideo
//
//  Created by yang on 2017/10/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>
#import "BOTHCommand.h"

/**
 * 目前先固定几种Overlay，字体固定、样式、渐变效果等
 * 支持加字幕、简单水印
 */

@interface BOTHOverlayCommand : BOTHCommand

@property (nonatomic) CMTimeRange timeRange;
@property (nonatomic) CMTime duration;
@property (nonatomic) CALayer *layer;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) UIImage *image;


/**
 * 文字Overlay
 */
+ (BOTHOverlayCommand *)addOverlayWithText:(NSString *)text inRect:(CGRect)rect fromStartTime:(float)start toEndTime:(float)end;

/**
 * 图片Overlay (文／图)
 */
+ (BOTHOverlayCommand *)addOverlayWithImage:(UIImage *)image inRect:(CGRect)rect fromStartTime:(float)start toEndTime:(float)end;

@end
