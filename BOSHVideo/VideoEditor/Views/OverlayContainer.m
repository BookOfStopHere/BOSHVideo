//
//  OverlayContainer.m
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "OverlayContainer.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"
#import "BOSHSynchronizedLayer.h"


@interface OverlayContainer ()
{
    BOOL _isHotRect;
    CGSize selfSize;
}
@end

@implementation OverlayContainer


+ (Class)layerClass
{
    return BOSHSynchronizedLayer.class;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = YES;
        _isHotRect = NO;
        [self setUpSubviews];
    }
    return self;
}


- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    ((BOSHSynchronizedLayer *)self.layer).playerItem = playerItem;
    ((BOSHSynchronizedLayer *)self.layer).insets = UIEdgeInsetsMake(16, 16, 16, 16);
}

- (void)setUpSubviews
{
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [self.closeButton setImage:[UIImage imageNamed:@"delete_gif"] forState:0];
    [self addSubview:self.closeButton];
    self.closeButton.hidden = NO;
    //拖动位置
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGesture:)];
    
      [self addGestureRecognizer:pinch];
}

//之前GIF 不能显示的问题是由于
- (void)addOverlayTrack:(BOSHOverlayTrack *)overlayTrack
{
    self.overlayTrack = overlayTrack;
    CGRect frame = overlayTrack.overlay.frame;
    [((BOSHSynchronizedLayer*)self.layer) addBOSHSublayer:overlayTrack.overlayer];
//    overlayTrack.overlay.overlayer.frame = CGRectMake(16, 16, frame.size.width, frame.size.width);
    self.frame = CGRectMake(frame.origin.x - 16, frame.origin.y - 16, frame.size.width +32, frame.size.height +32);
    selfSize = self.size;
}

- (void)addNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenNotice:) name:kHiddenAllOverlayNotice object:nil];
}

#pragma mark
- (void)hiddenNotice:(NSNotification *)notice
{
    self.closeButton.hidden = YES;
    self.layer.borderWidth = 0;
    self.layer.borderColor = nil;
}

- (void)touchDown
{
    self.closeButton.hidden = NO;
    self.closeButton.layer.borderWidth = 3;
    self.layer.borderWidth = 1;
    self.layer.borderColor = UIColorFromRGBA(0xe6e6e6, .4).CGColor;
}


- (CGRect)hotRect
{
    return CGRectMake(self.width - 40, self.height - 40, 50, 50);
}
#pragma mark
- (void)handlePan:(UIPanGestureRecognizer*)pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        [self touchDown];
        if(_isHotRect)
        {
            self.layer.borderColor = UIColorFromRGB(0x9932CC).CGColor;
            self.layer.borderWidth = 3;
        }
        else
        {
            self.layer.borderColor = UIColorFromRGB(0xFF7F50).CGColor;
            self.layer.borderWidth = 3;
        }
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        //
        [self adjustFrameWithPoint:[pan locationInView:pan.view.superview]];
    }
    else if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
        //
        [self adjustFrameWithPoint:[pan locationInView:pan.view.superview]];
        self.layer.borderColor = Nil;
        self.layer.borderWidth = 0;
    }
}

- (void)adjustFrameWithPoint:(CGPoint)movPoint
{
    if(!_isHotRect)
    {
        self.center = movPoint;
        self.left = MAX(0,MIN(self.left,self.superview.width - self.width));
        self.top = MAX(0,MIN(self.top,self.superview.height - self.height));
    }
    else
    {
        self.width = MIN((movPoint.x- self.centerX)*2,self.superview.width);
        self.height = MIN(( movPoint.y - self.centerY)*2,self.superview.height);
        self.left = MAX(0,MIN(movPoint.x - self.width,self.superview.width - self.width));
        self.top = MAX(0,MIN(movPoint.y - self.height,self.superview.height - self.height));
    }
}


- (void)pinGesture:(UIPinchGestureRecognizer *)pin
{
    CGPoint point = self.center;
    self.width = selfSize.width * pin.scale;
    self.height = selfSize.height *pin.scale;
    self.center = point;

}

- (void)layoutSubviews
{
    //在这里更新性能会高些 CPU 占用比较低 2%左右
    [CATransaction setValue:(__bridge id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.overlayTrack.overlay.overlayer.frame = CGRectMake(16, 16, self.width - 32, self.height - 32);
    [CATransaction commit];
    [super layoutSubviews];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if(view)
    {
        _isHotRect = CGRectContainsPoint(self.hotRect, point);
    }
    return view;
}

@end
