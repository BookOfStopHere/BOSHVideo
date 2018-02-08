//
//  OverlayContainer.h
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOSHOverlayTrack.h"
#import "BOSHDefines.h"
#import "BOTHPlayerView.h"
/**
 * 支持基于中心点的放大 (热区在边角位置)
 * 支持拖动 （拖动热区在中间区域)
 * 目前支持移动以及X掉
 * overlay 与 container 同处于一个中心点
 */
@interface OverlayContainer : UIControl
//32x32
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) BOSHOverlayTrack *overlayTrack;//添加的

@property (nonatomic, strong) AVPlayerItem *playerItem;


- (instancetype)init;



- (void)addOverlayTrack:(BOSHOverlayTrack *)overlayTrack;


@end
