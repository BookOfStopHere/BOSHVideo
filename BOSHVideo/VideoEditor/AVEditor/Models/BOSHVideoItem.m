//
//  BOSHVideoItem.m
//  BOSHVideo
//
//  Created by yang on 2017/10/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHVideoItem.h"
//固定两秒一张
#define kImageInterval 1

@interface BOSHVideoItem ()
{
    AVAssetImageGenerator *_imageGenerator;
}

@property (nonatomic, strong) NSMutableArray *thumbnailCache;
@end

@implementation BOSHVideoItem


+ (BOSHVideoItem *)videoItemWithURL:(NSURL *)URL
{
    return [[self alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super initWithURL:url];
    if(self)
    {
    }
    return self;
}

- (void)preparedWithHandler:(BOTHMediaCompletionHandler)handler
{
    [self extractFrameInfo];//获取帧信息
    [self extractThumbnalisWithCompletionHandler:handler];//获取缩略图
}


- (void)extractThumbnalisWithCompletionHandler:(BOTHMediaCompletionHandler)handler
{
    NSMutableArray *times = [NSMutableArray array];
    int count = CMTimeGetSeconds(self.asset.duration)/kImageInterval;
    if(count <= 0)
    {
        handler(NO);
        return;
    }
    
    CMTimeValue tValue = self.asset.duration.value/count;
    CMTime intervalTime = CMTimeMake(tValue, self.asset.duration.timescale);
    
    CMTime startTime = kCMTimeZero;
    for(int ii = 0; ii < count; ii++)
    {
        [times addObject: [NSValue valueWithCMTime:startTime]];
        startTime = CMTimeAdd(startTime, intervalTime);
    }
    
    NSValue *lastValue = times.lastObject;
    [self.thumbnailCache removeAllObjects];
    __block NSMutableArray *thumbnailCache = [NSMutableArray array];
    __weak typeof(self) weakself = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if(result == AVAssetImageGeneratorSucceeded)
        {
            [thumbnailCache addObject:[UIImage imageWithCGImage:image]];
        }
        else
        {
            //加上默认图
            //TODO
        }
        
        if(CMTimeCompare(requestedTime,lastValue.CMTimeValue) == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(thumbnailCache.count)
                {
                    weakself.thumbnail = [NSArray arrayWithArray:thumbnailCache];
                }
                handler(YES);
            });
        }
    }];
}



- (void)extractFrameInfo
{
    NSArray *videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [videoTracks firstObject];
    _fps = track.nominalFrameRate;
    _frameDuration = track.minFrameDuration;
    _videoSize = track.naturalSize;
}


- (AVAssetTrack *)anyTrack
{
    NSArray *videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
   return  [videoTracks firstObject];
}

- (AVAssetTrack *)audioTrack
{
    NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
    return  [audioTracks firstObject];
}

 - (AVAssetTrack *)videoTrack
{
    NSArray *videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
    return  [videoTracks firstObject];
}


- (AVAssetImageGenerator *)imageGenerator
{
    if(!_imageGenerator)
    {
        _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
    }
    return _imageGenerator;
}

- (UIImage *)thumbImageAtTime:(NSTimeInterval)time
{
    //字典@{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES/NO),AVURLAssetReferenceRestrictionsKey} 计算duration 是否精确，精确比较费时，传空默认不精确
    NSParameterAssert(self.asset);
    if(self.anyTrack)
    {
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc]initWithAsset:self.asset];
        generator.appliesPreferredTrackTransform = YES;//截图时调整正确的方向
        
        CMTime cmtime = CMTimeMakeWithSeconds(time, self.asset.duration.timescale);//
        CGImageRef imageRef = [generator copyCGImageAtTime:cmtime actualTime:nil error:nil];
        UIImage *captureImage = [UIImage imageWithCGImage:imageRef];
        return captureImage;
    }
    return nil;
}
@end
