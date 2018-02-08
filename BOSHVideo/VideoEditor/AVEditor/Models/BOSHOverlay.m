//
//  BOSHOverlay.m
//  BOSHVideo
//
//  Created by yang on 2017/11/21.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHOverlay.h"
#import "BOTHMacro.h"
#import <AVFoundation/AVFoundation.h>

/**
 *For GIF
 * @imageArray CGImage
 * @timeArray percent in duration
 */
static void extractImageInfoFromGIF(CFDataRef data,NSMutableArray *imageArray,CGFloat *width,CGFloat *height,CGFloat *frameDuration)
{
    *width = 0;
    *height = 0;
    *frameDuration = 0;
    NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:@{@0:(NSString *)kCGImagePropertyGIFLoopCount,@1:(NSString *)kCGImagePropertyGIFDelayTime} forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //拿到ImageSourceRef后获取gif内部图片个数
    CGImageSourceRef ref = CGImageSourceCreateWithData(data, (CFDictionaryRef)gifProperty);
    size_t count = CGImageSourceGetCount(ref);
    NSString *sourceType = (NSString *)CGImageSourceGetType(ref);
//    NSDictionary *properties = CFBridgingRelease(CGImageSourceCopyProperties(ref,nil));
    
    for (int i = 0; i < count; i++) {
        
        //添加图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(ref, i, (CFDictionaryRef)gifProperty);
        [imageArray addObject:CFBridgingRelease(imageRef)];
        
        //取每张图片的图片属性,是一个字典
        NSDictionary *dict = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(ref, i, (CFDictionaryRef)gifProperty));
        
        //取宽高
        if (width != NULL && height != NULL) {
            *width = [[dict valueForKey:(NSString *)kCGImagePropertyPixelWidth] floatValue];
            *height = [[dict valueForKey:(NSString *)kCGImagePropertyPixelHeight] floatValue];
        }
        
//        NSDictionary *gifDic = [dict valueForKey:(NSString *)kCGImagePropertyGIFDictionary];
//        if(gifDic && [gifDic isKindOfClass:NSDictionary.class])
//        {
//            *delayTime = [[gifDic valueForKey:(NSString *)kCGImagePropertyGIFDelayTime] floatValue];
//            *loopCount = [[gifDic valueForKey:(NSString *)kCGImagePropertyGIFLoopCount] floatValue];
//        }
        
        //添加每一帧时间
        NSDictionary *tmp = [dict valueForKey:(NSString *)kCGImagePropertyGIFDictionary];
        *frameDuration = [[tmp valueForKey:(NSString *)kCGImagePropertyGIFDelayTime] floatValue];
    }
}

@implementation BOSHOverlay

+ (instancetype)overlay
{
    return  [[self alloc] initWithType:BOSHOverlayTypeNone];
}

- (instancetype)initWithType:(BOSHOverlayType)type
{
    self = [super init];
    if(self)
    {
        self.type = type;
    }
    return self;
}

- (CALayer *)overlayer
{
    return nil;
}

- (void)setFrame:(CGRect)frame
{
    _frame = frame;
}

@end

///文本
@interface BOSHTextOverlay ()
{
    CATextLayer *_textLayer;
}
@end
@implementation BOSHTextOverlay

+ (instancetype)overlay
{
    return  [[self alloc] initWithType:BOSHOverlayTypeTEXT];
}

- (instancetype)initWithType:(BOSHOverlayType)type
{
    self = [super init];
    if(self)
    {
        self.type = type;
        self.textAlign = kCAAlignmentCenter;//默认
        self.textColor = [UIColor whiteColor];
        self.backColor = [UIColor clearColor];
    }
    return self;
}

- (CALayer *)overlayer
{
    if(_textLayer == nil)
    {
        _textLayer = [[CATextLayer alloc] init];
    }
    [_textLayer setFont:(__bridge CFTypeRef)self.font];//@"Helvetica-Bold"
    [_textLayer setFontSize:self.fontSize];
    [_textLayer setFrame:self.frame];
    [_textLayer setString:self.text];
    [_textLayer setAlignmentMode:self.textAlign];
    [_textLayer setForegroundColor:[self.textColor CGColor]];
    _textLayer.backgroundColor = self.backColor.CGColor;
    return _textLayer;
}

- (CGSize)sizeToFitWidth:(CGFloat)width
{
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : self.font, NSParagraphStyleAttributeName : style };
   return  [self.text boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:opts attributes:attributes context:nil].size;
}

- (void)addAnimation:(BOSHAnimation *)animation forKey:(NSString *)key
{
}

- (void)removeAnimationForKey:(NSString *)key
{
    
}

- (void)removeAllAnimations
{
    
}


@end

///GIF
@interface BOSHGifOverlay ()
{
    CALayer *_gifLayerInternal;
}
@end

@implementation BOSHGifOverlay


