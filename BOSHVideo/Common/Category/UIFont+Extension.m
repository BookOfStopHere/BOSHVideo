//
//  UIFont+Extension.m
//  BOSHVideo
//
//  Created by yang on 2017/11/2.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "UIFont+Extension.h"
#import "BOTHMacro.h"

@implementation UIFont (Extension)


+ (UIFont *)adaptFont:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:(fontSize * BOTHScale())];
}

+ (UIFont *)adaptBoldFont:(CGFloat)fontSize
{
    return [UIFont boldSystemFontOfSize:(fontSize *BOTHScale())];
}

@end
