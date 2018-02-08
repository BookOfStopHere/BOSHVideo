//
//  BOSHAudioView.h
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOTHRange.h"
#import "BOSHVoiceProgressView.h"

@class BOSHAudioView;
@protocol BOSHAudioView <NSObject>
@optional
- (void)audioViewDidFinishRecord:(BOSHAudioView *)audioView;
- (void)audioViewWillStartRecord:(BOSHAudioView *)audioView;
- (void)audioViewDidDeleteRecord:(BOSHAudioView *)audioView;

@end

@interface BOSHAudioView : UIView
@property (nonatomic, strong) NSArray <UIImage *>*images;
@property (nonatomic, readonly) NSArray <BOTHRange *> *voiceRanges;
@property (nonatomic) double duration;

@property (nonatomic, weak) id<BOSHAudioView> delegate;

@property (nonatomic, strong) BOSHVoiceProgressView  *progressView;

- (instancetype)initWithFrame:(CGRect)frame duration:(double)duration andRanges:(NSArray <BOTHRange *> *)voiceRanges;

- (void)setCurTime:(double)curTime;

@end
