//
//  BOTHVideoPickerController.m
//  BOSHVideo
//
//  Created by yang on 2017/11/8.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHVideoPickerController.h"
#import "TZPhotoPickerController.h"

@implementation BOTHVideoPickerController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)delegate
{
    return (self = [super initWithMaxImagesCount:maxImagesCount delegate:delegate]) ? self : nil;
}

@end
