//
//  AVURLAsset+Editor.m
//  BOSHVideo
//
//  Created by yang on 2017/10/24.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "AVURLAsset+Editor.h"



@implementation AVURLAsset (Editor)
@dynamic fps;

- (float)fps
{
    AVAssetTrack *vTrack = [[self tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    float fps = vTrack.nominalFrameRate;
    return fps;
}

@end
