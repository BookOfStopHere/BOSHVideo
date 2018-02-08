//
//  BOTHVideoPickerController.h
//  BOSHVideo
//
//  Created by yang on 2017/11/8.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"

@interface BOTHVideoPickerController : TZImagePickerController
{
    
}
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)delegate;
@end
