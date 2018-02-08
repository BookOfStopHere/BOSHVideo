//
//  ViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/9/22.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "ViewController.h"
#import "BOSHVideoThumbCtx.h"
#import "BOSHGIFContext.h"
#import "BOSHUtils.h"
#import "UIImage+GIF.h"
#import "BOSHHomeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "BOTHPlayerView.h"
#import "BOSHCamaraViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AVPlayerItem+Extension.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MMDrawerController.h"
#import "BOTHMineViewController.h"
#import <GPUImage/GPUImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <GPUImage/GPUImageMovieComposition.h>
#import "BOSHOverlay.h"
#import "BOSHFile.h"
//#import "MWPhotoBrowser.h"
#import "BOTHVideoPickerController.h"

@interface ViewController ()
{
    UIScrollView *scroll ;BOSHVideoThumbCtx *ctx;
    
    UIImageView *imageView;
    
    BOTHPlayerView *playerView;
    
    AVAssetImageGenerator *imageGenerator;
    
    NSMutableArray *thumbnailCache;
    AVURLAsset* gen_asset;
    MMDrawerController * drawerController;
    
    
    GPUImageMovieWriter *_writer;
    GPUImageMovie *_movie;
    GPUImageOutput *_curFilter;
    GPUImageMovieComposition *_imageMovieComp;
}
@property (weak, nonatomic) IBOutlet UIScrollView *thumbScroll;

@property NSMutableArray *photos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200)];
    [self.view addSubview:imageView];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
//    scroll.layer.borderWidth = 2;
    [self.view addSubview:scroll];
}

- (IBAction)changeVolume:(id)sender {
    UISlider *slider = sender;
    [playerView.player.currentItem setMixVolume:slider.value];
}


- (NSURL *)exportURL {
    NSString *filePath = nil;
    NSUInteger count = 0;
    
    filePath = NSTemporaryDirectory();
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"123.mp4"]];
  if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
 {
     [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
 }

    return [NSURL fileURLWithPath:filePath];
}


- (IBAction)pictureVideoSlected {
    
    BOTHVideoPickerController *imagePickerVc = [[BOTHVideoPickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingMultipleVideo = YES;
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.showSelectBtn = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        ///
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (IBAction)pictureViewer {

//    self.photos = [NSMutableArray array];
//
//    // Add photos
////    [self.photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]]]];
//     [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509427647862&di=631e059962d225188944d812fbc3fe1f&imgtype=0&src=http%3A%2F%2Fpic7.nipic.com%2F20100613%2F2177138_130020091669_2.jpg"]]];
//     [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509427647862&di=631e059962d225188944d812fbc3fe1f&imgtype=0&src=http%3A%2F%2Fpic7.nipic.com%2F20100613%2F2177138_130020091669_2.jpg"]]];
//     [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509427647862&di=631e059962d225188944d812fbc3fe1f&imgtype=0&src=http%3A%2F%2Fpic7.nipic.com%2F20100613%2F2177138_130020091669_2.jpg"]]];
//     [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509427647862&di=631e059962d225188944d812fbc3fe1f&imgtype=0&src=http%3A%2F%2Fpic7.nipic.com%2F20100613%2F2177138_130020091669_2.jpg"]]];
//
//     [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/imgad/pic/item/72f082025aafa40febdcbc40a164034f78f01910.jpg"]]];
//
//    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/imgad/pic/item/72f082025aafa40febdcbc40a164034f78f01910.jpgg"]]];
//    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/imgad/pic/item/72f082025aafa40febdcbc40a164034f78f01910.jpg"]]];
//
//    // Add video with poster photo
//    MWPhoto *video = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent.cdninstagram.com/hphotos-xpt1/t51.2885-15/e15/11192696_824079697688618_1761661_n.jpg"]];
//    video.videoURL = [[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xpa1/t50.2886-16/11200303_1440130956287424_1714699187_n.mp4"];
//    [self.photos addObject:video];
//
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//
//    // Set options
//    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
//    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
//    browser.displaySelectionButtons = YES; // Whether selection buttons are shown on each image (defaults to NO)
//    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
//    browser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
//    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
//    browser.startOnGrid = YES; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
////    browser.autoPlayOnAppear = NO; // Auto-play first video
//
//    // Customise selection images to change colours if required
////    browser.customImageSelectedIconName = @"ImageSelected.png";
////    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
//
//    // Optionally set the current visible photo before displaying
//    [browser setCurrentPhotoIndex:1];
//
//    // Present
//    [self presentViewController:browser animated:YES completion:nil];
    
    // Manipulate
//    [browser showNextPhotoAnimated:YES];
//    [browser showPreviousPhotoAnimated:YES];
//    [browser setCurrentPhotoIndex:10];
}

//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return self.photos.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    if (index < self.photos.count) {
//        return [self.photos objectAtIndex:index];
//    }
//    return nil;
//}

//////系统自己生成过渡的AVMutableVideoCompositionInstruction
- (void)editVideo
{
    AVMutableComposition  * mixComposition = [[AVMutableComposition alloc] init];
    //Get the Asset file from bundle.
    NSURL *myMovieURL = [[NSBundle mainBundle] URLForResource:@"ss" withExtension:@"mp4"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //
        [self playVideo:myMovieURL];
        
        //create avfoundation asset file.
        AVURLAsset * movieAsset = [[AVURLAsset alloc] initWithURL:myMovieURL options:nil];
        
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compsitionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                      preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        AVMutableCompositionTrack *compositionVideoTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compsitionAudioTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSError *error = nil;
        
        BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration)
                                                                ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                                 atTime:kCMTimeZero
                                                                  error:&error];
        
        
        BOOL adudioInsertResult = [compsitionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration)
                                                                ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                                 atTime:kCMTimeZero
                                                                  error:&error];
        
        ///
        
        
        if (!videoInsertResult || nil != error) {
            //handle error
            return;
        }
        
        if (!adudioInsertResult || nil != error) {
            //handle error
            return;
        }
        
        double videoScaleFactor = 2;//超过（<0.5）两倍就没法播放了，或者慢超过2倍（> 2）也没有声音蛋疼
        CMTime videoDuration = movieAsset.duration;
        
        
        //    [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
        //                               toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
        
        //    [compsitionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
        //                              toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
        
        
        NSURL *myMovieURL1 = [[NSBundle mainBundle] URLForResource:@"110126" withExtension:@"mp4"];
        AVURLAsset * movieAsset1 = [[AVURLAsset alloc] initWithURL:myMovieURL1 options:nil];
        
        ///
        videoInsertResult = [compositionVideoTrackB insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset1.duration)
                                                            ofTrack:[[movieAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                             atTime:CMTimeSubtract(videoDuration,CMTimeMake(1, 1))
                                                              error:&error];
        
        adudioInsertResult = [compsitionAudioTrackB insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset1.duration)
                                                            ofTrack:[[movieAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                             atTime:CMTimeSubtract(videoDuration,CMTimeMake(1, 1))//videoDuration
                                                              error:&error];
        
        
        
        ///转场效果
        
        
        AVMutableVideoComposition *videoComp =  [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
        
        //        movieAsset1.
        //        AVMutableVideoCompositionInstruction *instruction =  [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        
        
        //        AVMutableVideoCompositionLayerInstruction *layer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        //        MIN(movieAsset1.naturalSize)
        
#define MMAX(A,B) (A > B ? A : B)
        videoComp.renderSize = CGSizeMake(MMAX(compositionVideoTrackB.naturalSize.width,compositionVideoTrack.naturalSize.width), MMAX(compositionVideoTrackB.naturalSize.height,compositionVideoTrack.naturalSize.height));
        
        videoComp.renderSize = CGSizeMake(640,360);
        videoComp.renderScale = 1;
        videoComp.frameDuration = CMTimeMake(1, 30);
        
        NSArray<id <AVVideoCompositionInstruction>> * instructions = videoComp.instructions;
        for(AVMutableVideoCompositionInstruction *ins in instructions)
        {
            NSInteger c = ins.layerInstructions.count;
            NSLog(@"%d",c);
            ins.enablePostProcessing = NO;
            if(ins.layerInstructions.count == 2)
            {
                AVMutableVideoCompositionLayerInstruction *fromLayer = ins.layerInstructions[0];
                AVMutableVideoCompositionLayerInstruction *toLayer =  ins.layerInstructions[1];


                [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:ins.timeRange];
                [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:ins.timeRange];


                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                               toEndTransform:CGAffineTransformRotate(CGAffineTransformMakeScale(0,0), M_PI)
                                                    timeRange:ins.timeRange];


                // Set a transform ramp on toLayer from all the way right of the screen to identity.
                [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeScale(1, 1)
                                             toEndTransform:CGAffineTransformIdentity
                                                  timeRange:ins.timeRange];
            }
        }
        //        videoComp.instructions.compositionInstruction.timeRange
        CMTime du = CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale);
        float ds = CMTimeGetSeconds(du) - 0.3;
        //        [layer setOpacityRampFromStartOpacity:0.8 toEndOpacity:0 timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(ds,1), CMTimeMakeWithSeconds(0.35, 1))];
        
        
        //        [layer setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange:CMTimeRangeMake(kCMTimeZero,du )];
        
        //         [layer setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange:instructions[0].timeRange];
        
        
        //        [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformIdentity
        //                                                  toEndTransform:CGAffineTransformMakeTranslation(-VIDEO_SIZE.width, 0.0)
        //                                                       timeRange:timeRange];
        //        // Set a transform ramp on toLayer from all the way right of the screen to identity.
        //        [toLayerInstruction setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(VIDEO_SIZE.width, 0.0)
        //                                                toEndTransform:CGAffineTransformIdentity
        //                                                     timeRange:timeRange];
        
        
        //        instruction.layerInstructions = @[layer];
        
        
        //        videoComp.instructions = @[instruction];
        
        //都是坑啊
        
        //这个overlay 不能应用于播放，只能自己设置动画 或者导出mp4之后才能使用
        //        CALayer *superLayer = [CALayer layer];
        //        superLayer.frame =CGRectMake(0, 0, compositionVideoTrack.naturalSize.width, compositionVideoTrack.naturalSize.height);
        //        AVVideoCompositionCoreAnimationTool *aTool = AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:(CALayer *)videoLayer inLayer:(CALayer *)animationLayer
        
        
        
        
        [self playVideoCom:mixComposition videoCom:videoComp];
    
    } );
}
- (IBAction)exportGPUImageVideo:(id)sender {
    [self exportGPUImageVideoWithURL:nil];
}



