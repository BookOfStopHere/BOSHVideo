//
//  BOSHTextOverlayContainer.m
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHTextOverlayContainer.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"

@interface BOSHTextOverlayContainer ()<UITextViewDelegate>
@end

@implementation BOSHTextOverlayContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.textView = [[UITextView alloc] initWithFrame:self.bounds];
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.font = [UIFont fontWithName:@"-hyw" size:30];
//        [UIFont boldSystemFontOfSize:30];
        self.textView.textColor = UIColorFromRGB(0xC67171);
        self.textView.scrollEnabled = NO;
        self.textView.selectedRange = NSMakeRange(0,0);
        self.textView.editable = YES;
        [self addSubview:self.textView];
        self.textView.tintColor = UIColorFromRGB(0xff6347);
       
        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSelf:)]];
    }
    return self;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    textView.height = MAX(textView.contentSize.height,textView.height);
    self.height = textView.height;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self showKeyborad];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = self.bounds;
}

- (void)showKeyborad
{
    [self.textView becomeFirstResponder];
}

- (void)dismissKeyborad
{
    [self.textView resignFirstResponder];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if(![view isDescendantOfView:self])
    {
        if(self.textView.isFirstResponder)
        {
            [self.textView resignFirstResponder];
        }
    }
    else
    {
        if(CGRectContainsPoint(CGRectMake(self.width - 40, self.height - 40, 40, 40 ), point))
        {
            return self;
        }
    }
    return view;
}


- (void)deleteSelf:(UILongPressGestureRecognizer *)longGes
{
    if(longGes.state == UIGestureRecognizerStateBegan)
    {
        self.backgroundColor = UIColorFromRGB(0xFF4500);
        CAKeyframeAnimation *keyAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        [keyAni setKeyTimes:@[@0.2,@0.4,@0.6,@0.8,@1]];
        [keyAni setValues:@[@(1.1),@(1),@(1.1),@1]];

        CAKeyframeAnimation *opacityAni = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        [opacityAni setKeyTimes:@[@0.2,@0.4,@0.6,@0.8,@1]];
        [opacityAni setValues:@[@(1),@0.8,@(0.1),@0.7,@(1)]];

        CAAnimationGroup *groupAni = [CAAnimationGroup animation];
        groupAni.animations = @[keyAni,opacityAni];
        groupAni.duration = .5;
        groupAni.repeatCount = 2;
//
        [self.layer addAnimation:groupAni forKey:@"groupAni"];
    }
    else if(longGes.state == UIGestureRecognizerStateEnded)
    {
        [self removeFromSuperview];
    }
}

@end
