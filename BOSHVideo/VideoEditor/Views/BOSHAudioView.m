//
//  BOSHAudioView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHAudioView.h"
#import "BOSHVoiceProgressView.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"

#define kTimeInterval 0.1

@interface BOSHAudioView ()
{
    UIButton *_recordButton;
    UIButton *_itunesButton;
    NSTimer *_timer;
    int _count;
}
@property (nonatomic, assign) BOOL isRecording;
@end

@implementation BOSHAudioView

- (void)dealloc
{
//    [self stopTimer];
}


- (instancetype)initWithFrame:(CGRect)frame duration:(double)duration andRanges:(NSArray <BOTHRange *> *)voiceRanges
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _voiceRanges = voiceRanges;
        _duration = duration;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake((self.width - 80)/2, self.height - 80 - 15, 80, 80)];
    _recordButton.clipsToBounds = YES;
    _recordButton.layer.cornerRadius = 80/2;
    _recordButton.layer.borderWidth = 3;
    _recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_recordButton setTitle:@"配音" forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(clickEvent) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addGestureRecognizer: [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)]];
    [self addSubview:_recordButton];
    
    _itunesButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 60, 40)];
    [_itunesButton setTitle:@"itunes" forState:UIControlStateNormal];
    [self addSubview:_itunesButton];
    
    _itunesButton.centerY = _recordButton.centerY;
    _itunesButton.left = _recordButton.right + 20;
    
    
   _progressView = [[BOSHVoiceProgressView alloc] initWithFrame:CGRectMake(0, 20, self.width, [BOSHProgressView  preferHeight])];
    [self addSubview:_progressView];
    _progressView.duration = _duration;
    UIImage *image = [UIImage imageNamed:@"bgStory"];
    [_progressView setImages:@[image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image]];
    
     [_progressView setRanges:_voiceRanges];
}

- (void)setImages:(NSArray<UIImage *> *)images
{
    [_progressView setImages:images];
}

- (void)setDuration:(double)duration
{
    _duration = duration;
    _progressView.duration = duration;
}

- (void)setCurTime:(double)curTime
{
    [_progressView setCurTime:curTime];
}


- (void)stopTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)startTimer
{
    [self stopTimer];
    _count = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark timer handler
- (void)updateTime
{
     [_recordButton setTitle:[NSString stringWithFormat:@"%.1fs",(_count++)*kTimeInterval] forState:UIControlStateNormal];
}


#pragma mark user action

- (void)longPressAction:(UILongPressGestureRecognizer *)longGes
{
    if(longGes.state == UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:.2 animations:^{
            _recordButton.backgroundColor = UIColorFromRGB(0xee6363);
        } completion:^(BOOL finished) {
            
        }];
        
        if(_delegate && [_delegate respondsToSelector:@selector(audioViewWillStartRecord:)])
        {
            [_delegate audioViewWillStartRecord:self];
        }
        [_progressView startRecord];
        self.isRecording = YES;
    }
    else if(longGes.state == UIGestureRecognizerStateEnded || longGes.state == UIGestureRecognizerStateCancelled)
    {
        [_progressView stopRecord];
        if(_delegate && [_delegate respondsToSelector:@selector(audioViewDidFinishRecord:)])
        {
            [_delegate audioViewDidFinishRecord:self];
        }
        _recordButton.backgroundColor = [UIColor clearColor];
        self.isRecording = NO;
    }
}

- (void)clickEvent
{
}

@end