- (void)movieRecordingCompleted:(NSURL *)exportURL
{
    
    [_curFilter removeTarget:_writer];
    [_writer finishRecording];

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:exportURL completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                                        message:[error localizedRecoverySuggestion]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"成功"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
#if !TARGET_IPHONE_SIMULATOR
                //                    [[NSFileManager defaultManager] removeItemAtURL:exportURL error:nil];
                //                    [self playVideo:exportURL];
#endif
            });
        }];
    }
}
- (void)exportGPUImageVideoWithURL:(NSURL *)videoURL
{
     NSURL *exportURL = [self exportURL];
    _curFilter = [[GPUImageGaussianBlurFilter alloc] init];
    ((GPUImageGaussianBlurFilter *)_curFilter).blurRadiusInPixels = 30.0;
    
    
  _movie = [[GPUImageMovie alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"IMG_0212" ofType: @"MOV"]]];
    
    
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                   [ NSNumber numberWithInt: 2 ], AVNumberOfChannelsKey,
                                   [ NSNumber numberWithFloat: 16000.0 ], AVSampleRateKey,
                                   [ NSData dataWithBytes:&channelLayout length: sizeof( AudioChannelLayout ) ], AVChannelLayoutKey,
                                   [ NSNumber numberWithInt: 32000 ], AVEncoderBitRateKey,


                                   nil];
    
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264,AVVideoCodecKey,
                                   @(1920),AVVideoWidthKey,
                                   @(1080),AVVideoHeightKey,
                                   nil];

//    _writer = [[GPUImageMovieWriter alloc] initWithMovieURL:exportURL size:CGSizeMake(1080, 1920) fileType:(NSString *)kUTTypeMPEG4 outputSettings:videoSettings];
    
    _writer = [[GPUImageMovieWriter alloc] initWithMovieURL:exportURL size:CGSizeMake(1920/4, 1080/4)];
    _writer.encodingLiveVideo = NO;
    _writer.shouldPassthroughAudio = NO;

//    [_writer setHasAudioTrack:YES audioSettings:audioSettings];
    _writer.encodingLiveVideo = NO;
    _writer.shouldPassthroughAudio = NO;
//    _movie.audioEncodingTarget = _writer;
    _movie.playAtActualSpeed = NO;
    [_movie addTarget:_curFilter];
    [_curFilter addTarget:_writer];
    [_movie enableSynchronizedEncodingUsingMovieWriter:_writer];
    [_writer startRecording];
    [_movie startProcessing];
    
    __weak typeof(self) weakself = self;
    [_writer setCompletionBlock:^{
        NSLog(@"OK");
        
        [weakself movieRecordingCompleted:exportURL];
    }];
}

- (void)exportVideo:(AVMutableComposition *)mixComposition videoCom:(AVVideoComposition *)vComp
{
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                         presetName:AVAssetExportPresetMediumQuality];
    
    
    assetExport.outputURL = [self exportURL];
    assetExport.outputFileType = AVFileTypeMPEG4;
    assetExport.shouldOptimizeForNetworkUse = YES;
    assetExport.videoComposition = vComp;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        
        if(assetExport.error == nil)
        {
            //              [self playVideo:assetExport.outputURL];
        }
        NSURL *exportURL = assetExport.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:exportURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                                            message:[error localizedRecoverySuggestion]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                    else
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                            message:@"成功"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
#if !TARGET_IPHONE_SIMULATOR
                    //                    [[NSFileManager defaultManager] removeItemAtURL:exportURL error:nil];
//                    [self playVideo:exportURL];
#endif
                });
            }];
        } else {
            NSLog(@"Video could not be exported to assets library.");
        }
    }];
}



- (void)transitionStitch
{
    AVMutableComposition  * mixComposition = [[AVMutableComposition alloc] init];
    //Get the Asset file from bundle.
    NSURL *myMovieURL = [[NSBundle mainBundle] URLForResource:@"ss" withExtension:@"mp4"];
    
    //
    [self playVideo:myMovieURL];
    
    //create avfoundation asset file.
    AVURLAsset * movieAsset = [[AVURLAsset alloc] initWithURL:myMovieURL options:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compsitionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                  preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVMutableCompositionTrack *compositionVideoTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compsitionAudioTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError *error = nil;
    
    BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration)
                                                            ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                             atTime:kCMTimeZero
                                                              error:&error];
    
    
    BOOL adudioInsertResult = [compsitionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration)
                                                            ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                             atTime:kCMTimeZero
                                                              error:&error];
    
    ///
    
    
    if (!videoInsertResult || nil != error) {
        //handle error
        return;
    }
    
    if (!adudioInsertResult || nil != error) {
        //handle error
        return;
    }
    
    double videoScaleFactor = 2;//超过（<0.5）两倍就没法播放了，或者慢超过2倍（> 2）也没有声音蛋疼
    CMTime videoDuration = movieAsset.duration;
    
    
    //    [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                               toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
    
    //    [compsitionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                              toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
    
    
    NSURL *myMovieURL1 = [[NSBundle mainBundle] URLForResource:@"110126" withExtension:@"mp4"];
    AVURLAsset * movieAsset1 = [[AVURLAsset alloc] initWithURL:myMovieURL1 options:nil];
    
    ///
    videoInsertResult = [compositionVideoTrackB insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset1.duration)
                                                        ofTrack:[[movieAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                         atTime:CMTimeSubtract(videoDuration,CMTimeMake(1, 1))
                                                          error:&error];
    
    adudioInsertResult = [compsitionAudioTrackB insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset1.duration)
                                                        ofTrack:[[movieAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                         atTime:CMTimeSubtract(videoDuration,CMTimeMake(1, 1))
                                                          error:&error];
    
    
    NSURL *myMovieURL2 = [[NSBundle mainBundle] URLForResource:@"dsj" withExtension:@"mp4"];
    AVURLAsset * movieAsset2 = [[AVURLAsset alloc] initWithURL:myMovieURL2 options:nil];
    
    
    CMTime sTime = CMTimeAdd(CMTimeSubtract(videoDuration,CMTimeMake(1, 1)), movieAsset1.duration);
    videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset2.duration)
                                                       ofTrack:[[movieAsset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                        atTime:CMTimeSubtract(sTime,CMTimeMake(1, 1))
                                                         error:&error];
    
    adudioInsertResult = [compsitionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset2.duration)
                                                       ofTrack:[[movieAsset2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                        atTime:CMTimeSubtract(sTime,CMTimeMake(1, 1))
                                                         error:&error];
    
    ///转场效果
    AVMutableVideoComposition *videoComp =  [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
    
    //        movieAsset1.
    //        AVMutableVideoCompositionInstruction *instruction =  [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    
    //        AVMutableVideoCompositionLayerInstruction *layer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    //        MIN(movieAsset1.naturalSize)
    
#define MMAX(A,B) (A > B ? A : B)
    //        videoComp.renderSize = CGSizeMake(MMAX(compositionVideoTrackB.naturalSize.width,compositionVideoTrack.naturalSize.width), MMAX(compositionVideoTrackB.naturalSize.height,compositionVideoTrack.naturalSize.height));
    
    videoComp.renderSize = CGSizeMake(640,360);
    videoComp.renderScale = 1;
    videoComp.frameDuration = CMTimeMake(1, 30);
    
    NSArray<id <AVVideoCompositionInstruction>> * instructions = videoComp.instructions;
    int key = 1;
    for(AVMutableVideoCompositionInstruction *ins in instructions)
    {
        NSInteger c = ins.layerInstructions.count;
        NSLog(@"%d",c);
        //            ins.enablePostProcessing = NO;
        if(ins.layerInstructions.count == 2)
        {
            AVMutableVideoCompositionLayerInstruction *fromLayer = ins.layerInstructions[1 - key];
            AVMutableVideoCompositionLayerInstruction *toLayer =  ins.layerInstructions[key];
            
            float s = CMTimeGetSeconds(ins.timeRange.start);
            float d = CMTimeGetSeconds(ins.timeRange.duration);
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:ins.timeRange];
            [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:ins.timeRange];
            
            
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                           toEndTransform:CGAffineTransformRotate(CGAffineTransformMakeScale(0,0), M_PI)
                                                timeRange:ins.timeRange];
            
            
            // Set a transform ramp on toLayer from all the way right of the screen to identity.
            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeScale(1, 1)
                                         toEndTransform:CGAffineTransformIdentity
                                              timeRange:ins.timeRange];
            
            
            CGAffineTransform Scale = CGAffineTransformMakeScale(0.68f,0.68f);
            CGAffineTransform Move = CGAffineTransformMakeTranslation(0,0);
            [fromLayer setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
            
            key = 0;
        }
    }
    //        videoComp.instructions.compositionInstruction.timeRange
    CMTime du = CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale);
    float ds = CMTimeGetSeconds(du) - 0.3;
    
    
    [self playVideoCom:[mixComposition copy] videoCom:[videoComp copy]];
    
    [self addOverLayer:videoComp];
    [self  exportVideo:mixComposition videoCom:videoComp];
}


- (void)makeFireworksDisplay:(CALayer *)contentLayer
{
    // 粒子发射系统 的初始化
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = contentLayer.bounds;
    // 发射源的位置
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    // 发射源尺寸大小
    fireworksEmitter.emitterSize = CGSizeMake(viewBounds.size.width/2.0, 0.0);
    // 发射模式
    fireworksEmitter.emitterMode = kCAEmitterLayerOutline;
    // 发射源的形状
    fireworksEmitter.emitterShape = kCAEmitterLayerLine;
    // 发射源的渲染模式
    fireworksEmitter.renderMode =  kCAEmitterLayerOldestLast;//kCAEmitterLayerAdditive;
    // 发射源初始化随机数产生的种子
    fireworksEmitter.seed = (arc4random()%100)+1;
    contentLayer.beginTime = AVCoreAnimationBeginTimeAtZero;
    /**
     *  添加发射点
     一个圆（发射点）从底下发射到上面的一个过程
     */
    CAEmitterCell* rocket  = [CAEmitterCell emitterCell];
    rocket.birthRate = 1.0; //是每秒某个点产生的effectCell数量
    rocket.emissionRange = 0.25 * M_PI; // 周围发射角度
    rocket.velocity = 400; // 速度
    rocket.velocityRange = 100; // 速度范围
    rocket.yAcceleration = 75; // 粒子y方向的加速度分量
    rocket.lifetime = 1.02; // effectCell的生命周期，既在屏幕上的显示时间要多长。
    
    // 下面是对 rocket 中的内容，颜色，大小的设置
    rocket.contents = (id) [[UIImage imageNamed:@"icon_share_moments_highlighted"] CGImage];
    rocket.scale = 0.2;
    rocket.color = [[UIColor redColor] CGColor];
    rocket.greenRange = 1.0;
    rocket.redRange = 1.0;
    rocket.blueRange = 1.0;
    rocket.spinRange = M_PI; // 子旋转角度范围
    
    /**
     * 添加爆炸的效果，突然之间变大一下的感觉
     */
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    burst.birthRate = 1.0;
    burst.velocity = 0;
    burst.scale = 2.5;
    burst.redSpeed =-1.5;
    burst.blueSpeed =+1.5;
    burst.greenSpeed =+1.0;
    burst.lifetime = 0.35;
    
    /**
     *  添加星星扩散的粒子
     */
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    spark.birthRate = 400;
    spark.velocity = 125;
    spark.emissionRange = 2* M_PI;
    spark.yAcceleration = 75; //粒子y方向的加速度分量
    spark.lifetime = 3;
    
    spark.contents = (id) [[UIImage imageNamed:@"icon_camera_dot_red"] CGImage];
    spark.scaleSpeed =-0.2;
    spark.greenSpeed =-0.1;
    spark.redSpeed = 0.4;
    spark.blueSpeed =-0.1;
    spark.alphaSpeed =-0.25; // 例子透明度的改变速度
    spark.spin = 2* M_PI; // 子旋转角度
    spark.spinRange = 2* M_PI;
    
    // 将 CAEmitterLayer 和 CAEmitterCell 结合起来
    fireworksEmitter.emitterCells = [NSArray arrayWithObject:rocket];
    //在圈圈粒子的基础上添加爆炸粒子
    rocket.emitterCells = [NSArray arrayWithObject:burst];
    //在爆炸粒子的基础上添加星星粒子
    burst.emitterCells = [NSArray arrayWithObject:spark];
    // 添加到图层上
    [contentLayer addSublayer:fireworksEmitter];
    
}

