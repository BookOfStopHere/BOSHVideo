//
//  BOSHEditorCache.m
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHEditorCache.h"

@implementation BOSHEditorCache

- (void)dealloc
{
    [self.voiceSegments removeAllObjects];
    [self.videoSegments removeAllObjects];
    [self.gifOverlays removeAllObjects];
    [self.textOverlays removeAllObjects];
    [self.transitions removeAllObjects];
}

+ (instancetype)defaultCache
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.voiceSegments = [NSMutableArray array];
        self.videoSegments = [NSMutableArray array];
        self.gifOverlays = [NSMutableArray array];
        self.textOverlays = [NSMutableArray array];
        self.transitions = [NSMutableArray array];
        self.mute = NO;
        self.filterType = BOSHFilterTypeNone;
        self.borderOverlay = nil;
        self.watermark = nil;
    }
    return self;
}

@end
