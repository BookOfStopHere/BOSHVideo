//
//  BOTHEditorViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/10/18.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOSHMediaItem.h"
#import "BOSHVideoItem.h"

/**
 * 主要的编辑功能的VC
 * 支持固定分辨率 （16:9 4: 3 1:1）
 * 第一版本支持 1:1 的视频
 * 目前支持720 x 720 的视频
 */

@interface BOTHEditorViewController : BOSHBaseViewController

@property (nonatomic, strong) BOSHMediaItem *iMedia;
@property (nonatomic, strong) BOSHVideoItem *videoItem;
@end
