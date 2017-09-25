//
//  SSVideoWriter.h
//  SSCamera
//
//  Created by 1 on 17/1/21.
//  Copyright © 2017年 SSPlayer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface SSVideoWriter : NSObject
@property (nonatomic, copy) NSString *toPath;

+ (instancetype)writerWithPath:(NSString *)path;
-(void)dumpSampleBuffer:(CMSampleBufferRef)sampleBuffer motion:(CMDeviceMotion *)motion;

- (void)finishWriting;
@end
