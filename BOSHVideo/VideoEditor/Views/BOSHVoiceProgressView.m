//
//  BOSHVoiceProgressView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/20.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHVoiceProgressView.h"
#import "BOSHNoneTouchView.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"
@interface BOSHVoiceProgressView ()
@property (nonatomic, assign) BOOL isStartRecording;
@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, strong) NSMutableArray *clipLayers;
@property (nonatomic, strong) BOSHNoneTouchView *curView;
@end

@implementation BOSHVoiceProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipLayers = [NSMutableArray array];
    }
    return self;
}


- (void)setRanges:(NSArray<BOTHRange *> *)ranges
{
    _ranges = ranges;
    if(ranges.count)
    {
        //
        [self drawRanges];
    }
}
#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView// any offset changes
{
    [super scrollViewDidScroll:scrollView];
    
    if(self.isRecording &&  self.curView)
    {
        [self removeIntersectionLayers];
        self.curView.frame = CGRectMake(self.startX, 0, scrollView.contentOffset.x - self.startX +  scrollView.width/2, scrollView.height);
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [super scrollViewWillBeginDragging:scrollView];
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;       // called when scroll view grinds to a halt
{
    [super scrollViewDidEndDecelerating:scrollView];
}

- (void)setCurTime:(double)curTime
{
    [super setCurTime:curTime];
    if(self.isRecording)
    {
        if(self.curView == nil)
        {
            self.startX = self.scrollView .contentOffset.x +  self.scrollView.width/2;
            self.curView = BOSHNoneTouchView.new;
            self.curView.backgroundColor = UIColorFromRGBA(0x3CB371,.3);
            self.curView.frame = CGRectMake(self.scrollView.contentOffset.x +  self.scrollView.width/2, 0, 0, self.scrollView.height);
            [self.scrollView addSubview:self.curView];
        }
        [self removeIntersectionLayers];
        self.curView.frame = CGRectMake(self.startX, 0, self.scrollView.contentOffset.x - self.startX +  self.scrollView.width/2, self.scrollView.height);
    }
}

- (void)removeIntersectionLayers
{
    @autoreleasepool{
        for(int ii = 0; ii < self.clipLayers.count; ii++)
        {
            UIView *view = self.clipLayers[ii];
            if(CGRectContainsPoint(view.frame, CGPointMake(self.scrollView.contentOffset.x +  self.scrollView.width/2, 0)))
            {
                [view removeFromSuperview];
                [self.clipLayers removeObject:view];
            }
        }
    }
}

- (void)startRecordAtTime:(double)atTime
{
    self.scrollView.contentOffset = CGPointMake((atTime/self.duration) *_thumbLength, 0);
    [self startRecord];
}

- (void)startRecord
{
    self.isRecording = YES;
}

- (void)stopRecord
{
    self.isRecording = NO;
    if(self.curView && ![self.clipLayers containsObject:self.curView])
    {
        [self.clipLayers addObject:self.curView];
    }
    self.curView = nil;
}

- (void)drawRanges
{
    if(_ranges.count > 0)
    {
        @autoreleasepool{
            for(BOTHRange *rangeValue in self.ranges)
            {
                CGFloat height = self.scrollView.height;
                CGFloat width = (rangeValue.duration/self.duration)*_thumbLength;
                CGFloat xoffset = (rangeValue.start/self.duration)*_thumbLength + self.scrollView.width/2;
                CGFloat yoffset = 0;
                BOSHNoneTouchView *view = BOSHNoneTouchView.new;
                view.backgroundColor = UIColorFromRGBA(0x3CB371,.3);
                view.frame = CGRectMake(xoffset, yoffset, width, height);
                [self.scrollView addSubview:view];
                [self.clipLayers addObject:view];
            }
        }
    }
}

@end
