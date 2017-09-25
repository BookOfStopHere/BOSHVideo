//
//  SSVideoWriter.m
//  SSCamera
//
//  Created by 1 on 17/1/21.
//  Copyright © 2017年 SSPlayer. All rights reserved.
//

//http://blog.csdn.net/zengconggen/article/details/7595449

#import "SSVideoWriter.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SSVideoWriter ()
@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *adaptor;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) BOOL isFinish;
@end

@implementation SSVideoWriter

+ (instancetype)writerWithPath:(NSString *)path
{
    SSVideoWriter *writer = [[SSVideoWriter alloc] initWithPath:path];
    return writer;
}

- (instancetype)initWithPath:(NSString *)path
{
    self =[super init];
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"motions.plist"];
    [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
    path =  [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    _toPath = [path copy];
    _queue = dispatch_queue_create("writer.queue", DISPATCH_QUEUE_SERIAL);
    _isFinish = NO;
    [self initVideoWriterWithPath:path];
    return self;
}

-(void)initVideoWriterWithPath:(NSString *)path
{
    
    CGSize size = CGSizeMake(240, 320);
    
    NSString *betaCompressionDirectory = path;
   
    
    NSError *error = nil;
    unlink([betaCompressionDirectory UTF8String]);
    //----initialize compression engine
    
    self.videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:betaCompressionDirectory]
                        
                                                 fileType:AVFileTypeMPEG4
                        
                                                    error:&error];
    self.videoWriter.shouldOptimizeForNetworkUse = YES;
    NSParameterAssert(_videoWriter);
    
    if(error)
        
        NSLog(@"error = %@", [error localizedDescription]);
    
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:
                                           
                                           [NSNumber numberWithDouble:1024*1024*12],AVVideoAverageBitRateKey,
//                                          AVVideoProfileLevelH264Main30,AVVideoProfileLevelKey,
                                           
                                           nil ];
    
    
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height],AVVideoHeightKey,videoCompressionProps,AVVideoCompressionPropertiesKey,
                                   
                                       @{
                                        AVVideoPixelAspectRatioHorizontalSpacingKey:@1,
                                         AVVideoPixelAspectRatioVerticalSpacingKey:
                                             @1.33
                                         },AVVideoPixelAspectRatioKey,
                                   
                                   
                                   nil];
    
    

    self.videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    
    
    NSParameterAssert(_videoWriterInput);
    
    
    
    _videoWriterInput.expectsMediaDataInRealTime = YES;
    
//    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
//    self.adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_videoWriterInput
//
//                                                                                   sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
//    
    NSParameterAssert(_videoWriterInput);
    
    NSParameterAssert([_videoWriter canAddInput:_videoWriterInput]);
    
    
    
    if ([_videoWriter canAddInput:_videoWriterInput])
    {
        NSLog(@"I can add this input");
        [_videoWriter addInput:_videoWriterInput];
    }
    else
    {
        NSLog(@"i can't add this input");
    }
}




- (void)dumpSampleBuffer:(CMSampleBufferRef)sampleBuffer motion:(CMDeviceMotion *)motion
{
    static long frame = 0;
    
    CMTime lastSampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    if( frame == 0 && _videoWriter.status != AVAssetWriterStatusWriting  )
    {
        [_videoWriter startWriting];
        [_videoWriter startSessionAtSourceTime:lastSampleTime];
    }
    
    if( _videoWriter.status > AVAssetWriterStatusWriting )
        
    {
        
        NSLog(@"Warning: writer status is %d", _videoWriter.status);
        
        if( _videoWriter.status == AVAssetWriterStatusFailed )
            
            NSLog(@"Error: %@", _videoWriter.error);
        return;
        
    }
//    
//    [_videoWriterInput requestMediaDataWhenReadyOnQueue:_queue usingBlock:^{
//        while ([_videoWriterInput isReadyForMoreMediaData])
//        {
//            if(++frame >= [m_mutableArrayDatas count])
//            {
//                [writerInput markAsFinished];
//                [videoWriter finishWriting];
//                [videoWriter release];
//                dispatch_release(dispatchQueue);
//                [NSThread detachNewThreadSelector:@selector(saveOneImageAndPlist) toTarget:self withObject:nil];
//                break;
//            }
//            CVPixelBufferRef buffer = NULL;
//            
//            int idx = frame;
//            UIImage *imageOld = [m_mutableArrayDatas objectAtIndex:idx];
//            // 给外部传递百分比
//            if (m_delegate && [m_delegate respondsToSelector:@selector(saveVideoWithProgress:)]) {
//                [m_delegate saveVideoWithProgress:(1.0f*frame/[m_mutableArrayDatas count])];
//            }
//            // 图片 cpmvert buffer
//            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[imageOld CGImage] size:size andSpeed:strSpeed andAngle:strAgle];
//            if (buffer)
//            {
//                //                RECORD_VIDEO_FPS
//                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, m_floatFPS)]) {
//                    dispatch_release(dispatchQueue);
//                    [self restoreDefault];
//                    // 出错的情况吓会执行这些。
//                    // 此处应该恢复刚进来的状况
//                    NSLog(@"视频录制出错了");
//                }else
//                    CFRelease(buffer);
//            }
//        }
//    }];
    
    if ([_videoWriterInput isReadyForMoreMediaData])
    {
        if( ![_videoWriterInput appendSampleBuffer:sampleBuffer] )
        {
            NSLog(@"Unable to write to video input");
        }
        else
        {
            NSLog(@"already write vidio");
        }
    }
    [self writeMotion:motion frameIndex:frame];
    if(self.isFinish)
    {
        [self finishWriting];
    }
    frame ++;
}

