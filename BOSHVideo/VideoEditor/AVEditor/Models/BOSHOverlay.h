//
//  BOSHOverlay.h
//  BOSHVideo
//
//  Created by yang on 2017/11/21.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BOSHAnimation.h"

typedef NS_ENUM(NSInteger,  BOSHOverlayType){
    BOSHOverlayTypeNone,//无
    BOSHOverlayTypeTEXT,//文字
   BOSHOverlayTypePIC,//图片
   BOSHOverlayTypeGIF,//动态图
   BOSHOverlayTypeBorder,//边框 需要特殊处理 更改videolayer
};
/**
 * 这个类主要是实现数据内容加载，最终生成CALayer，并不涉及
 * Animation的内容。动画是一个时间序列相关的，应该放在Timeline中进行
 * 处理。
 *  同一类型的，不同overlay，字段很多不同 适合应用继承的方式。
 */


@interface BOSHOverlay : NSObject

@property (nonatomic) BOSHOverlayType type;

@property (nonatomic) CGRect frame;

@property (nonatomic,strong) NSDictionary <BOSHAnimation*,NSString *> *animations;
@property (nonatomic, readonly) CALayer *overlayer;

- (instancetype)initWithType:(BOSHOverlayType)type;

//默认 BOSHOverlayTypeNone
+ (instancetype)overlay;


//Child Class must override this three Methods
- (void)addAnimation:(BOSHAnimation *)animation forKey:(NSString *)key;
- (void)removeAnimationForKey:(NSString *)key;
- (void)removeAllAnimations;

@end

/******************************************************************
 * 文本字幕Overlay
 ******************************************************************/

@interface BOSHTextOverlay : BOSHOverlay

/**
 * 字体
 */
@property (nonatomic, strong) UIFont *font;
@property (nonatomic)  float fontSize;

/**
 * 字体 默认white
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 * 文本
 */
@property (nonatomic, copy) NSString *text;

/**
 * 文本对齐
 * CA_EXTERN NSString * const kCAAlignmentNatural//
 * CA_AVAILABLE_STARTING (10.5, 3.2, 9.0, 2.0);
 * CA_EXTERN NSString * const kCAAlignmentLeft
 * CA_AVAILABLE_STARTING (10.5, 3.2, 9.0, 2.0);
 * CA_EXTERN NSString * const kCAAlignmentRight
 * CA_AVAILABLE_STARTING (10.5, 3.2, 9.0, 2.0);
 * CA_EXTERN NSString * const kCAAlignmentCenter
 * CA_AVAILABLE_STARTING (10.5, 3.2, 9.0, 2.0);
 * CA_EXTERN NSString * const kCAAlignmentJustified
 * CA_AVAILABLE_STARTING (10.5, 3.2, 9.0, 2.0);
 */
@property (nonatomic, copy) NSString *textAlign;//kCAAlignmentCenter 默认

/**
 * 背景颜色，默认无
 */
@property (nonatomic, strong) UIColor *backColor;

/**
 * 背景图片, 默认无 (仅支持CGImage创建的实例)
 */
@property (nonatomic, strong) UIImage *backImage;


- (CGSize)sizeToFitWidth:(CGFloat)width;

+ (instancetype)overlay;

@end

/******************************************************************
 * 动态图Overlay
 ******************************************************************/

@interface BOSHGifOverlay : BOSHOverlay

/**
 * URL
 */
@property (nonatomic, strong) NSURL *gifURL;

/**
 * Data
 */
@property (nonatomic, strong) NSData *gifData;


@property  (nonatomic) float frameDuration;
@property  (nonatomic) NSUInteger frameCount;
@property (nonatomic) CGSize gifSize;
@property (nonatomic) float duration;
/**
 * GIF 的图片序列 及  对应的时间序列
 */
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *timePoints;

+ (instancetype)overlay;

@end


/******************************************************************
 * 图片Overlay
 ******************************************************************/

@interface BOSHPicOverlay : BOSHOverlay

/**
 * Image
 */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGSize size;

/**
 *
 *   CA_EXTERN NSString * const kCAGravityCenter
 *  CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
 *   CA_EXTERN NSString * const kCAGravityTop
 *  CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
 *  CA_EXTERN NSString * const kCAGravityBottom
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityLeft
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityRight
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityTopLeft
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityTopRight
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityBottomLeft
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityBottomRight
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityResize
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityResizeAspect
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    CA_EXTERN NSString * const kCAGravityResizeAspectFill
 */
@property (nonatomic, copy) NSString *contentsGravity;//默认kCAGravityResizeAspectFill


+ (instancetype)overlay;

@end

/******************************************************************
 * 边框Overlay
 ******************************************************************/
@interface BOSHBorderOverlay : BOSHPicOverlay
//全部为正数，请与UIView 的contentInsets概念分开
@property (nonatomic) UIEdgeInsets borderMargin;

+ (instancetype)overlay;
@end