- (IBAction)addFireEffect
{
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"s12" ofType: @"mp4"]] options:nil];
    dispatch_group_t group = dispatch_group_create();
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    dispatch_group_enter(group);
    [firstAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
    
#define TRANSITION_DURATION CMTimeMake(1, 1)
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        //        secondAsset = [firstAsset copy];
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration)  ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]  atTime:kCMTimeZero error:nil];
        
        
        /////////视频有旋转角度时的处理~
        
        CGFloat vH = firstTrack.naturalSize.height;
        CGFloat vW = firstTrack.naturalSize.width;
        ///
        AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        firstPass.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        
        
        
        float ii = CMTimeGetSeconds(firstAsset.duration);
        float dd = CMTimeGetSeconds(mixComposition.duration);
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        float scl = 640.0/vW;
        
        
        CGAffineTransform Scale = CGAffineTransformMakeScale(scl,scl);
        CGAffineTransform Move = CGAffineTransformMakeTranslation(0,-   (scl *vH - 640)/2);//基于中心点
        
        [FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
        
        
        
        
        firstPass.layerInstructions = @[FirstlayerInstruction];///这个有顺序之分的 数组下标小的 TOP
        
        
        
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];//[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
        // 每个转场都是一个 AVMutableVideoCompositionInstruction ，其中包含 from and to
        MainCompositionInst.instructions = [NSArray arrayWithObjects:firstPass,nil];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(640, 640);
        
        
        //增加gif
        CALayer *overlayLayer = [CALayer layer];
        overlayLayer.frame = CGRectMake(0, 0, MainCompositionInst.renderSize.width, MainCompositionInst.renderSize.height);
        [self makeFireworksDisplay:overlayLayer];
        
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, MainCompositionInst.renderSize.width, MainCompositionInst.renderSize.height);
        videoLayer.frame = CGRectMake(0, 0, MainCompositionInst.renderSize.width, MainCompositionInst.renderSize.height);
        
        
        
        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:overlayLayer];
        
        //        [self playVideoCom:[mixComposition copy] videoCom:[MainCompositionInst copy]];
        
        MainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        [self  exportVideo:mixComposition videoCom:MainCompositionInst];
    });
}

//gif
- (IBAction)addGifOverlayer
{
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"s12" ofType: @"mp4"]] options:nil];
    dispatch_group_t group = dispatch_group_create();
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    dispatch_group_enter(group);
    [firstAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
    
#define TRANSITION_DURATION CMTimeMake(1, 1)
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        //        secondAsset = [firstAsset copy];
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration)  ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]  atTime:kCMTimeZero error:nil];
        
        
        /////////视频有旋转角度时的处理~
        
        CGFloat vH = firstTrack.naturalSize.height;
        CGFloat vW = firstTrack.naturalSize.width;
        ///
        AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        firstPass.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        
        
        
        float ii = CMTimeGetSeconds(firstAsset.duration);
        float dd = CMTimeGetSeconds(mixComposition.duration);
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        float scl = 640.0/vW;
        
        
        CGAffineTransform Scale = CGAffineTransformMakeScale(scl,scl);
        CGAffineTransform Move = CGAffineTransformMakeTranslation(0,-   (scl *vH - 640)/2);//基于中心点
        
        [FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
        

        

        firstPass.layerInstructions = @[FirstlayerInstruction];///这个有顺序之分的 数组下标小的 TOP
        

        
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];//[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
        // 每个转场都是一个 AVMutableVideoCompositionInstruction ，其中包含 from and to
        MainCompositionInst.instructions = [NSArray arrayWithObjects:firstPass,nil];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(640, 640);
        
        
        //增加gif
//        CALayer *overlayLayer = [BOSHGifOverlay overlay].overlayer;
//        overlayLayer.frame = CGRectMake(80, 80, overlayLayer.bounds.size.width/2,  overlayLayer.bounds.size.height/2);
//        
//        
//        CALayer *overlayer2 = [BOSHGifOverlay gitLayerOfFile:[[NSBundle mainBundle] pathForResource:@"sh.gif" ofType:nil]];
//        overlayer2.frame = CGRectMake(0, 0, overlayLayer.bounds.size.width/2,  overlayLayer.bounds.size.height/2);
//        
//        CALayer *parentLayer = [CALayer layer];
//        CALayer *videoLayer = [CALayer layer];
//        parentLayer.frame = CGRectMake(0, 0, MainCompositionInst.renderSize.width, MainCompositionInst.renderSize.height);
//        videoLayer.frame = CGRectMake(0, 0, MainCompositionInst.renderSize.width, MainCompositionInst.renderSize.height);
//
//        [parentLayer addSublayer:videoLayer];
//        [parentLayer addSublayer:overlayLayer];
//        [parentLayer addSublayer:overlayer2];
//
////        [self playVideoCom:[mixComposition copy] videoCom:[MainCompositionInst copy]];
//
//         MainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        [self  exportVideo:mixComposition videoCom:MainCompositionInst];
    });
}


- (void)fixVideoSize
{
    AVMutableComposition  * mixComposition = [[AVMutableComposition alloc] init];
    //Get the Asset file from bundle.
    NSURL *myMovieURL = [[NSBundle mainBundle] URLForResource:@"ss" withExtension:@"mp4"];
    
    //
    [self playVideo:myMovieURL];
    
    //create avfoundation asset file.
    AVURLAsset * movieAsset = [[AVURLAsset alloc] initWithURL:myMovieURL options:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compsitionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                  preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVMutableCompositionTrack *compositionVideoTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compsitionAudioTrackB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError *error = nil;
    
    BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration)
                                                            ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                             atTime:kCMTimeZero
                                                              error:&error];
    
    
    BOOL adudioInsertResult = [compsitionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset.duration)
                                                            ofTrack:[[movieAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                             atTime:kCMTimeZero
                                                              error:&error];
    
    ///
    
    
    if (!videoInsertResult || nil != error) {
        //handle error
        return;
    }
    
    if (!adudioInsertResult || nil != error) {
        //handle error
        return;
    }
    
    double videoScaleFactor = 2;//超过（<0.5）两倍就没法播放了，或者慢超过2倍（> 2）也没有声音蛋疼
    CMTime videoDuration = movieAsset.duration;
    
    
    //    [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                               toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
    
    //    [compsitionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                              toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
    
    
    NSURL *myMovieURL1 = [[NSBundle mainBundle] URLForResource:@"110126" withExtension:@"mp4"];
    AVURLAsset * movieAsset1 = [[AVURLAsset alloc] initWithURL:myMovieURL1 options:nil];
    
    ///
    videoInsertResult = [compositionVideoTrackB insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset1.duration)
                                                        ofTrack:[[movieAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                         atTime:CMTimeSubtract(videoDuration,CMTimeMake(1, 1))
                                                          error:&error];
    
    adudioInsertResult = [compsitionAudioTrackB insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset1.duration)
                                                        ofTrack:[[movieAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                         atTime:CMTimeSubtract(videoDuration,CMTimeMake(1, 1))
                                                          error:&error];
    
    
    NSURL *myMovieURL2 = [[NSBundle mainBundle] URLForResource:@"dsj" withExtension:@"mp4"];
    AVURLAsset * movieAsset2 = [[AVURLAsset alloc] initWithURL:myMovieURL2 options:nil];
    
    
    CMTime sTime = CMTimeAdd(CMTimeSubtract(videoDuration,CMTimeMake(1, 1)), movieAsset1.duration);
    videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset2.duration)
                                                       ofTrack:[[movieAsset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                        atTime:CMTimeSubtract(sTime,CMTimeMake(1, 1))
                                                         error:&error];
    
    adudioInsertResult = [compsitionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieAsset2.duration)
                                                       ofTrack:[[movieAsset2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                        atTime:CMTimeSubtract(sTime,CMTimeMake(1, 1))
                                                         error:&error];
    
    ///转场效果
    AVMutableVideoComposition *videoComp =  [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
    
    //        movieAsset1.
    //        AVMutableVideoCompositionInstruction *instruction =  [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    
    //        AVMutableVideoCompositionLayerInstruction *layer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    //        MIN(movieAsset1.naturalSize)
    
#define MMAX(A,B) (A > B ? A : B)
    //        videoComp.renderSize = CGSizeMake(MMAX(compositionVideoTrackB.naturalSize.width,compositionVideoTrack.naturalSize.width), MMAX(compositionVideoTrackB.naturalSize.height,compositionVideoTrack.naturalSize.height));
    
    videoComp.renderSize = CGSizeMake(640,360);
    videoComp.renderScale = 1;
    videoComp.frameDuration = CMTimeMake(1, 30);
    
    NSArray<id <AVVideoCompositionInstruction>> * instructions = videoComp.instructions;
    int key = 1;
    for(AVMutableVideoCompositionInstruction *ins in instructions)
    {
        NSInteger c = ins.layerInstructions.count;
        NSLog(@"%d",c);
        //            ins.enablePostProcessing = NO;
        if(ins.layerInstructions.count == 2)
        {
            AVMutableVideoCompositionLayerInstruction *fromLayer = ins.layerInstructions[1 - key];
            AVMutableVideoCompositionLayerInstruction *toLayer =  ins.layerInstructions[key];
            
            float s = CMTimeGetSeconds(ins.timeRange.start);
            float d = CMTimeGetSeconds(ins.timeRange.duration);
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:ins.timeRange];
            [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:ins.timeRange];
            
            
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                           toEndTransform:CGAffineTransformRotate(CGAffineTransformMakeScale(0,0), M_PI)
                                                timeRange:ins.timeRange];
            
            
            // Set a transform ramp on toLayer from all the way right of the screen to identity.
            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeScale(1, 1)
                                         toEndTransform:CGAffineTransformIdentity
                                              timeRange:ins.timeRange];
            
            
            CGAffineTransform Scale = CGAffineTransformMakeScale(0.68f,0.68f);
            CGAffineTransform Move = CGAffineTransformMakeTranslation(0,0);
            [fromLayer setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
            
            key = 0;
        }
    }
    //        videoComp.instructions.compositionInstruction.timeRange
    CMTime du = CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale);
    float ds = CMTimeGetSeconds(du) - 0.3;
    
    
    [self playVideoCom:[mixComposition copy] videoCom:[videoComp copy]];
    
    [self addOverLayer:videoComp];
    [self  exportVideo:mixComposition videoCom:videoComp];
}


-(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle{
    
    CATransform3D transform =CATransform3DIdentity;//获取一个标准默认的CATransform3D仿射变换矩阵
    
    transform.m34=4.5/-2000;//透视效果
    
    transform=CATransform3DRotate(transform,angle,0,1,0);//获取旋转angle角度后的rotation矩阵。
    
    return transform;
    
}

- (IBAction)testEffectToVideo {
//filmorago 中的特效
//效果不太好， 目前不清楚 各种牛逼特效是怎么做的????????? 需要借鉴别人VLMC 等After Effects
    //两边加半透明的mask
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"IMG_0212" ofType: @"MOV"]] options:nil];
   AVURLAsset* secondAsset =  [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"fuck" ofType: @"mp4"]] options:nil];
    
    dispatch_group_t group = dispatch_group_create();
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    dispatch_group_enter(group);
    [firstAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
    dispatch_group_enter(group);
    [secondAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
#define TRANSITION_DURATION CMTimeMake(1, 1)
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        //        secondAsset = [firstAsset copy];
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];

        
        
        //Now we repeat the same process for the 2nd track as we did above for the first track.Note that the new track also starts at kCMTimeZero meaning both tracks will play simultaneously.
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration)  ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]  atTime:kCMTimeZero error:nil];
        
        
        /////////视频有旋转角度时的处理~
        
        CGFloat vH = firstTrack.naturalSize.height;
        CGFloat vW = firstTrack.naturalSize.width;
        CGAffineTransform perferTransform = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].preferredTransform;
        //https://stackoverflow.com/questions/24820164/get-scale-and-rotation-angle-from-cgaffinetransform
        CGFloat angle = atan2f(perferTransform.b, perferTransform.a);
        //        if(angle == M_PI_2)
        {
            vH = firstTrack.naturalSize.width;
            vW = firstTrack.naturalSize.height;
        }
        
        ///
        AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        firstPass.timeRange = CMTimeRangeMake(kCMTimeZero, secondAsset.duration);
        
        
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        float scl = 1280.0/vW;
        
        
        CGAffineTransform Scale = CGAffineTransformMakeScale(scl,scl);
        CGAffineTransform Move = CGAffineTransformMakeTranslation(0,-   (scl *vH - 1280.0)/2);//基于中心点
        
        [FirstlayerInstruction setTransform:CGAffineTransformConcat(perferTransform,CGAffineTransformConcat(Scale,Move))atTime:kCMTimeZero];
        
        
        
        
        
        AVMutableVideoCompositionLayerInstruction *fromLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        [fromLayerInstruction setOpacity:0.6 atTime:kCMTimeZero];
        
        
        
        firstPass.layerInstructions = @[fromLayerInstruction,FirstlayerInstruction];///这个有顺序之分的 数组下标小的 在后面
        
        
        
        
        ///这个地方在模拟器上有BUG  coremedia 崩溃
        
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];//[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
        // 每个转场都是一个 AVMutableVideoCompositionInstruction ，其中包含 from and to
        MainCompositionInst.instructions = [NSArray arrayWithObjects:firstPass,nil];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(1280, 720);
        [self playVideoCom:[mixComposition copy] videoCom:[MainCompositionInst copy]];
    });
}

