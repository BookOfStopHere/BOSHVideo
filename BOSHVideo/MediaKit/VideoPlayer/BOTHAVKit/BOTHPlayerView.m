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
    BOOL _playRateToRestore;
    BOOL _playing;
}
@property AVPlayerItem *playerItem;
@property (nonatomic, strong) id timeObserver;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVSynchronizedLayer *syncLayer;
@end

@implementation BOTHPlayerView

- (void)dealloc
{
    [self stop];
}

#if !DD
+ (Class)layerClass
{
    return AVPlayerLayer.class;
}

- (AVPlayer *)player
{
    return ((AVPlayerLayer *)self.layer).player;
}

- (void)setPlayer:(AVPlayer *)player
{
    ((AVPlayerLayer *)self.layer).player = player;
}
#endif

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAction:)]];
    }
    return self;
}

- (UIButton *)playBtn
{
    if(!_playBtn)
    {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        [_playBtn setImage:[UIImage imageNamed:@"vivavideo_home_btn_bigvideobf_nrm_31x31_"] forState:0];
        [_playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playBtn];
    }
    return _playBtn;
}

- (void)layoutSubviews
{
    self.playBtn.frame = CGRectMake((self.frame.size.width - 90)/2, (self.frame.size.height - 90)/2, 90, 90);
    [super layoutSubviews];
}

- (void)reset
{
    self.error = nil;
    _seekToZeroBeforePlaying = NO;
    _playing = NO;
    _playRateToRestore = NO;
}

- (void)playWithItem:(AVPlayerItem *)playItem
{
    self.playBtn.hidden = NO;
    if(self.playerItem != playItem)
    {
        [self reset];
        
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
        if(_seekToZeroBeforePlaying)
        {
            [self.player seekToTime:kCMTimeZero
                    toleranceBefore:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC)
                     toleranceAfter:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC)
                  completionHandler:^(BOOL finished) {
                              [self.player play];
                  }];
            
            _seekToZeroBeforePlaying = NO;
        }
        else
        {
            [self.player play];
        }
    }
    self.playBtn.hidden = YES;
}

- (void)pause
{
    self.playBtn.hidden = NO;
    [self.player pause];
}

- (void)seekTo:(double)time completion:(void(^)(BOOL finished))handler
{
    if(self.player.currentItem.status == AVPlayerItemStatusReadyToPlay)
    {
        __weak typeof(self) weakself = self;
        [self pause];
        self.playerStateHandler(BOTHPlayerStateOnSeeking);
        [self.player seekToTime:CMTimeMakeWithSeconds(time/1000.0,NSEC_PER_SEC)
                toleranceBefore:kCMTimeZero
                 toleranceAfter:kCMTimeZero
              completionHandler:^(BOOL finished) {
                  if(finished)
                  {
                      weakself.playerStateHandler ? weakself.playerStateHandler(BOTHPlayerStateOnSeekSuccess) :YES;
                  }
                  if(handler)
                  {
                      handler(finished);
                  }
              }];
    }
}

- (void)stop
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [self.player pause];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self removeTimeObserverFromPlayer];
    [self setPlayer:nil];
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
    if(self.player.currentItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return CMTimeGetSeconds(self.player.currentItem.currentTime)*1000;
    }
    return 0;
}

- (double)duration
{
   if(self.player.currentItem.status == AVPlayerItemStatusReadyToPlay)
   {
        return  CMTimeGetSeconds([self playerItemDuration])*1000;
   }
    else
    {
        return 0;
    }
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
        __weak typeof(self) weakself = self;
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            __strong typeof (weakself) strongself = weakself;
            if(strongself.progressHandler)
            {
                strongself.progressHandler();
            }
//            weakself.progress = weakself.currentTime/weakself.duration;
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


- (void)setVideoGravity:(NSString *)videoGravity
{
    [((AVPlayerLayer *)self.layer) setVideoGravity:videoGravity];
}


- (AVSynchronizedLayer *)getAVSyncLayer
{
    if(self.player.currentItem != self.syncLayer.playerItem)
    {
        AVSynchronizedLayer *syncLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:self.player.currentItem];
        [self.layer addSublayer:syncLayer];
        syncLayer.frame = self.bounds;
        self.syncLayer = syncLayer;
        return syncLayer;
    }
    return self.syncLayer;
}
#pragma mark observor
- (void)playerItemDidReachEnd:(NSNotification *)notice
{
    _seekToZeroBeforePlaying = YES;
    self.playBtn.hidden = NO;
    self.playerStateHandler ? self.playerStateHandler(BOTHPlayerStateOnFinished) : YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == AVCDVPlayerViewControllerRateObservationContext ) {
        float newRate = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        NSNumber *oldRateNum = [change objectForKey:NSKeyValueChangeOldKey];
        if ( [oldRateNum isKindOfClass:[NSNumber class]] && newRate != [oldRateNum floatValue] )
        {
            _playing = ((newRate != 0.f) || (_playRateToRestore != 0.f));
            self.playerStateHandler ? self.playerStateHandler(_playing ? BOTHPlayerStateOnPlaying : BOTHPlayerStateOnPause) : YES;
            _playRateToRestore = _playing;
        }
    }
    else if ( context == AVCDVPlayerViewControllerStatusObservationContext )
    {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if (playerItem.status == AVPlayerItemStatusReadyToPlay)
        {
            self.playerStateHandler ? self.playerStateHandler(BOTHPlayerStateOnStart) : YES;
            [self addTimeObserverToPlayer];
        }
        else if (playerItem.status == AVPlayerItemStatusFailed)
        {
            self.error = playerItem.error;
            self.playerStateHandler ? self.playerStateHandler(BOTHPlayerStateOnError) : YES;
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark playaction
- (void)playAction:(id)sender
{
    if(self.playBtn.hidden)
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

@end
