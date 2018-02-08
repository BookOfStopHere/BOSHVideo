//
//  BOSHUtils.m
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHUtils.h"
#import "BOTHMacro.h"
#import "BOSHDefines.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>
#import "BOSHPermissionRequest.h"

@implementation BOSHUtils

+ (NSString *)currentTimeYMDHMS
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:[NSDate date]];
    
    int year = (int)[comps year];
    int month =  (int)[comps month];
    int day = (int) [comps day];
    int hour =  (int)[comps hour];
    int min =  (int)[comps minute];
    int sec =  (int)[comps second];
    
    return [NSString stringWithFormat:@"%d-%d-%d-%d-%d-%d",year,month,day,hour,min,sec];
}

+ (void)convertMS:(double)time toHour:(long *)h min:(long*)min sec:(long *)sec ms:(long *)ms
{
    *sec = (long)(time/1000);
    *h = (*sec)/3600;
    *min = ((*sec)%3600)/60;
    *ms = (long)(time - (*sec)*1000);
    *sec = *sec - ((*h)*3600 + (*min)*60);
}

//https://www.2cto.com/kf/201610/555259.html
+ (void)writeVideoToPhotosAlbum:(NSURL *)URL completionHandler:(void(^)(NSURL *assetURL, NSError *error))completion
{
    if(URL == nil) {
        if(completion) completion(nil,[NSError errorWithDomain:CustomErrorDomain code:BOTHExportFileFailed userInfo:BOTHERROR("源文件地址为空")]);
        return;
    }
    if(BOSHIOS9Later)
    {
        if([BOSHPermissionRequest requestPermission:BOSHAuthorizationRequestTypePhotoLibrary] == BOSHAuthorizationStatusAuthorized)
        {
            PHPhotoLibrary * library = [PHPhotoLibrary sharedPhotoLibrary];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSError * error = nil;
                // 用来抓取PHAsset的字符串标识
                __block NSString *assetId = nil;
                // 用来抓取PHAssetCollectin的字符串标识符
                __block NSString *assetCollectionId = nil;
                
                // 保存视频到【Camera Roll】(相机胶卷)
                
                [library performChangesAndWait:^{
                    
                    assetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:URL].placeholderForCreatedAsset.localIdentifier;
                    
                } error:&error];
                // 获取曾经创建过的自定义视频相册名字
                PHAssetCollection  * createdAssetCollection = nil;
                PHFetchResult< PHAssetCollection *>* assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                for (PHAssetCollection * assetCollection in assetCollections) {
                    if ([assetCollection.localizedTitle isEqualToString: AssetCollectionName]) {
                        createdAssetCollection = assetCollection;
                        break;
                    }
                }
                //如果这个自定义框架没有创建过
                if (createdAssetCollection == nil) {
                    //创建新的[自定义的 Album](相簿\相册)
                    [library performChangesAndWait:^{
                        
                        assetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:AssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
                    } error:&error];
                    //抓取刚创建完的视频相册对象
                    createdAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionId] options:nil].firstObject;
                }
                
                // 将【Camera Roll】(相机胶卷)的视频 添加到 【自定义Album】(相簿\相册)中
                [library performChangesAndWait:^{
                    PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
                    
                    // 视频
                    [request addAssets:[PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil]];
                } error:&error];
                if(completion) completion(URL,error);
            });
        }
        else
        {
            if(completion) completion(nil,[NSError errorWithDomain:CustomErrorDomain code:BOTHExportFileFailed userInfo:BOTHERROR("未授权")]);
        }
    }
    else
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:URL]) {
            
            [library writeVideoAtPathToSavedPhotosAlbum:URL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(completion) completion(assetURL,error);
                });
            }];
        } else {
            NSLog(@"Video could not be exported to assets library.");
            if(completion) completion(nil,[NSError errorWithDomain:CustomErrorDomain code:BOTHExportFileFailed userInfo:BOTHERROR("Video could not be exported to assets library")]);
        }
    }

}
@end
