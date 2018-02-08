//
//  BOTHEditorRulerView.m
//  BOSHVideo
//
//  Created by yang on 2017/10/31.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHEditorRulerView.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"
#import "BOTHThumbnailsView.h"
#import "BOTHTimeView.h"
#import "BOSHUtils.h"

#define kCursorW (32/2)
#define kCursorH (116/2)
#define kRulerW (self.width - 2*kCursorW)


@interface BOTHArrowTextView : UIView
@property (nonatomic, strong)  UILabel *textLabel;

- (void)setTime:(double)time completeHandler:(void(^)(CGFloat width))handler;

@end

@implementation BOTHArrowTextView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setTime:(double)time completeHandler:(void(^)(CGFloat width))handler
{
    NSString *curTimeString = @"";
    
    long  s,h,m,ms;
    [BOSHUtils convertMS:time toHour:&h min:&m sec:&s ms:&ms];
    
    if(time/1000 < (60*60))
    {
        curTimeString = [NSString stringWithFormat:@"%.2ld:%.2ld.%.2ld", m,s,ms];
    }
    else
    {
        curTimeString = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld.%.2ld", h,m,s,ms];
    }
    
    NSAttributedString *curAttr = [[NSAttributedString alloc] initWithString:curTimeString attributes:@{
                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                                        NSForegroundColorAttributeName:UIColorFromRGB(0xffffff),
 
                                                                                                        }];
    CGSize size = [curAttr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading context:nil].size;
    
    self.textLabel.frame = CGRectMake(6, 6, size.width , size.height);
    self.textLabel.attributedText = curAttr;
    handler(size.width + 12);
}


- (UILabel *)textLabel
{
    if(!_textLabel)
    {
        _textLabel = [UILabel new];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

//当前View 中间的位置
- (void)drawRect:(CGRect)rect
{
    float w = rect.size.width;
    float h = rect.size.height - 10;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.2);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(context,UIColorFromRGB(0x696969).CGColor);
    CGContextMoveToPoint(context, 6, 0);
    CGContextAddArcToPoint(context, w, 0, w, 6, 6);
    CGContextAddArcToPoint(context, w , h , w - 6, h, 6);
    CGContextAddLineToPoint(context, w/2 + 5, h );
    CGContextAddLineToPoint(context, w/2, h + 6);
    CGContextAddLineToPoint(context, w/2 - 5, h );
    CGContextAddArcToPoint(context, 0, h, 0, h - 6, 6);
    CGContextAddArcToPoint(context, 0, 0, 6, 0, 6);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end

@interface BOTHCursorView : UIView

@end

@implementation BOTHCursorView

//当前View 中间的位置
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, (0x8B/255.0), (0x25/255.0), (0x0/255.0), 1.0);
    CGContextSetLineWidth(context, 3);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextMoveToPoint(context, rect.size.width/2, 0);
    CGContextAddLineToPoint(context,rect.size.width/2,  rect.size.height);
    CGContextStrokePath(context);//开始绘制
}

@end


@interface BOTHEditorRulerView ()
{
    NSMutableArray *_viewCache;
    NSInteger _selectState;//1 left right 2 default 0
}
@property (nonatomic, strong) UIView *subContentView;
@property (nonatomic, strong) UIView *imagesContainer;
@property (nonatomic, strong) BOTHCursorView *cursorView;
@property (nonatomic, strong) BOTHArrowTextView *curTimeTextLabel;
@property (nonatomic, strong) BOTHTimeView *timeLabel;

@end

@implementation BOTHEditorRulerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = YES;
        [self.timeLabel setTime:0];
        self.subContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/2)];
        [self addSubview: self.subContentView];
        
        _viewCache = [NSMutableArray array];
        self.limitDistance = 0;
        [self setupSubviews];
    }
    return self;
}


- (BOTHArrowTextView *)curTimeTextLabel
{
    if(!_curTimeTextLabel)
    {
        BOTHArrowTextView *textView = [[BOTHArrowTextView alloc] initWithFrame:CGRectMake(0, self.subContentView.top - 3 - 36, 80, 36)];
        [self addSubview:textView];
        textView.centerX = self.width/2;
        _curTimeTextLabel = textView;
    }
    return _curTimeTextLabel;
}

- (UIView *)imagesContainer
{
    if(!_imagesContainer)
    {
        _imagesContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width,  self.subContentView.height)];
        _imagesContainer.clipsToBounds = YES;
        _imagesContainer.backgroundColor = UIColorFromRGB(0x666666);
        [self.subContentView addSubview:_imagesContainer];
        [self.subContentView sendSubviewToBack:_imagesContainer];
    }
    return _imagesContainer;
}

