//
//  BOSHEditorView.h
//  BOSHVideo
//
//  Created by yang on 2017/11/14.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BOSHEditorViewAction) {
    BOSHEditorViewActionSpeed,//调速
    BOSHEditorViewActionVolume,//
    BOSHEditorViewActionTransition,
    BOSHEditorViewActionSubtitles,
    BOSHEditorViewActionPasters,
    BOSHEditorViewActionWatermark,
};

@interface BOSHEditorView : UIView

@property (nonatomic, copy) typeof(void(^)(BOSHEditorViewAction actionType)) actionHandler;

@end