- (IBAction)testLongVideoClip {
//长视频的处理原则

    //两边加半透明的mask
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"IMG_0212" ofType: @"MOV"]] options:nil];
//   __block AVURLAsset* secondAsset =  [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"110126" ofType: @"mp4"]] options:nil];
    firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"110126" ofType: @"mp4"]] options:nil];
    dispatch_group_t group = dispatch_group_create();
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    dispatch_group_enter(group);
    [firstAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
//    dispatch_group_enter(group);
//    [secondAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
//     ^{
//         dispatch_group_leave(group);
//     }];
    
#define TRANSITION_DURATION CMTimeMake(1, 1)
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
//        secondAsset = [firstAsset copy];
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
    
        //Now we repeat the same process for the 2nd track as we did above for the first track.Note that the new track also starts at kCMTimeZero meaning both tracks will play simultaneously.
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration)  ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]  atTime:kCMTimeZero error:nil];
        
     
     /////////视频有旋转角度时的处理~
        
        CGFloat vH = firstTrack.naturalSize.height;
        CGFloat vW = firstTrack.naturalSize.width;
        CGAffineTransform perferTransform = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].preferredTransform;
        //https://stackoverflow.com/questions/24820164/get-scale-and-rotation-angle-from-cgaffinetransform
        CGFloat angle = atan2f(perferTransform.b, perferTransform.a);
        if(angle >=  M_PI_2)
        {
             vH = firstTrack.naturalSize.width;
             vW = firstTrack.naturalSize.height;
        }
        
        ///
        AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        firstPass.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        
        
        
        float ii = CMTimeGetSeconds(firstAsset.duration);
        float dd = CMTimeGetSeconds(mixComposition.duration);
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        float scl = 640.0/vW;
      
        
        CGAffineTransform Scale = CGAffineTransformMakeScale(scl,scl);
        CGAffineTransform Move = CGAffineTransformMakeTranslation(0,-   (scl *vH - 640)/2);//基于中心点
        
       [FirstlayerInstruction setTransform:CGAffineTransformConcat(perferTransform,CGAffineTransformConcat(Scale,Move))atTime:kCMTimeZero];

        
        
        
       
        AVMutableVideoCompositionLayerInstruction *fromLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        
        
        CGFloat new_height = 640.0;
        CGFloat sscale = 640/ vH;
        
        CGFloat new_width = sscale  * vW;
        
        CGAffineTransform SecondTransform = CGAffineTransformMakeScale(sscale,sscale);
        CGAffineTransform SecondMove = CGAffineTransformMakeTranslation( (640 - new_width)/2,0);
        
        [fromLayerInstruction setTransform:CGAffineTransformConcat(perferTransform,CGAffineTransformConcat(SecondTransform,SecondMove)) atTime:kCMTimeZero];
        
        
        
        
       firstPass.layerInstructions = @[fromLayerInstruction,FirstlayerInstruction];///这个有顺序之分的 数组下标小的 TOP
        

        

        ///这个地方在模拟器上有BUG  coremedia 崩溃
        
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];//[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
        // 每个转场都是一个 AVMutableVideoCompositionInstruction ，其中包含 from and to
        MainCompositionInst.instructions = [NSArray arrayWithObjects:firstPass,nil];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(640, 640);
        
        
        
        CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
        [subtitle1Text setFont:@"Helvetica-Bold"];
        [subtitle1Text setFontSize:36];
        [subtitle1Text setFrame: CGRectMake(MainCompositionInst.renderSize.width/4,3*MainCompositionInst.renderSize.height/8,MainCompositionInst.renderSize.width/2, MainCompositionInst.renderSize.height/4)];
        [subtitle1Text setString:@"FUCK YOU"];
        [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
        [subtitle1Text setForegroundColor:[[UIColor redColor] CGColor]];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        CIImage *source = [CIImage imageWithCGImage:[UIImage imageNamed:@"vivavideo_setting_image_750x750_"].CGImage] ;
        [filter setValue:source forKey:kCIInputImageKey];
        // Vary filter parameters based on video timing
        [filter setValue:@(10) forKey:kCIInputRadiusKey];

        // Crop the blurred output to the bounds of the original image
        CIImage *output = [filter.outputImage imageByCroppingToRect:source.extent];
        
        CIContext *myContext = [[CIContext alloc] initWithOptions:nil];
        CGImageRef edgeImage = [myContext createCGImage:output fromRect:[output extent]];
        
        CALayer *leftLayer = [CALayer layer];
//        leftLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
        leftLayer.contents = (__bridge id)(edgeImage);
        leftLayer.contentsGravity = kCAGravityResizeAspectFill;
        leftLayer.masksToBounds = YES;
        
        leftLayer.frame = CGRectMake(0, 0, (640 - new_width)/2,  MainCompositionInst.renderSize.height);
        
        CALayer *rightLayer = [CALayer layer];
        rightLayer.contents =  (__bridge id) (edgeImage);
        rightLayer.contentsGravity = kCAGravityResizeAspectFill;
        rightLayer.masksToBounds = YES;
        rightLayer.frame = CGRectMake(640 - (640 - new_width)/2, 0, (640 - new_width)/2,  MainCompositionInst.renderSize.height);
        
        
        // 2 - The usual overlay
        CALayer *overlayLayer = [CALayer layer];
        [overlayLayer addSublayer:subtitle1Text];
        
        [overlayLayer addSublayer:rightLayer];
        [overlayLayer addSublayer:leftLayer];
        
        overlayLayer.frame = CGRectMake(0, 0,MainCompositionInst.renderSize.width, MainCompositionInst.renderSize.height);
        [overlayLayer setMasksToBounds:YES];
        
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, MainCompositionInst.renderSize.width, MainCompositionInst.renderSize.height);
        videoLayer.frame = CGRectMake(0, 0, MainCompositionInst.renderSize.width, MainCompositionInst.renderSize.height);
        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:overlayLayer];


    
//        _writer.encodingLiveVideo = NO;
//        _writer.shouldPassthroughAudio = NO;
//        _movie.audioEncodingTarget = _writer;
//        _movie.playAtActualSpeed = NO;
//        [_movie addTarget:_curFilter];
//        [_curFilter addTarget:_writer];
//        [_movie enableSynchronizedEncodingUsingMovieWriter:_writer];
//        [_writer startRecording];
//        [_movie startProcessing];
        
        
//        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//        AVMutableVideoComposition *composition = [AVMutableVideoComposition videoCompositionWithAsset: firstAsset
//                                                           applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
//                                                               // Clamp to avoid blurring transparent pixels at the image edges
//                                                               CIImage *source = [request.sourceImage imageByClampingToExtent];
//                                                               [filter setValue:source forKey:kCIInputImageKey];
//
//                                                               // Vary filter parameters based on video timing
//                                                               Float64 seconds = CMTimeGetSeconds(request.compositionTime);
//                                                               [filter setValue:@(30) forKey:kCIInputRadiusKey];
//
//                                                               // Crop the blurred output to the bounds of the original image
//                                                               CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
//
//                                                               // Provide the filter output to the composition
//                                                               [request finishWithImage:output context:nil];
//                                                           }];
        