- (void)setSingleProgress:(double)progress
{
    self.cursorView.centerX = MIN(self.rightImageView.left,MAX(self.leftImageView.right, (kRulerW)*(progress/(self.max - self.min)) + kCursorW));
}

- (void)setupSubviews
{
    self.leftMaskView.frame = CGRectMake(0, 0, 0, kCursorH);
    self.rightMaskView.frame =  CGRectMake(self.width, 0, 0, kCursorH);
    self.cursorView.frame = CGRectMake(kCursorW, 0, 2, kCursorH);
    self.leftImageView.frame = CGRectMake(0, 0, kCursorW, kCursorH);
    self.rightImageView.frame = CGRectMake(self.width - kCursorW, 0, kCursorW, kCursorH);
    self.imagesContainer.frame = CGRectMake(0, 0, self.width,  self.subContentView.height);
    self.imagesContainer.layer.cornerRadius = 4;
    
    [self setSelectState:0];
}

- (BOTHCursorView *)cursorView
{
    if(!_cursorView)
    {
        _cursorView = [[BOTHCursorView alloc] init];//2
        _cursorView.userInteractionEnabled = YES;
        _cursorView.backgroundColor = [UIColor clearColor];
        [self addPanGestureInView:_cursorView];
        [self.subContentView addSubview:_cursorView];
    }
    return _cursorView;
}

 - (UIImageView *)leftImageView
{
    if(!_leftImageView)
    {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.userInteractionEnabled = YES;
        [self addPanGestureInView:_leftImageView];
        [self.subContentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIView *)leftMaskView
{
    if(!_leftMaskView)
    {
        _leftMaskView = [UIView new];
        _leftMaskView.backgroundColor = UIColorFromRGBA(0x000000,0.7 );
          [self.subContentView addSubview:_leftMaskView];
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView
{
    if(!_rightMaskView)
    {
        _rightMaskView = [UIView new];
        _rightMaskView.backgroundColor = UIColorFromRGBA(0x000000,0.7);
        [self.subContentView addSubview:_rightMaskView];
        
    }
    return _rightMaskView;
}

- (UIImageView *)rightImageView
{
    if(!_rightImageView)
    {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.userInteractionEnabled = YES;
        [self addPanGestureInView:_rightImageView];
        
        [self.subContentView addSubview:_rightImageView];
    }
    return _rightImageView;
}


- (BOTHTimeView *)timeLabel
{
    if(!_timeLabel)
    {
        BOTHTimeView *titleLabel = [[BOTHTimeView alloc] initWithFrame:CGRectMake(self.width - 250 - 5, 0, 250, 30)];
        titleLabel.text = @"";
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:titleLabel];
        _timeLabel = titleLabel;
    }
    return _timeLabel;
}

- (UIPanGestureRecognizer *)addPanGestureInView:(UIView *)view
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [view addGestureRecognizer:pan];
    return pan;
}

- (UITapGestureRecognizer *)addTapGestureInView:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [view addGestureRecognizer:tap];
    return tap;
}

- (UIImageView *)dequeueImageViewWithIndex:(NSInteger)index
{
    
    if(_viewCache.count >0 && index >=0 && index < _viewCache.count)
    {
        return _viewCache[index];
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imagesContainer addSubview:imageView];
    [_viewCache addObject:imageView];
    return imageView;
}

- (void)setImages:(NSArray<UIImage *> *)images
{
    if(images.count > 0)
    {
        CGFloat xWidth = (self.imagesContainer.width)/images.count;
        CGFloat xHeight = [self.class preferHeight] ;
        CGFloat x_offset = 0;
        for(int ii =0; ii < images.count; ii ++)
        {
            UIImageView *imageView =[self dequeueImageViewWithIndex:ii];
            imageView.image = images[ii];
            imageView.frame = CGRectMake(x_offset, 0, xWidth, xHeight);
            x_offset += xWidth;
        }
    }
}

- (void)setSelectState:(NSInteger)state
{
    _selectState = state;
    self.leftImageView.image = [UIImage imageNamed:@"vivavideo_tool_clipedit_move_left_h"];
    self.rightImageView.image = [UIImage imageNamed:@"vivavideo_tool_clipedit_move_right_h"];
}

- (void)moveCursor:(BOOL)leftCursor withOffset:(CGFloat)offset state:(BOTHEditorRulerSlideState)state
{
    if(leftCursor)
    {
        self.leftImageView.left  = offset;
        self.leftImageView.right = MAX(kCursorW,MIN((self.rightImageView.left - self.limitDistance),self.leftImageView.right));
        self.leftMaskView.width  =   self.leftImageView.left ;
       self.leftProgress = self.min + (self.max - self.min) *(self.leftImageView.left/(kRulerW));
        if(self.sideSliderHandler)
        {
            self.sideSliderHandler(state,self.leftProgress);
        }
    }
    else
    {
        self.rightImageView.left  = offset;
        self.rightImageView.left = MAX(self.leftImageView.right + self.limitDistance,MIN(self.rightImageView.left,self.width - kCursorW));
        self.rightMaskView.width  =   self.width -  self.rightImageView.right;
        self.rightMaskView.left = self.rightImageView.right;
       self.rightProgress = self.min + (self.max - self.min) *((self.rightImageView.left - kCursorW)/(kRulerW));
        if(self.sideSliderHandler)
        {
            self.sideSliderHandler(state,self.rightProgress);
        }
    }
    
    [self.timeLabel setTime:self.rightProgress - self.leftProgress];
    __weak typeof(self) weakself = self;
    [self.curTimeTextLabel setTime:(offset/self.width)*self.max completeHandler:^(CGFloat width) {
        weakself.curTimeTextLabel.width = width;
    }];

}


- (UIImageView *)snapShot
{
    CGRect rect = CGRectMake(self.leftImageView.right, 0, self.rightImageView.left - self.leftImageView.right, self.imagesContainer.height);
    UIGraphicsBeginImageContext(self.imagesContainer.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    [self.imagesContainer.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    theImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(theImage.CGImage, rect)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:theImage];
    imageView.frame =  [self.subContentView convertRect:CGRectMake(self.leftImageView.right, 0, self.rightImageView.left - self.leftImageView.right, self.imagesContainer.height) toView:self];
    return  imageView;
}

- (void)setMin:(double)min
{
    _min = min;
    _leftProgress = min;
}

- (void)setMax:(double)max
{
    _max = max;
    _rightProgress = max;
    
    [self.timeLabel setTime:_max];
}
#pragma mark handleTap
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    BOOL isLeft = (tap.view == self.leftImageView);
    [self setSelectState: isLeft ? 1 : 2];
}
#pragma mark - handlepan
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    BOTHEditorRulerSlideState sliderState = BOTHEditorRulerSlideIdle;
    if(pan.view == self.cursorView)
    {
        int state = 0;
        if(pan.state == UIGestureRecognizerStateBegan)
        {
            sliderState = BOTHEditorRulerSlideBegin;
            state = 0;
             self.cursorView.centerX =  [pan locationInView:self].x;
        }
        if(pan.state == UIGestureRecognizerStateChanged)
        {
            sliderState = BOTHEditorRulerSlideMoving;
            state = 1;
            self.curTimeTextLabel.hidden = NO;
            self.cursorView.centerX =  [pan locationInView:self].x;
        }
        if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
        {
           self.cursorView.centerX =  [pan locationInView:self].x;
            state = 2;
            self.curTimeTextLabel.hidden = YES;
            sliderState = BOTHEditorRulerSlideEnd;
        }
        __weak typeof(self) weakself = self;
        [self.curTimeTextLabel setTime:198298 completeHandler:^(CGFloat width) {
            weakself.curTimeTextLabel.width = width;
        }];
        
        if(_cursorActionHandler)
        {
            _cursorActionHandler(state, (self.cursorView.centerX / (self.rightImageView.left - self.leftImageView.right)) * self.max);
        }
        if(self.sideSliderHandler)
        {
            self.sideSliderHandler(sliderState, (self.cursorView.centerX / (self.rightImageView.left - self.leftImageView.right)) * self.max);
        }
    }
    else
    {
        BOOL isLeft = (pan.view == self.leftImageView);
        if(pan.state == UIGestureRecognizerStateBegan)
        {
            sliderState = BOTHEditorRulerSlideBegin;
            [self setSelectState: isLeft ? 1 : 2];
            self.cursorView.hidden = YES;
        }
        if(pan.state == UIGestureRecognizerStateChanged)
        {
            sliderState = BOTHEditorRulerSlideMoving;
            [self moveCursor:isLeft withOffset: [pan locationInView:self].x state:sliderState];
            self.curTimeTextLabel.hidden = NO;
        }
        if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
        {
            sliderState = BOTHEditorRulerSlideEnd;
            [self moveCursor:isLeft withOffset: [pan locationInView:self].x state:sliderState];
            self.cursorView.hidden = NO;
            self.curTimeTextLabel.hidden = YES;
            if(isLeft)
            {
                self.cursorView.centerX = self.leftImageView.right - self.cursorView.width;
            }
            else
            {
                self.cursorView.centerX = self.rightImageView.left + self.cursorView.width;
            }
        }
    }
}


+ (CGFloat)preferHeight
{
    return 116.0;
}

@end
