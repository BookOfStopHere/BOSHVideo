//
//  BOSHVoiceProgressView.h
//  BOSHVideo
//
//  Created by yang on 2017/11/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHProgressView.h"

@interface BOSHVoiceProgressView : BOSHProgressView

@property (nonatomic, strong) NSMutableArray *recordClips;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) NSArray <BOTHRange *>*ranges;
//音频添加使用
@property (nonatomic, copy) void(^rangeDeleteHandler)(BOTHRange *range);
@property (nonatomic, copy) void(^rangeBeginAddHandler)(BOTHRange *range);
@property (nonatomic, copy) void(^rangeFinishAddHandler)(BOTHRange *range);


- (void)startRecordAtTime:(double)atTime;
- (void)startRecord;
- (void)stopRecord;

@end
