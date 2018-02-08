//
//  BOTHThumbnailsView.m
//  BOSHVideo
//
//  Created by yang on 2017/11/8.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHThumbnailsView.h"
#import "UIView+Geometry.h"

@implementation BOTHThumbnailsView

- (void)setThumbnails:(NSArray *)thumbnails
{
    if (_thumbnails != thumbnails)
    {
        _thumbnails = thumbnails;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    if(self.thumbnails.count)
    {
        CGFloat xOffset = self.imagesInsets.left;
        CGFloat yOffset = self.imagesInsets.top;
        CGFloat width = (self.width - fabs(self.imagesInsets.left) - fabs(self.imagesInsets.right))/self.thumbnails.count;
        CGFloat height = (self.height - fabs(self.imagesInsets.top) - fabs(self.imagesInsets.bottom));
        
        for (UIImage *image in self.thumbnails)
        {
            [image drawInRect:CGRectMake(xOffset, yOffset, width, height)];
            xOffset += width;
        }
    }
}
@end