- (CALayer *)gitLayerOfGifURL:(NSURL *)URL
{
    if(_gifLayerInternal == nil)
    {
        URL =  [[NSBundle mainBundle] URLForResource:@"wx_seekfordeth.gif" withExtension:nil];
        NSData *data = [[NSData alloc] initWithContentsOfURL:URL];

        if(data == nil)
        {
            XLog("GIF URL invalid!!");
            return nil;
        }
        
        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *percentageArray = [NSMutableArray array];
        CGFloat width,height,totalTime,frameDuration;
        extractImageInfoFromGIF((__bridge CFDataRef)data,imageArray,&width,&height,&frameDuration);
        
        self.frameCount = imageArray.count;
        self.frameDuration = frameDuration;
        self.images = [NSArray arrayWithArray:imageArray];
        self.gifSize = CGSizeMake(width, height);
        totalTime = frameDuration*  (self.frameCount + 1);
        self.duration = totalTime;
        for(int ii = 0; ii < self.frameCount; ii++)
        {
            [percentageArray addObject:@(((ii + 1)* frameDuration)/((self.frameCount +1 )*frameDuration))];//浮点计算有误差 将总时间放大
        }
        self.timePoints = [NSArray arrayWithArray:percentageArray];
        self.gifData = data;
          _gifLayerInternal = [CALayer layer];
    }
    _gifLayerInternal.frame = self.frame;

    return _gifLayerInternal;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _gifLayerInternal.frame = frame;
}

//+ (CALayer *)gifLayer
//{
//    //读取GIF 数据
//    NSData *data = [[NSData alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"giphy-downsized.gif" ofType:nil]];
//
//    NSMutableArray *imageArray = [NSMutableArray array];
//    NSMutableArray *percentageArray = [NSMutableArray array];
//    CGFloat width,height,totalTime;
//    configImage((__bridge CFTypeRef)data,percentageArray,imageArray,&width,&height,&totalTime);
//
//    CALayer *layer = [CALayer layer];
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//    //获取每帧动画起始时间在总时间的百分比
//    [animation setKeyTimes:percentageArray];
//
//    [animation setBeginTime:0 + AVCoreAnimationBeginTimeAtZero];
//    //添加每帧动画
//    [animation setValues:imageArray];
//    //动画信息基本设置
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
//    [animation setDuration:totalTime];
//    //    [animation setDelegate:self];
//    [animation setRepeatCount:1000];
//
//    //添加动画
//    [layer addAnimation:animation forKey:@"gif"];
//
//    layer.bounds = CGRectMake(0, 0, width, height);
//    return layer;
//}


+ (instancetype)overlay
{
    return  [[self alloc] initWithType:BOSHOverlayTypeGIF];
}

- (instancetype)initWithType:(BOSHOverlayType)type
{
    self = [super init];
    if(self)
    {
        self.type = type;
    }
    return self;
}

- (CALayer *)overlayer
{
    return [self gitLayerOfGifURL:self.gifURL];
}

- (void)removeAllAnimations
{
    XLog(@"Child Class must override this Method:%s",__func__);
    [self doesNotRecognizeSelector:_cmd];
}

- (void)addAnimation:(BOSHAnimation *)animation forKey:(NSString *)key
{
    XLog(@"Child Class must override this Method:%s",__func__);
     [self doesNotRecognizeSelector:_cmd];
}

- (void)removeAnimationForKey:(NSString *)key
{
    XLog(@"Child Class must override this Method:%s",__func__);
     [self doesNotRecognizeSelector:_cmd];
}

@end

///PIC
@implementation BOSHPicOverlay

+ (instancetype)overlay
{
    return  [[self alloc] initWithType:BOSHOverlayTypePIC];
}


- (instancetype)initWithType:(BOSHOverlayType)type
{
    self = [super init];
    if(self)
    {
        self.type = type;
        self.contentsGravity = kCAGravityResizeAspectFill;
        
    }
    return self;
}

- (CALayer *)overlayer
{
    CALayer * imageLayer = [CALayer layer];
    imageLayer.frame = self.frame;
    imageLayer.masksToBounds = YES;
    imageLayer.contents = (id)self.image.CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
    return imageLayer;
}

@end


@implementation BOSHBorderOverlay

+ (instancetype)overlay
{
    return  [[self alloc] initWithType:BOSHOverlayTypeBorder];
}

- (instancetype)initWithType:(BOSHOverlayType)type
{
    self = [super initWithType:type];
    if(self)
    {
        self.type = type;
        self.contentsGravity = kCAGravityResizeAspectFill;
    }
    return self;
}

- (CALayer *)overlayer
{
    CALayer * imageLayer = [CALayer layer];
    imageLayer.frame = self.frame;
    imageLayer.masksToBounds = YES;
    imageLayer.contents = (id)self.image.CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
    
    //透明设置
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    maskLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGPathAddRect(path, nil, CGRectMake(self.borderMargin.left, self.borderMargin.top, self.frame.size.width - (self.borderMargin.left + self.borderMargin.right), self.frame.size.height - (self.borderMargin.top+self.borderMargin.bottom)));
    CGPathAddRect(path, nil,  CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
   [maskLayer setFillRule:kCAFillRuleEvenOdd];//填充的方式
    maskLayer.path = path;
    imageLayer.mask = maskLayer;

    return imageLayer;
}

@end
