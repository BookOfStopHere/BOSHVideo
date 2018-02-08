//
//  BOSHEditorCache.h
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOSHOverlay.h"
#import "BOSHVoiceItem.h"

/**
 * 目前用于单次的操作缓存，后续可以定义为全局的缓存
 * 使得 素材的选取添加  与  编辑 真正分离
 */

@interface BOSHEditorCache : NSObject

///分而治之
//录音片段
@property (nonatomic, strong) NSMutableArray <BOSHVoiceItem *> *voiceSegments;

//视频分段
@property (nonatomic, strong) NSMutableArray *videoSegments;

//选择GIF
@property (nonatomic, strong) NSMutableArray *gifOverlays;

//字幕
@property (nonatomic, strong) NSMutableArray *textOverlays;

//转场
@property (nonatomic, strong) NSMutableArray *transitions;

//水印
@property (nonatomic, strong) BOSHOverlay *watermark;

//边框
@property (nonatomic, strong) BOSHBorderOverlay *borderOverlay;

//静音操作 YES : 静音 NO取消静音
@property (nonatomic) BOOL mute;

//滤镜操作
@property (nonatomic) BOSHFilterType filterType;


+ (instancetype)defaultCache;

@end