//        composition.instructions = [NSArray arrayWithObjects:firstPass,nil];
//        composition.frameDuration = CMTimeMake(1, 30);
//        composition.renderSize = CGSizeMake(480, 480);
        
//          [self synchronizePlayerWithEditorCom:mixComposition videoCom:[MainCompositionInst copy]];
        [self playVideoCom:[mixComposition copy] videoCom:[MainCompositionInst copy]];
//         MainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
//        [self  exportVideo:mixComposition videoCom:MainCompositionInst];
        
         [self synchronizePlayerWithEditorCom:mixComposition videoCom:MainCompositionInst];
      
        
    });
}


- (void)addEfffectToVideo
{
    //视频增加特效
}

typedef enum {
    LBVideoOrientationUp,               //Device starts recording in Portrait
    LBVideoOrientationDown,             //Device starts recording in Portrait upside down
    LBVideoOrientationLeft,             //Device Landscape Left  (home button on the left side)
    LBVideoOrientationRight,            //Device Landscape Right (home button on the Right side)
    LBVideoOrientationNotFound = 99     //An Error occurred or AVAsset doesn't contains video track
} LBVideoOrientation;

//http://www.jianshu.com/p/52d1867b0aa4
static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
};

+ (LBVideoOrientation)videoOrientationWithAsset:(AVAsset *)asset
{
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if ([videoTracks count] == 0) {
        return LBVideoOrientationNotFound;
    }
    
    AVAssetTrack* videoTrack    = [videoTracks objectAtIndex:0];
    CGAffineTransform txf       = [videoTrack preferredTransform];
    CGFloat videoAngleInDegree  = RadiansToDegrees(atan2(txf.b, txf.a));
    
    LBVideoOrientation orientation = 0;
    switch ((int)videoAngleInDegree) {
        case 0:
            orientation = LBVideoOrientationRight;
            break;
        case 90:
            orientation = LBVideoOrientationUp;
            break;
        case 180:
            orientation = LBVideoOrientationLeft;
            break;
        case -90:
            orientation     = LBVideoOrientationDown;
            break;
        default:
            orientation = LBVideoOrientationNotFound;
            break;
    }
    
    return orientation;
}

- (IBAction)exportLongMovie {

    //padding 用Gaussian 模糊
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"weixinH" ofType: @"mp4"]] options:nil];
    //   __block AVURLAsset* secondAsset =  [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"110126" ofType: @"mp4"]] options:nil];
    
    dispatch_group_t group = dispatch_group_create();
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    dispatch_group_enter(group);
    [firstAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
    //    dispatch_group_enter(group);
    //    [secondAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
    //     ^{
    //         dispatch_group_leave(group);
    //     }];
    
#define TRANSITION_DURATION CMTimeMake(1, 1)
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        //        secondAsset = [firstAsset copy];
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];

        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration)  ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]  atTime:kCMTimeZero error:nil];
        
        
        /////////视频有旋转角度时的处理~
        
        CGFloat vH = firstTrack.naturalSize.height;
        CGFloat vW = firstTrack.naturalSize.width;
        CGAffineTransform perferTransform = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].preferredTransform;
        //https://stackoverflow.com/questions/24820164/get-scale-and-rotation-angle-from-cgaffinetransform
        CGFloat angle = atan2f(perferTransform.b, perferTransform.a);
        //        if(angle == M_PI_2)
        {
            vH = firstTrack.naturalSize.width;
            vW = firstTrack.naturalSize.height;
        }
        LBVideoOrientation oritation = [self.class videoOrientationWithAsset:firstAsset];
        if(oritation == LBVideoOrientationUp)
        {
            
        }
        else if(oritation == LBVideoOrientationRight)
        {
            
        }
        
        
        ///
        AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        firstPass.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);

        float ii = CMTimeGetSeconds(firstAsset.duration);
        float dd = CMTimeGetSeconds(mixComposition.duration);
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        float scl = 480.0/vW;
        
        
        CGAffineTransform Scale = CGAffineTransformMakeScale(scl,scl);
        CGAffineTransform Move = CGAffineTransformMakeTranslation(0,-   (scl *vH - 480)/2);//基于中心点
        
        [FirstlayerInstruction setTransform:CGAffineTransformConcat(perferTransform,CGAffineTransformConcat(Scale,Move))atTime:kCMTimeZero];
        
        
        firstPass.layerInstructions = @[FirstlayerInstruction];///这个有顺序之分的 数组下标小的 在后面
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];//[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
        // 每个转场都是一个 AVMutableVideoCompositionInstruction ，其中包含 from and to
        MainCompositionInst.instructions = [NSArray arrayWithObjects:firstPass,nil];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(480, 480);
    

        [self synchronizePlayerWithEditorCom:mixComposition videoCom:MainCompositionInst completionHandler:^(NSURL *movieURL) {
          ////局部变量各种坑
             AVURLAsset* secondAsset1 =  [AVURLAsset URLAssetWithURL:movieURL options:nil];
            [secondAsset1 loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
             ^{
                 
                 AVURLAsset* firstAsset1 = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"IMG_0212" ofType: @"MOV"]] options:nil];
                 [firstAsset1 loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
                  ^{
            
            AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
            
            //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
            AVMutableCompositionTrack *firstTrack1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
            [firstTrack1 insertTimeRange:CMTimeRangeMake(kCMTimeZero,secondAsset1.duration) ofTrack:[[secondAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            
            
            
            //Now we repeat the same process for the 2nd track as we did above for the first track.Note that the new track also starts at kCMTimeZero meaning both tracks will play simultaneously.
            AVMutableCompositionTrack *secondTrack1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            [secondTrack1 insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset1.duration) ofTrack:[[firstAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//
//
            AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset1.duration)  ofTrack:[[firstAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]  atTime:kCMTimeZero error:nil];
            
            
            /////////视频有旋转角度时的处理~
            
            CGFloat vH = firstTrack1.naturalSize.height;
            CGFloat vW = firstTrack1.naturalSize.width;
            CGAffineTransform perferTransform = [[firstAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].preferredTransform;
            //https://stackoverflow.com/questions/24820164/get-scale-and-rotation-angle-from-cgaffinetransform
            CGFloat angle = atan2f(perferTransform.b, perferTransform.a);
            //        if(angle == M_PI_2)
            {
                vH = firstTrack.naturalSize.width;
                vW = firstTrack.naturalSize.height;
            }
            
            ///
            AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            firstPass.timeRange = CMTimeRangeMake(kCMTimeZero, secondAsset1.duration);
            
            AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack1];

            [FirstlayerInstruction setTransform:[[secondAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].preferredTransform atTime:kCMTimeZero];

            
//
            AVMutableVideoCompositionLayerInstruction *fromLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack1];
            CGFloat new_height = 480;
            CGFloat sscale = 480/ vH;
            CGFloat new_width = sscale  * vW;
            CGAffineTransform SecondTransform = CGAffineTransformMakeScale(sscale,sscale);
            CGAffineTransform SecondMove = CGAffineTransformMakeTranslation( (480 - new_width)/2,0);
            [fromLayerInstruction setTransform:CGAffineTransformConcat(perferTransform,CGAffineTransformConcat(SecondTransform,SecondMove)) atTime:kCMTimeZero];

            firstPass.layerInstructions = @[fromLayerInstruction,FirstlayerInstruction];///这个有顺序之分的 数组下标小的 在后面
            
            AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];//[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
            // 每个转场都是一个 AVMutableVideoCompositionInstruction ，其中包含 from and to
            MainCompositionInst.instructions = [NSArray arrayWithObjects:firstPass,nil];
            MainCompositionInst.frameDuration = CMTimeMake(1, 30);
            MainCompositionInst.renderSize = CGSizeMake(480, 480);
            [self  exportVideo:mixComposition videoCom:MainCompositionInst];
                 
          }];
                 
             }];
        }];

    });
    
}

- (void)synchronizePlayerWithEditorCom:(AVAsset *)composition videoCom:(AVVideoComposition *)videoComposition completionHandler:(void(^)(NSURL *movieURL))finished
{
    GPUImageView * filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, 320, 240)];
    [self.view addSubview:filterView];
    
    _curFilter = [[GPUImageGaussianBlurFilter alloc] init];
    ((GPUImageGaussianBlurFilter *)_curFilter).blurRadiusInPixels = 10.0;
    [_curFilter addTarget:filterView];
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.MOV"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    _writer = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640, 480)];
    _writer.encodingLiveVideo = NO;
    _writer.shouldPassthroughAudio = NO;
    
    _imageMovieComp = [[GPUImageMovieComposition alloc] initWithComposition:composition andVideoComposition:videoComposition andAudioMix:nil];
    _imageMovieComp.playAtActualSpeed = YES;
    _imageMovieComp.runBenchmark = YES;

    
    [_imageMovieComp addTarget:_curFilter];
    [_curFilter addTarget:_writer];
    
    
    [_imageMovieComp enableSynchronizedEncodingUsingMovieWriter:_writer];
    _imageMovieComp.audioEncodingTarget = _writer;
    
    [_writer startRecording];
    [_imageMovieComp startProcessing];
     __weak typeof(self) weakSelf = self;
    [_writer setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf->_writer finishRecording];
        [strongSelf->_imageMovieComp endProcessing];
        finished(movieURL);
    }];
}
- (void)synchronizePlayerWithEditorCom:(AVAsset *)composition videoCom:(AVVideoComposition *)videoComposition
{
    
    GPUImageView * filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, 320, 240)];
    [self.view addSubview:filterView];
    
    //全部模糊
//    _curFilter = [[GPUImageGaussianBlurFilter alloc] init];
//    ((GPUImageGaussianBlurFilter *)_curFilter).blurRadiusInPixels = 30.0;
    //局部模糊
    
    _curFilter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    ((GPUImageGaussianSelectiveBlurFilter *)_curFilter).blurRadiusInPixels =60;
//    ((GPUImageGaussianSelectiveBlurFilter *)_curFilter).excludeCirclePoint = CGPointMake(240, 240);
    CGFloat angle = atan2f(135,240);
    ((GPUImageGaussianSelectiveBlurFilter *)_curFilter).excludeCircleRadius =  0.28;
    ((GPUImageGaussianSelectiveBlurFilter *)_curFilter).excludeBlurSize = 0;//设置成0
