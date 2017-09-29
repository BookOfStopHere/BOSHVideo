//
//  SSSlider.m
//  SSPlayer
//
//  Created by 1 on 16/12/25.
//  Copyright © 2016年 SSPlayer. All rights reserved.
//

#import "SSSlider.h"
@interface SSSlider ()
{
    CGFloat _startPoint_X;
}

@property (nonatomic, strong) UIImageView *cursor;
@end

@implementation SSSlider

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context,kCGLineCapRound);

    [[UIColor grayColor] setStroke];
    CGContextSetLineWidth(context,2.0);
    CGContextMoveToPoint(context,0, (self.frame.size.height - 2)/2);
    CGContextAddLineToPoint(context,self.frame.size.width, (self.frame.size.height - 2)/2);
    CGContextStrokePath(context);
    
    
    [[UIColor greenColor] setStroke];
    CGContextSetLineWidth(context,2.0);
    CGContextMoveToPoint(context,0, (self.frame.size.height - 2)/2);
    CGContextAddLineToPoint(context,_progress * self.frame.size.width, (self.frame.size.height - 2)/2);
    CGContextStrokePath(context);
    
    
//    CGFloat w = self.bounds.size.width;
//    CGFloat h = self.bounds.size.height;
//    //圆点
//    CGPoint center = CGPointMake(_progress *w, h * 0.5);
//    //半径
//    CGFloat radius = h * 0.5;
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
//    [[UIColor orangeColor] setFill];
//    CGContextAddPath(context, path.CGPath);
//    CGContextFillPath(context);
    
}

- (void)setProgress:(CGFloat)progress
{
    progress = progress >= 1 ? 1 : (progress <=0 ?  0 : progress);
    _progress = progress;
    [self updateCursor];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateCursor];
}
- (void)updateCursor
{
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;
    CGFloat x = _progress *w;
    x = x >= (w - h) ? (w - h) : x;
    self.cursor.frame = CGRectMake(x, 0, self.frame.size.height, self.frame.size.height);
}

- (UIImageView *)cursor
{
    if(!_cursor)
    {
        _cursor = [UIImageView new];
        _cursor.userInteractionEnabled = YES;
        _cursor.backgroundColor = [UIColor whiteColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_cursor addGestureRecognizer:pan];
        _cursor.clipsToBounds = YES;
        _cursor.layer.masksToBounds = YES;
        [self addSubview:_cursor];
    }
    _cursor.layer.cornerRadius = self.frame.size.height/2;
    return _cursor;
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        _startPoint_X = [pan locationInView:pan.view].x;
        self.seekAction(SSSliderSeekingStateBegin,self.progress);
    }
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGFloat c_x = [pan locationInView:pan.view].x;
        NSLog(@"seeking:  %f,%f,%f \n",_startPoint_X,c_x,c_x - _startPoint_X);
        [self updateProgressToPoint:c_x];
        self.isSeeking = YES;
        self.seekAction(SSSliderSeekingStateChange,self.progress);
    }
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        CGFloat c_x = [pan locationInView:pan.view].x;
        [self updateProgressToPoint:c_x];
        self.isSeeking = NO;
        self.seekAction(SSSliderSeekingStateEnd,self.progress);
    }
}

- (void)updateProgressToPoint:(CGFloat)c_x
{
    CGFloat progress = self.progress;
    progress = (progress * self.frame.size.width + (c_x - _startPoint_X))/self.frame.size.width;
    if(progress <= 0 || progress >= 1)
    {
        progress = progress <= 0 ? 0 : 1;
    }
    self.progress = progress;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.seekAction(SSSliderSeekingStateBegin,self.progress);
    UITouch *touch = [touches anyObject];
    CGFloat point_x = [touch locationInView:self].x;
    
    point_x = point_x >= 0 ? (point_x >= self.frame.size.width ? 1 : point_x): 0;
    if(self.frame.size.width == 0)return;
    CGFloat progress = point_x / self.frame.size.width;
    self.progress = progress;
    self.isSeeking = YES;
    self.seekAction(SSSliderSeekingStateChange,self.progress);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSeeking = NO;
    self.seekAction(SSSliderSeekingStateEnd,self.progress);
}
@end
