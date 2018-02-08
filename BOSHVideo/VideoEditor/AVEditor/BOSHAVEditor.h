//
//  BOSHAVEditor.h
//  BOSHVideo
//
//  Created by yang on 2017/10/18.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AVFoundation/AVFoundation.h>
#import "BOSHTimelineAsset.h"

/**
 * 仅支持顺序线性添加的Timeline，不支持比如画中画
 * 仅支持针对所有配音的音量平衡
 * 仅支持简单的Overlay，后续添加复杂的Overlay 需要OpenGLES
 * 仅支持系统提供的几种编码方式 AAC m4a  AVC
 * 
 */

@interface BOSHAVEditor : NSObject

@property (nonatomic, assign) CMTime duration;


+ (id)editorWithTimelineAsset:(BOSHTimelineAsset *)timelineAsset;

- (void)buildComposition;

- (AVPlayerItem *)playItem;

- (AVAssetExportSession*)assetExportSessionWithPreset:(NSString*)presetName;

- (AVAssetExportSession*)assetExportSession;

- (CALayer *)overlayer;


@end
