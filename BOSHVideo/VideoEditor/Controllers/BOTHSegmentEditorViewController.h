//
//  BOTHSegmentEditorViewController.h
//  BOSHVideo
//
//  Created by yang on 2017/10/31.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHBaseViewController.h"
#import "BOSHVideoItem.h"
#import "TZAssetModel.h"

@interface BOTHSegmentEditorViewController : BOSHBaseViewController

@property (nonatomic, assign) CGSize targetSize;

@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, strong) TZAssetModel *assetModel;

@property (nonatomic, copy) void(^addActionHandler)(BOSHVideoItem *item);

@end