//    [(GPUImageGaussianSelectiveBlurFilter *) _curFilter setExcludeCirclePoint:CGPointMake(0,0)];
    [(GPUImageGaussianSelectiveBlurFilter *) _curFilter setAspectRatio:720/1280.0];
    
    [_curFilter addTarget:filterView];
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    _writer = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640, 480)];
    _writer.encodingLiveVideo = NO;
    _writer.shouldPassthroughAudio = NO;
    
    _imageMovieComp = [[GPUImageMovieComposition alloc] initWithComposition:composition andVideoComposition:videoComposition andAudioMix:nil];
    _imageMovieComp.playAtActualSpeed = YES;
    _imageMovieComp.runBenchmark = YES;
    
    
    
//
    [_imageMovieComp addTarget:_curFilter];
    [_curFilter addTarget:_writer];

    
    [_imageMovieComp enableSynchronizedEncodingUsingMovieWriter:_writer];
    _imageMovieComp.audioEncodingTarget = _writer;
    
    [_writer startRecording];
    [_imageMovieComp startProcessing];
    
//    CADisplayLink* dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
//    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//    [dlink setPaused:NO];
    
    __weak typeof(self) weakSelf = self;
    [_writer setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        
        [strongSelf->_writer finishRecording];
        [strongSelf->_imageMovieComp endProcessing];
        return;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (error) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
        else {
            NSLog(@"error mssg)");
        }
    }];
    
}


- (IBAction)testCompEncloseComp:(id)sender {
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"dsj" ofType: @"mp4"]] options:nil];
    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"ss" ofType: @"mp4"]] options:nil];
    
    
    AVURLAsset * audioSset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"1" ofType: @"mp3"]] options:nil];
    
    dispatch_group_t group = dispatch_group_create();
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    dispatch_group_enter(group);
    [firstAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
    dispatch_group_enter(group);
    [audioSset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:^{
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_enter(group);
    [secondAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
    
    #define TRANSITION_DURATION CMTimeMake(1, 1)
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        //Now we repeat the same process for the 2nd track as we did above for the first track.Note that the new track also starts at kCMTimeZero meaning both tracks will play simultaneously.
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        ///////时间一定要严格 保持连续不重叠
        //        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,CMTimeSubtract(firstAsset.duration, CMTimeMakeWithSeconds(1, 1))) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        //        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero , secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:CMTimeSubtract(firstAsset.duration, CMTimeMakeWithSeconds(1, 1))  error:nil];
        [audioTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(35, 1),CMTimeAdd(secondAsset.duration,CMTimeSubtract(firstAsset.duration, TRANSITION_DURATION)))  ofTrack:[[audioSset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
        //    CMTimeMultiplyByFloat64( secondAsset.duration,0.5)   获取帧率～～～～
        AVAssetTrack *vTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        float fps = vTrack.nominalFrameRate;// CMTimeMakeWithSeconds(/fps,1) 不好使， CMTimeMakeWithSeconds(1，fps )反而能工作
        CMTime fpstime = vTrack.minFrameDuration;
        ///如何取出一帧？？？？？？？？？？？？？？？？？？？？？
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:CMTimeSubtract(firstAsset.duration,TRANSITION_DURATION) error:nil];

        
        
//        AVMutableComposition* mixComposition1 = [[AVMutableComposition alloc] init];
//        [mixComposition1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(CMTimeAdd(secondAsset.duration, firstAsset.duration), CMTimeMake(1, 1))) ofAsset:mixComposition atTime:kCMTimeZero error:nil];
        
//       NSArray *tras =  [mixComposition1 tracksWithMediaType:AVMediaTypeVideo];
        
//        firstTrack = tras[0];
//        secondTrack = tras[1];
        
        AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        firstPass.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(firstAsset.duration,TRANSITION_DURATION));
        
      
        
        float ii = CMTimeGetSeconds(firstAsset.duration);
        float dd = CMTimeGetSeconds(mixComposition.duration);
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        float scl = MAX(640.0/firstTrack.naturalSize.width,480.0/firstTrack.naturalSize.height);
        CGAffineTransform Scale = CGAffineTransformMakeScale(scl,scl);
        CGAffineTransform Move = CGAffineTransformMakeTranslation(0,0);
        
        firstTrack.preferredTransform  = CGAffineTransformConcat(Scale,Move);
//        [FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];//与 [FirstlayerInstruction setOpacity:0 atTime:kCMTimeZero]; 有冲突会崩溃
        
        ////有问题  透明度 和  尺寸变换  不能同时进行
        
//        [FirstlayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move) toEndTransform:CGAffineTransformConcat(Scale,Move)
//                                                       timeRange: firstPass.timeRange];
        
        ///变换与透明度分开
//         AVMutableVideoCompositionLayerInstruction *oplayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        //
//        [oplayerInstruction setOpacity:0 atTime:kCMTimeZero];
        //           //入场动画 (开启这个在模拟器中有崩溃~~~~)
//        [FirstlayerInstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange:CMTimeRangeMake(kCMTimeZero, TRANSITION_DURATION)];
        
        
        firstPass.layerInstructions = @[FirstlayerInstruction];
        
        
        
        
        
        //中间过渡
        AVMutableVideoCompositionInstruction * transitionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        
        transitionInstruction.timeRange = CMTimeRangeMake(CMTimeSubtract(firstAsset.duration, TRANSITION_DURATION), TRANSITION_DURATION);
        
        
        AVMutableVideoCompositionLayerInstruction *fromLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        
        
        AVMutableVideoCompositionLayerInstruction *toLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        
        //动画一  Push (可以尝试 上下左右)
        //        [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move)
        //                                                  toEndTransform:CGAffineTransformConcat(CGAffineTransformMakeTranslation(-640, 0.0),CGAffineTransformConcat(Scale,Move) )
        //                                                       timeRange: transitionInstruction.timeRange];
        CGAffineTransform SecondScale = CGAffineTransformMakeScale(MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height),MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height));
        CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
        ////
        //        [toLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(CGAffineTransformMakeTranslation(640, 0.0),SecondScale)
        //                                                toEndTransform:SecondScale
        //                                                     timeRange: transitionInstruction.timeRange];
        
        //动画二 淡出 Dissolve
//                [toLayerInstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange: transitionInstruction.timeRange];
//                [fromLayerInstruction setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange: transitionInstruction.timeRange];
//
//                [fromLayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:transitionInstruction.timeRange.start];
//                [toLayerInstruction setTransform:SecondScale atTime:transitionInstruction.timeRange.start];
        
        
        //动画三   变小退出
        
        //        [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move)
        //                                                  toEndTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(0,0),CGAffineTransformMakeTranslation(320,240))
        //                                                       timeRange: transitionInstruction.timeRange];
        //        [toLayerInstruction setTransform:SecondScale atTime:transitionInstruction.timeRange.start];
        //
        //        transitionInstruction.layerInstructions = @[fromLayerInstruction,toLayerInstruction];
        
        //动画四 旋转变小退出
//                [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move) toEndTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(0,0),CGAffineTransformRotate(CGAffineTransformMakeTranslation(320,240),M_PI))
//                                                               timeRange: transitionInstruction.timeRange];
//                [toLayerInstruction setTransform:SecondScale atTime:transitionInstruction.timeRange.start];
        //
        //动画五
//        [toLayerInstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange: transitionInstruction.timeRange];
        [fromLayerInstruction setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange: transitionInstruction.timeRange];




        [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move)
                                                  toEndTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(10,10),CGAffineTransformMakeTranslation(-(10 - scl) * firstTrack.naturalSize.width/2,-(10 - scl) * firstTrack.naturalSize.height/2))
                                                       timeRange: transitionInstruction.timeRange];
        [toLayerInstruction setTransform:SecondScale atTime:transitionInstruction.timeRange.start];
        
        
        ////////////如果加入过渡动画 势必会影响视频的长度
        transitionInstruction.layerInstructions = @[fromLayerInstruction,toLayerInstruction];
        
        
        //第二段pass through
        AVMutableVideoCompositionInstruction * secondPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        secondPass.timeRange = CMTimeRangeMake(firstAsset.duration,CMTimeSubtract(secondAsset.duration,TRANSITION_DURATION));
        
        AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        
        //        CGAffineTransform SecondScale = CGAffineTransformMakeScale(MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height),MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height));
        //        CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
        [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondScale,SecondMove) atTime:firstAsset.duration];
        
        secondPass.layerInstructions = @[SecondlayerInstruction];
        
        
        ///这个地方在模拟器上有BUG  coremedia 崩溃
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];//[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:mixComposition];
        // 每个转场都是一个 AVMutableVideoCompositionInstruction ，其中包含 from and to
        MainCompositionInst.instructions = [NSArray arrayWithObjects:firstPass,transitionInstruction,secondPass,nil];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(640, 480);
        
        
        
        

        
        
        [self playVideoCom:[mixComposition copy] videoCom:MainCompositionInst];
        [self  exportVideo:mixComposition videoCom:MainCompositionInst];
        
    });
}
/**
 *
 * 单轨道居然能看到原始画面 + 动画的画面，而且第二个视频没法做透明度动画，只能做变换
 * 双轨就没有这个问题
 */
