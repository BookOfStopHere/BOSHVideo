//
//  PHAsset+BOTH.m
//  BOSHVideo
//
//  Created by yang on 2017/11/8.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "PHAsset+BOTH.h"

@implementation PHAsset (BOTH)


+ (void)copyVideoFromPHAsset:(PHAsset *)asset withQuality:(PHVideoRequestOptionsDeliveryMode)quality toPath:(NSString *)path Complete:(BOTHPHAssetVideoCompletionHanlder)result
{
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempBOTHVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    else if(resource.assetLocalIdentifier)
    {
        fileName = resource.assetLocalIdentifier;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = quality;
        
        NSString *PATH_MOVIE_FILE = [path stringByAppendingPathComponent:fileName];
        if([[NSFileManager defaultManager] fileExistsAtPath:PATH_MOVIE_FILE])
        {
            result(PATH_MOVIE_FILE, fileName);
            return;
        } 
//        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 result(PATH_MOVIE_FILE, fileName);
                                                             }
                                                         }];
    } else {
        result(nil, nil);
    }
}


+ (void)copyImageFromPHAsset:(PHAsset *)asset withQuality:(PHImageRequestOptionsDeliveryMode)quality complete:(BOTHPHAssetImageCompletionHanlder)result
{
    __block NSData *data;
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = quality;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:
         ^(NSData *imageData,
           NSString *dataUTI,
           UIImageOrientation orientation,
           NSDictionary *info) {
             data = [NSData dataWithData:imageData];
         }];
    }
    
    if (result) {
        if (data.length <= 0) {
            result(nil, nil);
        } else {
            result(data, resource.originalFilename);
        }
    }
}

@end
