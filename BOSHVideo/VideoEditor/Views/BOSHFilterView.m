//
//  BOSHFilterView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHFilterView.h"
#import "UIView+Geometry.h"
#import "BOTHMacro.h"

#define kHeight 72
#define kButtonW 57
#define kButtonH 72
#define kSpace 10
#define kFilterNUM 18
@interface BOSHFilterView ()
@property (nonatomic, strong) UIScrollView *filterContentView;
@end

@implementation BOSHFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
    self.filterContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (self.height - kHeight)/2, self.width, kHeight)];
    self.filterContentView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.filterContentView];
//    NSArray *arr = @[@"美白",@"高斯",@"对比",@"其他",@"美白",@"高斯",@"对比",@"其他",@"美白",@"高斯",@"对比",@"其他"];
    
    self.filterContentView.contentSize = CGSizeMake(kFilterNUM*kButtonW + kSpace, kHeight);
    CGFloat x_step = kSpace;
//    for(NSString *str in arr)
    for(int ii =0; ii < kFilterNUM; ii ++ )
    {
        UIButton *filterButton  = [[UIButton alloc] initWithFrame:CGRectMake(x_step, 5, kButtonW, kButtonH)];
        filterButton.clipsToBounds = YES;
//        filterButton.layer.cornerRadius = kButtonH/2;
//        filterButton.layer.borderWidth = 3;
        
        filterButton.layer.masksToBounds = NO;//很重要
        filterButton.layer.shadowOffset = CGSizeMake(0, 2);
        filterButton.layer.shadowColor = [UIColor grayColor].CGColor;
        filterButton.layer.shadowOpacity = .5;
        filterButton.layer.shadowPath =  [[UIBezierPath bezierPathWithRoundedRect:filterButton.bounds  cornerRadius:8] CGPath];
        [filterButton setImage:[self getImageAtIndex:ii] forState:UIControlStateNormal];
        [self.filterContentView  addSubview:filterButton];
        x_step += kHeight;
    }
}

- (UIImage *)getImageAtIndex:(NSInteger)index
{
    UIImage *image = nil;
    switch (index) {
        case 0: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];
            
            break;
        }
        case 1: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileAmaro" ofType:@"png"]];
            
            break;
        }
        case 2: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileRise" ofType:@"png"]];
            
            break;
        }
        case 3: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHudson" ofType:@"png"]];
            
            break;
        }
        case 4: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileXpro2" ofType:@"png"]];
            
            break;
        }
        case 5: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSierra" ofType:@"png"]];
            
            break;
        }
        case 6: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLomoFi" ofType:@"png"]];
            
            break;
        }
        case 7: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileEarlybird" ofType:@"png"]];
            
            break;
        }
        case 8: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSutro" ofType:@"png"]];
            
            break;
        }
        case 9: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileToaster" ofType:@"png"]];
            
            break;
        }
        case 10: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileBrannan" ofType:@"png"]];
            
            break;
        }
        case 11: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileInkwell" ofType:@"png"]];
            
            break;
        }
        case 12: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileWalden" ofType:@"png"]];
            
            break;
        }
        case 13: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHefe" ofType:@"png"]];
            
            break;
        }
        case 14: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileValencia" ofType:@"png"]];
            
            break;
        }
        case 15: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNashville" ofType:@"png"]];
            
            break;
        }
        case 16: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTile1977" ofType:@"png"]];
            
            break;
        }
        case 17: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLordKelvin" ofType:@"png"]];
            break;
        }
            
        default: {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];
            
            break;
        }
    }
    return image;
}
@end