- (void)checkSingleTrackTransition
{
    /**
     * 1\ 尺寸不匹配也不能操作
     */
    AVURLAsset *set = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"IMG_0184" ofType: @"mp4"]] options:nil];
    
    NSArray <AVAssetTrack *> *tas = [set tracksWithMediaType:AVMediaTypeVideo];
    
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"dsj" ofType: @"mp4"]] options:nil];
    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"ss" ofType: @"mp4"]] options:nil];
    
    
        AVURLAsset * audioSset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"1" ofType: @"mp3"]] options:nil];
    
    dispatch_group_t group = dispatch_group_create();
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    dispatch_group_enter(group);
    [firstAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
     dispatch_group_enter(group);
    [audioSset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:^{
    dispatch_group_leave(group);
        
    }];
    
    dispatch_group_enter(group);
    [secondAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:
     ^{
         dispatch_group_leave(group);
     }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        

            //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
            AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
            //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
            AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
            //Now we repeat the same process for the 2nd track as we did above for the first track.Note that the new track also starts at kCMTimeZero meaning both tracks will play simultaneously.
            AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

        ///////时间一定要严格 保持连续不重叠
//        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,CMTimeSubtract(firstAsset.duration, CMTimeMakeWithSeconds(1, 1))) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero , secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:CMTimeSubtract(firstAsset.duration, CMTimeMakeWithSeconds(1, 1))  error:nil];
        [audioTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(35, 1),CMTimeAdd(secondAsset.duration,CMTimeSubtract(firstAsset.duration, CMTimeMakeWithSeconds(1, 1))))  ofTrack:[[audioSset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
            //    CMTimeMultiplyByFloat64( secondAsset.duration,0.5)   获取帧率～～～～
            AVAssetTrack *vTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            float fps = vTrack.nominalFrameRate;// CMTimeMakeWithSeconds(/fps,1) 不好使， CMTimeMakeWithSeconds(1，fps )反而能工作
            CMTime fpstime = vTrack.minFrameDuration;
            ///如何取出一帧？？？？？？？？？？？？？？？？？？？？？
            [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:CMTimeSubtract(firstAsset.duration,CMTimeMakeWithSeconds(1, 1)) error:nil];
        
        
                CGAffineTransform SecondScale0 = CGAffineTransformMakeScale(MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height),MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height));
        secondTrack.preferredTransform = SecondScale0;
        
            //See how we are creating AVMutableVideoCompositionInstruction object.This object will contain the array of our AVMutableVideoCompositionLayerInstruction objects.You set the duration of the layer.You should add the lenght equal to the lingth of the longer asset in terms of duration.
        
        //第一段
            AVMutableVideoCompositionInstruction * firstPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
             firstPass.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(firstAsset.duration,CMTimeMakeWithSeconds(1, 1)));
        
            float ii = CMTimeGetSeconds(firstAsset.duration);
            float dd = CMTimeGetSeconds(mixComposition.duration);
            AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
            float scl = MAX(640.0/firstTrack.naturalSize.width,480.0/firstTrack.naturalSize.height);
            CGAffineTransform Scale = CGAffineTransformMakeScale(scl,scl);
            CGAffineTransform Move = CGAffineTransformMakeTranslation(0,0);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
//
//           //入场动画
//            [FirstlayerInstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(1, 1))];

        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
            [FirstlayerInstruction1 setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(1, 1))];
//         [FirstlayerInstruction1 setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
        firstPass.layerInstructions = @[FirstlayerInstruction1,FirstlayerInstruction];
    //中间过渡
        AVMutableVideoCompositionInstruction * transitionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        
        transitionInstruction.timeRange = CMTimeRangeMake(CMTimeSubtract(firstAsset.duration, CMTimeMakeWithSeconds(1, 1)), CMTimeMakeWithSeconds(1, 1));
        
        
        AVMutableVideoCompositionLayerInstruction *fromLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        
        
        AVMutableVideoCompositionLayerInstruction *toLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        
                //动画一  Push (可以尝试 上下左右)
//        [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move)
//                                                  toEndTransform:CGAffineTransformConcat(CGAffineTransformMakeTranslation(-640, 0.0),CGAffineTransformConcat(Scale,Move) )
//                                                       timeRange: transitionInstruction.timeRange];
        CGAffineTransform SecondScale = CGAffineTransformMakeScale(MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height),MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height));
        CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
////
//        [toLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(CGAffineTransformMakeTranslation(640, 0.0),SecondScale)
//                                                toEndTransform:SecondScale
//                                                     timeRange: transitionInstruction.timeRange];
        
        //动画二 淡出 Dissolve
//        [toLayerInstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange: transitionInstruction.timeRange];
//        [fromLayerInstruction setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange: transitionInstruction.timeRange];
//
//        [fromLayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:transitionInstruction.timeRange.start];
//        [toLayerInstruction setTransform:SecondScale atTime:transitionInstruction.timeRange.start];
        
        
    //动画三   变小退出

//        [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move)
//                                                  toEndTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(0,0),CGAffineTransformMakeTranslation(320,240))
//                                                       timeRange: transitionInstruction.timeRange];
//        [toLayerInstruction setTransform:SecondScale atTime:transitionInstruction.timeRange.start];
//
//        transitionInstruction.layerInstructions = @[fromLayerInstruction,toLayerInstruction];
   
        //动画四 旋转变小退出
//        [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move) toEndTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(0,0),CGAffineTransformRotate(CGAffineTransformMakeTranslation(320,240),M_PI))
//                                                       timeRange: transitionInstruction.timeRange];
//        [toLayerInstruction setTransform:SecondScale atTime:transitionInstruction.timeRange.start];
//
        //动画五
        [toLayerInstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange: transitionInstruction.timeRange];
        [fromLayerInstruction setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange: transitionInstruction.timeRange];
        
        
        
        
        [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformConcat(Scale,Move)
            toEndTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(10,10),CGAffineTransformMakeTranslation(-(10 - scl) * firstTrack.naturalSize.width/2,-(10 - scl) * firstTrack.naturalSize.height/2))
                                                               timeRange: transitionInstruction.timeRange];
        [toLayerInstruction setTransform:SecondScale atTime:transitionInstruction.timeRange.start];
        
        
        ////////////如果加入过渡动画 势必会影响视频的长度
        transitionInstruction.layerInstructions = @[fromLayerInstruction,toLayerInstruction];
        
        
   //第二段pass through
        AVMutableVideoCompositionInstruction * secondPass = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        secondPass.timeRange = CMTimeRangeMake(firstAsset.duration,CMTimeSubtract(secondAsset.duration,CMTimeMakeWithSeconds(1, 1)));
        
        AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];

//        CGAffineTransform SecondScale = CGAffineTransformMakeScale(MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height),MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height));
//        CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
        [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondScale,SecondMove) atTime:firstAsset.duration];
        
        secondPass.layerInstructions = @[SecondlayerInstruction];

            AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        // 每个转场都是一个 AVMutableVideoCompositionInstruction ，其中包含 from and to
            MainCompositionInst.instructions = [NSArray arrayWithObjects:firstPass,transitionInstruction,secondPass,nil];
            MainCompositionInst.frameDuration = CMTimeMake(1, 30);
            MainCompositionInst.renderSize = CGSizeMake(640, 480);
        
        
            [self playVideoCom:[mixComposition copy] videoCom:[MainCompositionInst copy]];
        
            [self  exportVideo:mixComposition videoCom:MainCompositionInst];
        
    });
}

- (void)concatVidoes
{
    
    /**
     * 1\ 尺寸不匹配也不能操作
     */
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"dsj" ofType: @"mp4"]] options:nil];
    AVURLAsset * secondAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"ss" ofType: @"mp4"]] options:nil];
    
    //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    //Here we are creating the first AVMutableCompositionTrack.See how we are adding a new track to our AVMutableComposition.
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //Now we set the length of the firstTrack equal to the length of the firstAsset and add the firstAsset to out newly created track at kCMTimeZero so video plays from the start of the track.
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMultiplyByFloat64( firstAsset.duration,1)) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //Now we repeat the same process for the 2nd track as we did above for the first track.Note that the new track also starts at kCMTimeZero meaning both tracks will play simultaneously.
    AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
//    CMTimeMultiplyByFloat64( secondAsset.duration,0.5)   获取帧率～～～～
    AVAssetTrack *vTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    float fps = vTrack.nominalFrameRate;// CMTimeMakeWithSeconds(/fps,1) 不好使， CMTimeMakeWithSeconds(1，fps )反而能工作
    CMTime fpstime = vTrack.minFrameDuration;
    ///如何取出一帧？？？？？？？？？？？？？？？？？？？？？
    [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, fpstime) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    
    //See how we are creating AVMutableVideoCompositionInstruction object.This object will contain the array of our AVMutableVideoCompositionLayerInstruction objects.You set the duration of the layer.You should add the lenght equal to the lingth of the longer asset in terms of duration.
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];

   
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,  CMTimeMultiplyByFloat64( firstAsset.duration,1));
    
    float ii = CMTimeGetSeconds(firstAsset.duration);
    //We will be creating 2 AVMutableVideoCompositionLayerInstruction objects.Each for our 2 AVMutableCompositionTrack.here we are creating AVMutableVideoCompositionLayerInstruction for out first track.see how we make use of Affinetransform to move and scale our First Track.so it is displayed at the bottom of the screen in smaller size.(First track in the one that remains on top).
    AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
    CGAffineTransform Scale = CGAffineTransformMakeScale(0.7f,0.7f);
    CGAffineTransform Move = CGAffineTransformMakeTranslation(230,230);
    [FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
    [FirstlayerInstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(3, 1))];
//
    
    CGRect startCropRectangle = CGRectMake(0, 0, firstTrack.naturalSize.width*0.7,  firstTrack.naturalSize.height*0.7),endCropRectangle = CGRectMake((firstTrack.naturalSize.width*0.7 - 200)/2,(firstTrack.naturalSize.width*0.7 - 200 *  firstTrack.naturalSize.height/ firstTrack.naturalSize.width)/2, 200, 200 *  firstTrack.naturalSize.height/ firstTrack.naturalSize.width );
//    CMTimeRange tRange ;
//    [FirstlayerInstruction getCropRectangleRampForTime:kCMTimeZero startCropRectangle:&startCropRectangle endCropRectangle:&endCropRectangle timeRange:&tRange];
//
//    endCropRectangle.size.width /=2;
    [FirstlayerInstruction setCropRectangleRampFromStartCropRectangle:(CGRect)startCropRectangle toEndCropRectangle:(CGRect)endCropRectangle timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(5, 1))];
//        [FirstlayerInstruction setTransform:Scale atTime:kCMTimeZero];
    //Here we are creating AVMutableVideoCompositionLayerInstruction for out second track.see how we make use of Affinetransform to move and scale our second Track.
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
    
    
    CGAffineTransform SecondScale = CGAffineTransformMakeScale(MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height),MAX(640.0/secondTrack.naturalSize.width,480.0/secondTrack.naturalSize.height));
    CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);

    
    [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondScale,SecondMove) atTime:kCMTimeZero];

    
//     [SecondlayerInstruction setTransform:SecondScale atTime:kCMTimeZero];
    
    //Now we add our 2 created AVMutableVideoCompositionLayerInstruction objects to our AVMutableVideoCompositionInstruction in form of an array.
    MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];;
    
    //Now we create AVMutableVideoComposition object.We can add mutiple AVMutableVideoCompositionInstruction to this object.We have only one AVMutableVideoCompositionInstruction object in our example.You can use multiple AVMutableVideoCompositionInstruction objects to add multiple layers of effects such as fade and transition but make sure that time ranges of the AVMutableVideoCompositionInstruction objects dont overlap.
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];

    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    MainCompositionInst.renderSize = CGSizeMake(640, 480);
    
    
   [self playVideoCom:[mixComposition copy] videoCom:[MainCompositionInst copy]];
    
//  [self  exportVideo:mixComposition videoCom:MainCompositionInst];
}

- (IBAction)editVideo:(id)sender
{
    
//    [self concatVidoes];
    [self editVideo];
//    [self checkSingleTrackTransition];

}