//通过这个方法写入数据
- (BOOL)encodeFrame:(CMSampleBufferRef) sampleBuffer isVideo:(BOOL)isVideo {
    //数据是否准备写入
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
        //写入状态为未知,保证视频先写入
        if (_videoWriter.status == AVAssetWriterStatusUnknown && isVideo) {
            //获取开始写入的CMTime
            CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
//            long s = CMSampleBufferGetSampleSize(sampleBuffer,0);
            //开始写入
            [_videoWriter startWriting];
            [_videoWriter startSessionAtSourceTime:startTime];
        }
        //写入失败
        if (_videoWriter.status == AVAssetWriterStatusFailed) {
            NSLog(@"writer error %@", _videoWriter.error.localizedDescription);
            return NO;
        }
        //判断是否是视频
        if (isVideo) {
            //视频输入是否准备接受更多的媒体数据
            if (_videoWriterInput.readyForMoreMediaData == YES) {
                //拼接数据
                [_videoWriterInput appendSampleBuffer:sampleBuffer];
                return YES;
            }
        }else {
//            //音频输入是否准备接受更多的媒体数据
//            if (_audioInput.readyForMoreMediaData) {
//                //拼接数据
//                [_audioInput appendSampleBuffer:sampleBuffer];
//                return YES;
//            }
        }
    }
    return NO;
}
//http://blog.csdn.net/yuzhongchun/article/details/22749521

//pitch是围绕X轴旋转，也叫做俯仰角，如图3所示。
//yaw是围绕Y轴旋转，也叫偏航角，如图4所示。
//roll是围绕Z轴旋转，也叫翻滚角，如图5所示。
- (void)writeMotion:(CMDeviceMotion *)motion frameIndex:(long)frameIndex
{
    dispatch_async(_queue, ^{
        CMDeviceMotion *deviceMotion = motion;
        if (deviceMotion != nil) {
            CMAttitude *attitude = deviceMotion.attitude;
            
            //        if (self.referenceAttitude != nil) {
            //            [attitude multiplyByInverseOfAttitude:self.referenceAttitude];
            //        } else {
            //            //NSLog(@"was nil : set new attitude", nil);
            //            self.referenceAttitude = deviceMotion.attitude;
            //        }
            float cRoll = -fabs(attitude.roll); // Up/Down landscape
            float cYaw = attitude.yaw;  // Left/ Right landscape
            float cPitch = attitude.pitch; // Depth landscape
            UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
            if (orientation == UIDeviceOrientationLandscapeRight ){
                cPitch = cPitch*-1; // correct depth when in landscape right
            }
            //写文件
            NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            //获取完整路径
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"motions.plist"];
            
            NSMutableDictionary *dictionary = nil;
            if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
            {
                dictionary = [NSMutableDictionary dictionary];
            }
            else
            {
                dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
            }
            
            [dictionary setObject:@{@"cRoll":floatToString(cRoll),@"cYaw":floatToString(cYaw),@"cPitch":floatToString(cPitch)} forKey:longToString(frameIndex)];
            BOOL isYES = [dictionary writeToFile:plistPath atomically:YES];
            NSLog(@"");
            
        }
    });

}


NSString *floatToString(float a)
{
    return  [NSString stringWithFormat:@"%f",a];
}

NSString *longToString(long a)
{
    return  [NSString stringWithFormat:@"%ld",a];
}

- (void)finishWriting
{
//    _videoWriter
    [_videoWriterInput markAsFinished];
    if(_videoWriter.status == AVAssetWriterStatusWriting)
    {
        [_videoWriter finishWritingWithCompletionHandler:^{
            
        }];
    }
    self.isFinish = YES;
}
@end
