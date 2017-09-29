//
//  BOTHPlayerView.h
//  BOSHVideo
//
//  Created by yang on 2017/9/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BOTHPlayer.h"

@interface BOTHPlayerView : UIView <BOTHPlaybackProtocol>



- (void)setPlayer:(BOTHPlayer *)player;

@end
