//
//  PHAsset+BOTH.h
//  BOSHVideo
//
//  Created by yang on 2017/11/8.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Photos/Photos.h>
typedef void (^BOTHPHAssetVideoCompletionHanlder)(NSString *filePath, NSString *fileName);
typedef void (^BOTHPHAssetImageCompletionHanlder)(NSData *data, NSString *fileName);

@interface PHAsset (BOTH)

+ (void)copyVideoFromPHAsset:(PHAsset *)asset withQuality:(PHVideoRequestOptionsDeliveryMode)quality toPath:(NSString *)path Complete:(BOTHPHAssetVideoCompletionHanlder)result;

+ (void)copyImageFromPHAsset:(PHAsset *)asset withQuality:(PHImageRequestOptionsDeliveryMode)quality complete:(BOTHPHAssetImageCompletionHanlder)result;

@end