- (void)addOverLayer:(AVMutableVideoComposition *)videoComposition
{
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    [subtitle1Text setFrame: CGRectMake(videoComposition.renderSize.width/4,3*videoComposition.renderSize.height/8,videoComposition.renderSize.width/2, videoComposition.renderSize.height/4)];
    [subtitle1Text setString:@"FUCK YOU"];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor redColor] CGColor]];
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0,videoComposition.renderSize.width, videoComposition.renderSize.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoComposition.renderSize.width, videoComposition.renderSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoComposition.renderSize.width, videoComposition.renderSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    
    parentLayer.borderWidth = 5;
    parentLayer.borderColor = [UIColor redColor].CGColor;
    
    
    //        CABasicAnimation *animation =
    //        [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //        animation.duration=2.0;
    //        animation.repeatCount=5;
    //        animation.autoreverses=YES;
    //        // rotate from 0 to 360
    //        animation.fromValue=[NSNumber numberWithFloat:0.0];
    //        animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
    //        animation.beginTime = AVCoreAnimationBeginTimeAtZero;
    //        [overlayLayer1 addAnimation:animation forKey:@"rotation"];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration=2.0;
    animation.repeatCount=5;
    animation.autoreverses=YES;
    // rotate from 0 to 360c
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
    [overlayLayer addAnimation:animation forKey:@"rotation"];
    
    
    
    
    CABasicAnimation *sanimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    sanimation.duration=2.0;
    sanimation.repeatCount=5;
    sanimation.autoreverses=YES;
    // animate from half size to full size
    sanimation.fromValue=[NSNumber numberWithFloat:0.15];
    sanimation.toValue=[NSNumber numberWithFloat:1.0];
    sanimation.beginTime = AVCoreAnimationBeginTimeAtZero;
    [overlayLayer addAnimation:sanimation forKey:@"scale"];
    
    
    CABasicAnimation *oanimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [oanimation setDuration:2]; //duration
    [oanimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [oanimation setToValue:[NSNumber numberWithFloat:0.0]];
    [oanimation setBeginTime:5 + AVCoreAnimationBeginTimeAtZero]; // time to show text
    [oanimation setRemovedOnCompletion:NO];
    [oanimation setFillMode:kCAFillModeForwards];
    [overlayLayer addAnimation:oanimation forKey:@"animateOpacity"];
    
    
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

- (IBAction)thumbnailAction:(id)sender {
    [self playVideo:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"s12" ofType: @"mp4"]]];
    [self extractThumbnalisWithCompletionHandler];
}

//获取缩略图
- (void)extractThumbnalisWithCompletionHandler
{

    gen_asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"s12" ofType: @"mp4"]] options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)}];
    
    [gen_asset loadValuesAsynchronouslyForKeys:@[@"tracks",@"duration"] completionHandler:^{
        ///
                NSMutableArray *times = [NSMutableArray array];
                int count = CMTimeGetSeconds(gen_asset.duration)/2;
                if(count <= 0)
                {
                    return;
                }
        
                CMTimeValue tValue = gen_asset.duration.value/count;
                CMTime intervalTime = CMTimeMake(tValue, gen_asset.duration.timescale);
        
                CMTime startTime = kCMTimeZero;
                for(int ii = 0; ii < count; ii++)
                {
                    [times addObject: [NSValue valueWithCMTime:startTime]];
                    startTime = CMTimeAdd(startTime, intervalTime);
                }
        
                NSValue *lastValue = times.lastObject;
                thumbnailCache = [NSMutableArray array];
                imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:gen_asset];
                [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
                    if(result == AVAssetImageGeneratorSucceeded)
                    {
                        [thumbnailCache addObject:[UIImage imageWithCGImage:image]];
                    }
                    else
                    {
                        //加上默认图
                        //TODO
                    }
                    
                    if(CMTimeCompare(requestedTime,lastValue.CMTimeValue) == 0)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //显示
                            
                            
//                            .width/gen_asset.tracks[0].naturalSize.height;
                            CGFloat Height = [gen_asset tracksWithMediaType:AVMediaTypeVideo][0].naturalSize.height;
                            CGFloat Width = [gen_asset tracksWithMediaType:AVMediaTypeVideo][0].naturalSize.width;
                            CGFloat scale = Width/Height;
                            self.thumbScroll.contentSize = CGSizeMake(thumbnailCache.count * (self.thumbScroll.frame.size.height *scale ) + self.thumbScroll.frame.size.width, self.thumbScroll.frame.size.height);
                            self.thumbScroll.layer.borderColor = [UIColor redColor].CGColor;
                            CGFloat x_offset = 0;
                            for(int ii =0; ii < thumbnailCache.count; ii ++)
                            {
                                UIImageView *imageV = [[UIImageView alloc] initWithImage:thumbnailCache[ii]];
                                imageV.frame = CGRectMake(x_offset, 0,self.thumbScroll.frame.size.height *scale ,  self.thumbScroll.frame.size.height);

                                [self.thumbScroll addSubview:imageV];
                                
                                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
                                label.text = [NSString stringWithFormat:@"%d",ii];
                                [label setFont:[UIFont systemFontOfSize:15]];
                                [imageV addSubview:label];
                                label.backgroundColor = [UIColor clearColor];
                                
                                x_offset +=  self.thumbScroll.frame.size.height *scale;
                            }
                            
                        });
                    }
                }];
        
        
    }];
}

////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    double time = (scrollView.contentOffset.x/(scrollView.contentSize.width - self.thumbScroll.frame.size.width) ) *  CMTimeGetSeconds( gen_asset.duration);
    
    [playerView seekTo:time completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    double time = (scrollView.contentOffset.x/(scrollView.contentSize.width - self.thumbScroll.frame.size.width) ) *  CMTimeGetSeconds( gen_asset.duration);
    
    [playerView seekTo:time completion:nil];
}




- (IBAction)launchCamera:(id)sender {
    BOSHCamaraViewController * cam = [[BOSHCamaraViewController alloc] init];
    [self presentViewController:cam animated:YES completion:nil];
}


- (void)playVideoCom:(AVAsset *)set videoCom:(AVVideoComposition *)vComp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionMixWithOthers error:nil];
        
        if(playerView == nil)
        {
            playerView = [[BOTHPlayerView alloc] initWithFrame:CGRectMake(150, 200, (self.view.frame.size.width - 150), (self.view.frame.size.width - 150)*9/16)];
            [self.view addSubview:playerView];
        }
        
         AVPlayerItem * playItem = [AVPlayerItem playerItemWithAsset:set];
        playItem.videoComposition = vComp;
        
        //    [playItem setMixVolume:0.3];
        [playerView playWithItem:playItem];
        [playerView play];
        [playerView setVideoGravity:AVLayerVideoGravityResizeAspect];
        //    playerView.player.volume = 0.7;
    });
    
}

- (void)playVideo:(NSURL *)videURL
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionMixWithOthers error:nil];
        
        if(playerView == nil)
        {
            playerView = [[BOTHPlayerView alloc] initWithFrame:CGRectMake(150, 200, (self.view.frame.size.width - 150), (self.view.frame.size.width - 150)*9/16)];
            [self.view addSubview:playerView];
        }
        
        AVPlayerItem * playItem = [AVPlayerItem playerItemWithURL:videURL];
        
        //    [playItem setMixVolume:0.3];
        [playerView playWithItem:playItem];
        [playerView play];
        
        //    playerView.player.volume = 0.7;
    });
    

}

- (IBAction)playAction:(id)sender {
//    MPVolumeView *view = [[MPVolumeView alloc] initWithFrame:CGRectMake(-self.view.frame.size.width, 0, 20,20)];
//    [self.view addSubview:view];
    MPVolumeSettingsAlertShow();
//    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
//    musicPlayer.volume = 1; // max volume
//    musicPlayer.volume = 0; // min volume (mute)
//    musicPlayer.volume = 0.9; // 1 bar on the overlay volume display
    
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    if(playerView == nil)
    {
        playerView = [[BOTHPlayerView alloc] initWithFrame:CGRectMake(200, 90, (self.view.frame.size.width - 200), (self.view.frame.size.width - 200)*9/16)];
        [self.view addSubview:playerView];
    }
    
    AVAsset *com = [AVAsset assetWithURL:[[NSBundle mainBundle] URLForResource:@"112169" withExtension:@"mp4"]];
    
    AVPlayerItem * playItem = [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"112169" withExtension:@"mp4"]];
    playItem = [AVPlayerItem playerItemWithAsset:com];
    [playItem setMixVolume:0.3];
    [playerView playWithItem:playItem];
    [playerView play];
    
    playerView.player.volume = 0.7;
}

- (IBAction)click:(id)sender {
    
    __block CGFloat x_offset = 0;
    ctx  = [BOSHVideoThumbCtx thumbCtxWithVideo:[[NSBundle mainBundle] URLForResource:@"112169" withExtension:@"mp4"]];
    [ctx thumbImagesWithFPS:1 atTime:100 duration:30 completionHandler:^(UIImage *image){
        
        UIImageView *imv = [[UIImageView alloc] initWithImage:image];
        CGFloat w  = 200 * image.size.width/image.size.height;
        imv.frame = CGRectMake(x_offset, 0, w, 200);
        x_offset += w;
//        imv.contentMode =
        [scroll addSubview:imv];
    }];
    
    scroll.contentSize = CGSizeMake(x_offset, 200);
    
    
    
    [[BOSHGIFContext currentContext] makeVideo:[[NSBundle mainBundle] URLForResource:@"112169" withExtension:@"mp4"] toGif:[libraryPath() stringByAppendingPathComponent:@"k.gif"] inQueue:nil completion:^(NSError *erro, NSData *gif) {
        imageView.image = [UIImage sd_animatedGIFWithData:gif];
    }];
    
    
    BOTHMineViewController * leftDrawer = [[BOTHMineViewController alloc] init];
    UIViewController * center = [[UIViewController alloc] init];
//    leftDrawer.view.backgroundColor = [UIColor redColor];
     BOSHHomeViewController *vc  = BOSHHomeViewController.new;
    
    drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:vc
                                             leftDrawerViewController:leftDrawer
                                             rightDrawerViewController:nil];
    
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //5、设置左右两边抽屉显示的多少
    drawerController.maximumLeftDrawerWidth = 200.0;
    drawerController.maximumRightDrawerWidth = 200.0;
    
    [self addChildViewController:drawerController];
    [self.view addSubview:drawerController.view];
//    [self presentViewController:drawerController animated:YES completion:nil];
//    BOSHHomeViewController *vc  = BOSHHomeViewController.new;
//    [self presentViewController:vc animated:YES
//                     completion:nil];
    
    
   [drawerController openDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
}

- (IBAction)click2:(id)sender {
    
    NSArray* imageArray = @[[UIImage imageNamed:@"bgStory"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
