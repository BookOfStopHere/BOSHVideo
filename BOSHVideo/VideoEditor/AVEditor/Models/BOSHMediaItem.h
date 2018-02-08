//
//  BOSHMediaItem.h
//  BOSHVideo
//
//  Created by yang on 2017/10/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "BOTHClipCommand.h"
#import "BOTHMacro.h"


typedef NS_ENUM(NSInteger, BOSHMediaItemType){
    BOSHMediaItemTypeAny,
    BOSHMediaItemTypeVideo,//视频
    BOSHMediaItemTypeAudio,//音频
    BOSHMediaItemTypeScript,//字幕
};

typedef void (^BOTHMediaCompletionHandler)(BOOL isYES);

@interface BOSHMediaItem : NSObject

@property (nonatomic,assign) BOSHMediaItemType mediaType;
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, assign) CMTimeRange timeRange;

@property (nonatomic, readonly) NSURL *url;
//创作容器
@property (nonatomic, strong) AVMutableComposition *comp;
//要插入到那个Track
@property (nonatomic, strong) AVMutableCompositionTrack *comTrack;

//封面图
@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, copy) NSString *exportQuality;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;


//Observer
extern NSString *const BOTHAVAssetTracksKey;
extern NSString *const BOTHAVAssetDurationKey;
extern NSString *const BOTHAVAssetCommonMetadataKey;
extern NSString *const BOTHAVAssetPreferredTransformKey;//For Video

//
- (void)prepareMediaAsynchronouslyForKeys:(NSArray<NSString *> *)keys completionHandler:(BOTHMediaCompletionHandler)handler;
//@override
- (void)preparedWithHandler:(BOTHMediaCompletionHandler)handler;

- (AVAssetExportSession *)exportSession;
- (AVPlayerItem *)playItem;

@end
