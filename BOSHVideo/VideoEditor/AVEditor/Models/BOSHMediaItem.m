//
//  BOSHMidiaItem.m
//  BOSHVideo
//
//  Created by yang on 2017/10/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHMediaItem.h"
NSString *const BOTHAVAssetTracksKey = @"tracks";
NSString *const BOTHAVAssetDurationKey = @"duration";
NSString *const BOTHAVAssetCommonMetadataKey = @"commonMetadata";
NSString *const BOTHAVAssetPreferredTransformKey = @"preferredTransform";

@implementation BOSHMediaItem

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if(self)
    {
        [self initParametersWithURL:url];
    }
    return self;
}

- (void)initParametersWithURL:(NSURL *)url
{
    _url = url;
    if(url)
    {
        _asset = [AVURLAsset URLAssetWithURL:url options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)}];
    }
}


- (void)prepareMediaAsynchronouslyForKeys:(NSArray<NSString *> *)keys completionHandler:(BOTHMediaCompletionHandler)handler
{
    @weakify(self);
    if(_asset)
    {
        [_asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            ///
//            weakself.timeRange = CMTimeRangeMake(kCMTimeZero, weakself.asset.duration);
            [weakself preparedWithHandler:handler];
        }];
    }
    else
    {
        handler ? handler(NO) : 1;
    }
}

- (CMTimeRange)timeRange
{
    return CMTimeRangeMake(kCMTimeZero, self.asset.duration);
}

@override
- (void)preparedWithHandler:(BOTHMediaCompletionHandler)handler
{
    [self doesNotRecognizeSelector:_cmd];
}


//@override
- (BOSHMediaItemType) mediaType
{
    return BOSHMediaItemTypeAny;
}


- (AVAssetExportSession *)exportSession
{
    @synchronized (self) {
        if(self.exportQuality == nil) self.exportQuality = AVAssetExportPresetMediumQuality;
        AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:self.asset
                                                                             presetName:self.exportQuality];
        return assetExport;
    }
}

- (AVPlayerItem *)playItem
{
     @synchronized (self) {
        return  [AVPlayerItem playerItemWithAsset:self.asset];
     }
}


- (BOOL)isEqual:(id)other
{
    if (self == other)
    {
        return YES;
    }
    if (!other || ![other isKindOfClass:[self class]])
    {
        return NO;
    }
    return [self.url isEqual:[other url]];
}

- (NSUInteger)hash {
    return [self.url hash];
}
@end
