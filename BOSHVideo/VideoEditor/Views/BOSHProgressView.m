//
//  BOSHProgressView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHProgressView.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"

#define kCursorH 40
#define kIndicatorW 4
#define kAddButtonWidth 25
#define kMargin 10
#define kTag 9090

@interface BOSHImageView : UIImageView
@end
@implementation BOSHImageView
@end

@interface BOSHProgressView ()<UIScrollViewDelegate>

@end

@implementation BOSHProgressView

+ (CGFloat)preferHeight
{
    return kCursorH + 15;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return  (self = [super initWithFrame:frame]) && [self setupViews],self;
}

- (BOOL)setupViews
{
    _timeLabel = [[BOTHTimeView alloc] initWithFrame:CGRectMake(self.width - 200 - 10,      kCursorH,200,15)];
    _timeLabel.text = @"";
//    _timeLabel.backgroundColor = UIColorFromRGBA(0x222222,.3);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    //
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, kCursorH)];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    //指示器
    _indicatorView = [[BOSHNoneTouchView alloc] initWithFrame:CGRectMake((self.width - kIndicatorW)/2, 0, kIndicatorW,kCursorH )];
    _indicatorView.backgroundColor = [UIColor whiteColor];
    _indicatorView.clipsToBounds = YES;
    _indicatorView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    _indicatorView.layer.cornerRadius = kIndicatorW/2;
    _indicatorView.layer.masksToBounds = YES;
    [self addSubview:_indicatorView];
    
    [self bringSubviewToFront:_timeLabel];
    return YES;
}


- (void)setImages:(NSArray<UIImage *> *)images
{
    if(images.count > 0)
    {
        if(_scrollView.subviews)
        {
//            [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        for(int ii =0; ii < _scrollView.subviews.count; ii++)
        {
            UIView *view = _scrollView.subviews[ii];
            if([view isKindOfClass:BOSHImageView.class])
            [view removeFromSuperview];
        }
        
        _thumbLength = kCursorH * images.count;
    
        _scrollView.contentSize = CGSizeMake(_thumbLength + _scrollView.width, kCursorH);
        _scrollView.contentOffset = CGPointMake(0, 0);
        CGFloat xWidth = kCursorH;
        CGFloat xHeight = kCursorH ;
        CGFloat x_offset = (_scrollView.width)/2;
        for(int ii =0; ii < images.count; ii ++)
        {
            BOSHImageView *imageView = [[BOSHImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = images[ii];
            imageView.frame = CGRectMake(x_offset, 0, xWidth, xHeight);
            x_offset += xWidth;
            imageView.tag = kTag + ii;
            [_scrollView addSubview:imageView];
        }
    }
}

- (double)getCurrentTime
{
    if(_thumbLength != 0)
    {
        return  (MIN(MAX(0,(_scrollView.contentOffset.x)),_thumbLength)/_thumbLength)*self.duration;
    }
    return 0;
}


//@property (nonatomic, strong) NSArray <BOTHRange *>*ranges;

#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView// any offset changes
{
    [_timeLabel setCurTime:self.getCurrentTime andDuration:self.duration];
//    [_timeLabel showTimeInHighPrecision:self.getCurrentTime];
    if(self.isSeeking == YES)
    {
        [self onSlide:1];
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    ///创建一个cayer
    self.isSeeking = YES;
    [self onSlide:0];
}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [_timeLabel showTimeInHighPrecision:self.getCurrentTime];
    [_timeLabel setCurTime:self.getCurrentTime andDuration:self.duration];
    if(self.isSeeking)
    {
        [self onSlide:2];
        self.isSeeking = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;       // called when scroll view grinds to a halt
{
//    [_timeLabel showTimeInHighPrecision:self.getCurrentTime];
    [_timeLabel setCurTime:self.getCurrentTime andDuration:self.duration];
    if(self.isSeeking)
    {
        [self onSlide:2];
        self.isSeeking = NO;
    }
}


- (void)onSlide:(int)state
{
    if(_seekHandler)
    {
        _seekHandler(self.getCurrentTime,state);
    }
}

- (void)setCurTime:(double)curTime
{
    self.scrollView.contentOffset = CGPointMake((curTime/self.duration) *_thumbLength, 0);
}
@end
