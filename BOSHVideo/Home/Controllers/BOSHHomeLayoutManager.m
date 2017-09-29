//
//  BOSHHomeLayoutManager.m
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHHomeLayoutManager.h"
#import "BOTHBlockView.h"
#import "UIView+Geometry.h"
#import "BOSDefines.h"
#define kOffset_Y
#define kBlock_W 130
#define kBlock_H 85
#define kSpace 10
#define kBlockSpace 10
#define kTagDefault 9901
#define kCamara2Block 25

@implementation BOSHHomeLayoutManager


- (instancetype)initWithTarget:(UIView *)target model:(NSArray <NSString *> *)stringSets
{
    self = [super init];
    if(self)
    {
        self.containerView = target;
        [self layoutSubviews];
    }
    return self;
}

- (BOTHBlockView *)newBlockView
{
    BOTHBlockView *bView =  [[NSBundle mainBundle] loadNibNamed:
                             @"BOTHBlockView" owner:nil options:nil ].lastObject;
    bView.textLab.text = @"生成Gif";
    bView.layer.borderWidth = 2;
    bView.iconView.layer.borderWidth = 2;
    bView.coverImageView.layer.borderWidth = 2;
    bView.coverImageView.image = BOSHIMG("btn_puzzle_start_normal");
    [self.containerView addSubview:bView];
    return bView;
}

- (void)layoutSubviews
{
    
    UIImageView *bgVIew = [[UIImageView alloc] initWithImage:BOSHIMG("bgStory")];
    bgVIew.userInteractionEnabled = YES;
    bgVIew.multipleTouchEnabled = YES;
    bgVIew.frame = self.containerView.bounds;
    [self.containerView addSubview:bgVIew];

    //
    BOTHBlockView *camaraBtn =  [[NSBundle mainBundle] loadNibNamed:
                                 @"BOTHBlockView" owner:nil options:nil ].lastObject;
    camaraBtn.frame = CGRectMake((self.containerView.width - 190/2)/2, (self.containerView.height - 190/2 - 15), 190/2, 190/2);
    camaraBtn.clipsToBounds = YES;
    camaraBtn.layer.cornerRadius = 190.0/4;
    camaraBtn.layer.masksToBounds = YES;
    [camaraBtn setImage:BOSHIMG("ic_camera_bg") forState:0];
    [self.containerView addSubview:camaraBtn];
    
    const CGFloat blockBottom =  camaraBtn.top - kCamara2Block;
    
    CGFloat dx = 0;
    CGFloat dy = 0;
    
    NSArray *images = @[@"btn_puzzle_start_normal",@"btn_puzzle_start_normal",@"btn_puzzle_start_normal",@"btn_puzzle_start_normal"];
    NSArray *types = @[@(BOSH_ACTION_JOIN_LONG_PICTURE),@(BOSH_ACTION_CREATE_GIF),@(BOSH_ACTION_EDIT_VIDEO),@(BOSH_ACTION_HELP)];

//生成block
    BOTHBlockView *bView = self.newBlockView;
    NSInteger type = ((NSNumber *)types[0]).integerValue;
    bView.textLab.text = [self fetchNameWithType:type];
    bView.frame = CGRectMake(kSpace,blockBottom - kBlock_H*2 - kBlockSpace, kBlock_W, kBlock_H);
    bView.coverImageView.image = [UIImage imageNamed:images[0]];
    bView.tag = kTagDefault + type;
    
    BOTHBlockView *bView1 = self.newBlockView;
    NSInteger type1 = ((NSNumber *)types[1]).integerValue;
    bView1.textLab.text = [self fetchNameWithType:type1];
    bView1.frame = CGRectMake(kSpace + kBlockSpace + kBlock_W, blockBottom - kBlock_H*2 - kBlockSpace, kBlock_W, kBlock_H);
    bView1.coverImageView.image = [UIImage imageNamed:images[1]];
    bView1.tag = kTagDefault + type1;
    
    BOTHBlockView *bView2 = self.newBlockView;
    NSInteger type2 = ((NSNumber *)types[2]).integerValue;
    bView2.textLab.text = [self fetchNameWithType:type2];
    bView2.frame = CGRectMake(kSpace, blockBottom - kBlock_H, kBlock_W, kBlock_H);
    bView2.coverImageView.image = [UIImage imageNamed:images[2]];
    bView2.tag = kTagDefault + type2;
    
    BOTHBlockView *bView3 = self.newBlockView;
    NSInteger type3 = ((NSNumber *)types[3]).integerValue;
    bView3.textLab.text = [self fetchNameWithType:type3];
    bView3.frame = CGRectMake(kSpace + kBlockSpace + kBlock_W, blockBottom - kBlock_H, kBlock_W, kBlock_H);
    bView3.coverImageView.image = [UIImage imageNamed:images[3]];
    bView3.tag = kTagDefault + type3;
}


- (NSString *)fetchNameWithType:(NSInteger)type
{
    switch (type) {
        case BOSH_ACTION_JOIN_LONG_PICTURE: return @"拼长图";
         case BOSH_ACTION_CREATE_GIF: return @"生成Gif";
        case BOSH_ACTION_EDIT_VIDEO: return @"视频剪辑";
        case BOSH_ACTION_HELP: return @"帮助说明";
        default:
            break;
    }
    
    return @"";
}
@end
