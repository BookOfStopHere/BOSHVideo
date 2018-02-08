//
//  BOSHOverlayViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/12/11.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOSHOverlayTrack.h"
/**
 * 多模块之间共享 播放器得采用单例模式
 */
@interface BOSHOverlayViewController : BOSHBaseViewController

/**
 * @Input
 */
@property (nonatomic, strong) NSArray <BOSHOverlayTrack *>*inOverlayTracks;

/**
 * 输出
 */
@property (nonatomic, readonly) NSArray <BOSHOverlayTrack *>*outOverlayTracks;


//@property (nonatomic, strong) AVPlayerItem *


@end
