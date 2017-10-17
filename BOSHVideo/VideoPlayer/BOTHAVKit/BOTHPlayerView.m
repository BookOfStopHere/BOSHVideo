//
//  BOTHPlayerView.m
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "SSPlayControl.h"

static void *AVCDVPlayerViewControllerStatusObservationContext = &AVCDVPlayerViewControllerStatusObservationContext;
static void *AVCDVPlayerViewControllerRateObservationContext = &AVCDVPlayerViewControllerRateObservationContext;

@interface BOTHPlayerView ()
{
    BOOL  _seekToZeroBeforePlaying;
    id _timeObserver;
    BOOL _playRateToRestore;
    BOOL _playing;
}
@property AVPlayerItem *playerItem;

@end

@implementation BOTHPlayerView

- (void)dealloc
{
    [self stop];
}

+ (Class)layerClass
{
    return AVPlayerLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        SSPlayControl *control = [[SSPlayControl alloc] initWithFrame:self.bounds];
        [self addSubview:control];
    }
    return self;
}
    

- (AVPlayer *)player
{
    return ((AVPlayerLayer *)self.layer).player;
}

- (void)setPlayer:(AVPlayer *)player
{
    ((AVPlayerLayer *)self.layer).player = player;
}

- (void)playWithItem:(AVPlayerItem *)playItem
{
    if(self.playerItem != playItem)
    {
        if ( self.playerItem )
        {
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        }
        self.playerItem = playItem;
        
        if ( self.playerItem )
        {
            // Observe the player item "status" key to determine when it is ready to play
            [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) context:AVCDVPlayerViewControllerStatusObservationContext];
            
            // When the player item has played to its end time we'll set a flag
            // so that the next time the play method is issued the player will
            // be reset to time zero first.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        }
        
        if(self.player == nil)
        {
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playItem];
            [self setPlayer:player];
            [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:AVCDVPlayerViewControllerRateObservationContext];
        }
        else
        {
            [self.player replaceCurrentItemWithPlayerItem:playItem];
        }
    }
}

- (void)play
{
    if(self.isPlaying == NO)
    {
        //plaing to End
        [self.player seekToTime:self.player.currentItem.currentTime
                toleranceBefore:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC)
                 toleranceAfter:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC)
              completionHandler:^(BOOL finished) {
                          [self.player play];
              }];
    }
}

- (void)pause
{
    [self.player pause];
}

- (void)seekTo:(double)time completion:(void(^)(BOOL finished))handler
{
    [self.player seekToTime:CMTimeMakeWithSeconds(time,NSEC_PER_SEC)
            toleranceBefore:kCMTimeZero
             toleranceAfter:kCMTimeZero
          completionHandler:^(BOOL finished) {
              if(handler)
              {
                  handler(finished);
              }
          }];
}

- (void)stop
{
    [self.player pause];
    [self removeTimeObserverFromPlayer];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:self];
}

- (BOOL)isPlaying
{
    return self.player.rate != 0;
}

- (void)setMute:(BOOL)isMute
{
    self.player.muted = isMute;
}

- (double)currentTime
{
    return CMTimeGetSeconds(self.player.currentItem.currentTime);
}

- (double)duration
{
    return  CMTimeGetSeconds([self playerItemDuration]);
}

- (BOOL)isPlayEnd
{
    return _seekToZeroBeforePlaying;
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.player currentItem];
    CMTime itemDuration = kCMTimeInvalid;
    
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        itemDuration = [playerItem duration];
    }
    
    /* Will be kCMTimeInvalid if the item is not ready to play. */
    return itemDuration;
}

/* Update the scrubber and time label periodically. */
- (void)addTimeObserverToPlayer
{
    if (_timeObserver)
        return;
    
    if (self.player == nil)
        return;
    
    if (self.player.currentItem.status != AVPlayerItemStatusReadyToPlay)
        return;
    
    if (isfinite(self.duration))
    {
        _timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//                             [weakSelf updateScrubber];
//                             [weakSelf updateTimeLabel];
                         }];
    }
}

- (void)removeTimeObserverFromPlayer
{
    if (_timeObserver) {
        [self.player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

#pragma mark observor
- (void)playerItemDidReachEnd:(NSNotification *)notice
{
    _seekToZeroBeforePlaying = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == AVCDVPlayerViewControllerRateObservationContext ) {
        float newRate = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        NSNumber *oldRateNum = [change objectForKey:NSKeyValueChangeOldKey];
        if ( [oldRateNum isKindOfClass:[NSNumber class]] && newRate != [oldRateNum floatValue] ) {
            _playing = ((newRate != 0.f) || (_playRateToRestore != 0.f));
//            [self updatePlayPauseButton];
//            [self updateScrubber];
//            [self updateTimeLabel];
        }
    }
    else if ( context == AVCDVPlayerViewControllerStatusObservationContext ) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            /* Once the AVPlayerItem becomes ready to play, i.e.
             [playerItem status] == AVPlayerItemStatusReadyToPlay,
             its duration can be fetched from the item. */
            
            [self addTimeObserverToPlayer];
        }
        else if (playerItem.status == AVPlayerItemStatusFailed) {
//            [self reportError:playerItem.error];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
