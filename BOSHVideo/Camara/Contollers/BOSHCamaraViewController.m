//
//  BOSHCamaraViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/10/17.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHCamaraViewController.h"
#import "GPUImage.h"
#import "UIView+Geometry.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BOSHUtils.h"

@interface BOSHCamaraViewController ()
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    AVCaptureDevicePosition devicePosition;
    
    
    GPUImageView *preView;
    
    
   GPUImageMovieWriter *movieWriter;
    NSURL *movieURL;
}
@end

@implementation BOSHCamaraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    devicePosition = AVCaptureDevicePositionFront;
    // Do any additional setup after loading the view.
    [self initPreview];
    [self initCamara];

    
    [self addBackButton];
    [self addRecordButton];
    
    [videoCamera startCameraCapture];
}

- (void)addBackButton
{
    //返回按钮
    UIButton *back = [[UIButton alloc]  initWithFrame:CGRectMake(10, self.view.height - 120, 100, 100)];
    [back setTitle:@"返回" forState:0];
     [back setTitleColor:[UIColor redColor] forState:0];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addRecordButton
{
    //返回按钮
    UIButton *recordBtn = [[UIButton alloc]  initWithFrame:CGRectMake((self.view.width - 100)/2, self.view.height - 120, 100, 100)];
    [recordBtn setTitle:@"拍摄" forState:0];
    [recordBtn setTitleColor:[UIColor redColor] forState:0];
    [self.view addSubview:recordBtn];
    [recordBtn addTarget:self action:@selector(startCapture) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initCamara
{
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:devicePosition];
//    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
//    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    
    [videoCamera addTarget:preView];
}

- (void)initWritter
{
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",[BOSHUtils currentTimeYMDHMS]]];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    movieURL = [NSURL fileURLWithPath:pathToMovie];
//    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480, 640) fileType:AVFileTypeMPEG4 outputSettings:nil];
//    movieWriter.encodingLiveVideo = YES;
}

- (void)initPreview
{
    preView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.width *4/3)];
//    preView.backgroundColor = [UIColor blackColor];
    preView.layer.borderWidth = 1.5;
    [self.view addSubview:preView];
}

- (void)addFilterView
{
    //加入滤镜
}

- (void)gotoEditPage
{
    //goto 编辑页面
}


- (void)startCapture
{
    double delayToStartRecording = 0.0;
    [self initWritter];//AVWriter 一次拍摄只能是一个实例 (这里需要考察一下 是否为)
    [videoCamera addTarget:movieWriter];
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
    dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Start recording");
        
//        videoCamera.audioEncodingTarget = movieWriter;
        [movieWriter startRecording];
                
        double delayInSeconds = 5.0;
        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            
            [videoCamera removeTarget:movieWriter];
//            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            NSLog(@"Movie completed");
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:movieURL])
            {
                [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if (error) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alert show];
                         } else {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alert show];
                         }
                     });
                 }];
            }
        });
    });
    
}

//turn on or off torch
- (void)turnTorchOnAndOff
{
//    if(videoCamera.inputCamera.isTorchAvailable && devicePosition == AVCaptureDevicePositionBack)
//    {
//        [videoCamera.inputCamera lockForConfiguration:nil];
//        [videoCamera.inputCamera setTorchMode:videoCamera.inputCamera.torchActive ? AVCaptureTorchModeOff : AVCaptureTorchModeOn];
//        [videoCamera.inputCamera unlockForConfiguration];
//    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Map UIDeviceOrientation to UIInterfaceOrientation.
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            orient = UIInterfaceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orient = UIInterfaceOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortrait:
            orient = UIInterfaceOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            orient = UIInterfaceOrientationPortraitUpsideDown;
            break;
            
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            // When in doubt, stay the same.
            orient = fromInterfaceOrientation;
            break;
    }
//    videoCamera.outputImageOrientation = orient;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  action
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
