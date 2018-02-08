//
//  BOSHPassthoughSegment.h
//  BOSHVideo
//
//  Created by yang on 2017/11/23.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
/**
 * 处理非交叠区域的时间片,此版本并不关心片头片尾的动画
 * 后续版本 再行增加；此类封装了音视频的Track处理，便于复用，同时规避了这种细节的繁琐操作
 * 引发的人为编码错误
 */
@interface BOSHPassthoughSegment : NSObject

@property (nonatomic) CMTimeRange timeRange;
@property (nonatomic) CGSize trackSize;
@property (nonatomic) CGSize targetSize;

@property (nonatomic, strong) AVMutableCompositionTrack *videoTrack;
@property (nonatomic, strong) AVMutableCompositionTrack *audioTrack;
@property (nonatomic) float volume;
/**
 * 主要用于旋转视频时使用 
 */
@property (nonatomic) CGAffineTransform preferTransform;
- (NSArray<AVAudioMixInputParameters *> *)audioMixInputParameters;
- (AVMutableVideoCompositionInstruction *)videoCompositionInstruction;
@end
