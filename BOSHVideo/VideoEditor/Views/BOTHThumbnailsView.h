//
//  BOTHThumbnailsView.h
//  BOSHVideo
//
//  Created by yang on 2017/11/8.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOTHThumbnailsView : UIView
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets imagesInsets;
@property (nonatomic, strong) NSArray <UIImage *>*thumbnails;

@end
