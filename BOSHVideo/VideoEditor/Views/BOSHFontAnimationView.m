//
//  BOSHFontAnimationView.m
//  BOSHVideo
//
//  Created by yang on 2017/12/5.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHFontAnimationView.h"
#import <CoreText/CoreText.h>
#import "BOTHMacro.h"
#define kDuration 4

@interface BOSHFontAnimationView ()
@property (nonatomic) CAShapeLayer *pathLayer;
@property (nonatomic) CALayer *penLayer;
@end
@implementation BOSHFontAnimationView


- (instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if(self)
    {
        [self prepare];
    }
    return self;
}


- (void)prepare
{
    

    
    CGMutablePathRef letters = CGPathCreateMutable();   //创建path
    
    CTFontRef font = CTFontCreateWithName(CFSTR("-hyw"), 80, NULL);       //设置字体CFSTR("Helvetica-Bold")
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           (__bridge id)nil, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"BOSHVideo" attributes:attrs];//@""
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);   //创建line
    CFArrayRef runArray = CTLineGetGlyphRuns(line);     //根据line获得一个数组
    
    // 获得每一个 run
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
//     for (CFIndex runIndex = CFArrayGetCount(runArray) - 1; runIndex >= 0; runIndex--)
    {
        // 获得 run 的字体
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // 获得 run 的每一个形象字
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
//         for (CFIndex runGlyphIndex = CTRunGetGlyphCount(run) - 1; runGlyphIndex >= 0; runGlyphIndex--)
        {
            // 获得形象字
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            //获得形象字信息
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // 获得形象字外线的path
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    //根据构造出的 path 构造 bezier 对象
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    //根据 bezier 创建 shapeLayer对象
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    [self.layer addSublayer:pathLayer];
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = UIColorFromRGB(0x71C671).CGColor;
    //[[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = kDuration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    UIImage *penImage = [UIImage imageNamed:@"noun_project_347_2.png"];
    CALayer *penLayer = [CALayer layer];
    penLayer.contents = (id)penImage.CGImage;
    penLayer.anchorPoint = CGPointZero;
    penLayer.frame = CGRectMake(0.0f, 0.0f, penImage.size.width/4, penImage.size.height/4);
    [pathLayer addSublayer:penLayer];
    
    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = kDuration;
    penAnimation.path = path.CGPath;
    penAnimation.calculationMode = kCAAnimationPaced;
    [penLayer addAnimation:penAnimation forKey:@"penAnimation"];
    
    self.penLayer = penLayer;
    self.pathLayer = pathLayer;
}

- (void)startAnimation
{

    [self prepare];
}
@end
