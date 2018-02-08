//
//  BOTHSegmentEditorViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/10/31.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHSegmentEditorViewController.h"
#import "BOSHVideoItem.h"
#import "BOTHMacro.h"
#import "BOTHPlayerView.h"
#import "BOTHSingleEditorLayout.h"
#import "BOTHEditorRulerView.h"
#import <GPUImage/GPUImage.h>
#import "BOTHButton.h"
#import "PHAsset+BOTH.h"
#import "BOSHUtils.h"
#import "BOSHFile.h"

@interface BOTHSegmentEditorViewController ()
{
    GPUImageMovie *movie;
    GPUImageView * filterView;
    GPUImageGaussianBlurFilter *_curFilter;
}

@property (nonatomic, strong) BOSHVideoItem *videoItem;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton*backButton;
@property (nonatomic, weak) UIButton*rotateButton;
@property (nonatomic, weak) UIButton*cropButton;
@property (nonatomic, weak) UIButton*clipButton;
@property (nonatomic, weak) BOTHButton*addButton;
@property (nonatomic, weak) BOTHPlayerView *playerView;
@property (nonatomic, weak) BOTHEditorRulerView *rulerView;

@property (nonatomic, strong) BOTHSingleEditorLayout *layout;
@property (nonatomic, strong) NSMutableArray *clips;

@property (nonatomic, strong) UIImageView *animationView;

@end

@implementation BOTHSegmentEditorViewController

- (void)dealloc
{
    self.navigationController.navigationBarHidden = NO;
    [self removeApplicationObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0x101010);
    self.layout = [[BOTHSingleEditorLayout alloc] initWithContentVC:self];
    self.backButton = self.layout.backButton;
    [self.backButton  addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.

    if(self.assetModel)
    {
        [self loadDataWithModel:self.assetModel];
    }
    else if(self.videoURL)
    {
        [self loadDataWithURL:self.videoURL];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.navigationController)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.navigationController)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)loadDataWithModel:(TZAssetModel *)assetModel
{
    //
    PHAsset *phasset = (PHAsset *)assetModel.asset;
    if(phasset)
    {
        [PHAsset copyVideoFromPHAsset:phasset withQuality:PHVideoRequestOptionsDeliveryModeHighQualityFormat toPath:videoCachePath() Complete:^(NSString *filePath, NSString *fileName) {
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            [self loadDataWithURL:fileURL];
        }];
    }
}

- (void)loadDataWithURL:(NSURL *)url
{
    _videoItem = [[BOSHVideoItem alloc] initWithURL:url];
    if(_videoItem)
    {
        [_videoItem prepareMediaAsynchronouslyForKeys:@[BOTHAVAssetTracksKey,BOTHAVAssetDurationKey] completionHandler:^(BOOL isYES) {
            if(isYES)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self loadViewsWithItem:_videoItem];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
        }];
        
        [self addApplicationObserver];
    }
    else
    {
        
    }
}

- (void)loadSubViews
{
    self.titleLabel = self.layout.titleLabel;
    self.rotateButton = self.layout.rotateButton;
//    self.reverseButton = self.layout.reverseButton;
    self.cropButton = self.layout.cropButton;
    self.clipButton  = self.layout.clipButton;
    self.addButton = self.layout.addButton;
    self.playerView = self.layout.playerView;
    self.rulerView = self.layout.rulerView;
    [self processActions];
}

#pragma mark -application notice
- (void)applicationDidBecomeActive:(NSNotification *)notice
{
    
}

- (void)applicationWillResignActive:(NSNotification *)notice
{
    [self.playerView pause];
}



- (void)processActions
{
    [self.addButton  addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rotateButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.reverseButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.clipButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cropButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self);
    [self.playerView setPlayerStateHandler:^(BOTHPlayerState state) {
        if(state == BOTHPlayerStateOnFinished)
        {
            [weakself.playerView seekTo:0 completion:nil];
            [weakself.playerView play];
        }
        else if(state == BOTHPlayerStateOnStart)
        {
             [weakself.playerView pause];
        }
    }];

    [self.playerView setProgressHandler:^{
//        [weakself.timeLabel setCurTime:weakself.playerView.currentTime andDuration:weakself.playerView.duration];
        [weakself.rulerView setSingleProgress:weakself.playerView.currentTime];
        if(weakself.playerView.currentTime >= weakself.rulerView.rightProgress)
        {
            [weakself.playerView seekTo:weakself.rulerView.leftProgress completion:^(BOOL finished) {
            }];
             [weakself.playerView play];
        }
    }];
    
    
    [self.rulerView setCursorActionHandler:^(int state, double progress) {
        [weakself.playerView seekTo:progress completion:^(BOOL finished) {
            
        }];
    }];
    
    [self.rulerView setSideSliderHandler:^(BOTHEditorRulerSlideState state, float progress){
         [weakself.playerView seekTo:progress completion:nil];
        if(state == BOTHEditorRulerSlideEnd)
        {
            [weakself.playerView seekTo:weakself.rulerView.leftProgress completion:^(BOOL finished) {
               
            }];
             [weakself.playerView play];
        }
    }];
    
    [self.rulerView setMiddleSliderHandler:^(BOTHEditorRulerSlideState state, float progress) {
         [weakself.playerView seekTo:progress completion:nil];
    }];
}

- (void)loadViewsWithItem:(BOSHVideoItem *)videoItem
{
    self.clips = [NSMutableArray array];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self loadSubViews];
    ///
    [self.layout setVideoRatio: (videoItem.videoSize.width/videoItem.videoSize.height)];
    [self.playerView setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.playerView playWithItem:videoItem.playItem];
//     [self.timeLabel setCurTime:self.playerView.currentTime andDuration:self.playerView.duration];
    [self.rulerView setImages:videoItem.thumbnail];
    self.rulerView.min = 0;
    self.rulerView.max = CMTimeGetSeconds(videoItem.asset.duration)* 1000;
    
    
    
//    _curFilter = [[GPUImageOverlayBlendFilter alloc] init];
    
//    _curFilter = [[GPUImageTransformFilter alloc] init];
//    [((GPUImageTransformFilter *)_curFilter) setAffineTransform:CGAffineTransformMakeRotation(M_PI_2)];
////    [videoCamera addTarget:rotationFilter];
//    [_curFilter addTarget:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               self.playerView];
    
    
//    filterView = [[GPUImageView alloc] initWithFrame:self.playerView.bounds];
//    [self.playerView addSubview:filterView];
    
//    _curFilter = [[GPUImageGlassSphereFilter alloc] init];
////    ((GPUImageGlassSphereFilter *)_curFilter).blurRadiusInPixels = 10.0;
//    [_curFilter addTarget:self.playerView];
    
//    movie = [[GPUImageMovie alloc] initWithPlayerItem:self.playerView.player.currentItem];
//    [movie addTarget:self.playerView];
//    [movie  startProcessing];
//    self.playerView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.playerView play];
}


- (BOTHClipCommand *)getClipCommand
{
    BOTHClipCommand *cmd = BOTHClipCommand.new;
    
    CMTimeValue value = self.videoItem.timeRange.duration.value;
    CMTime start = CMTimeMake( (self.rulerView.leftProgress/CMTimeGetSeconds(self.videoItem.timeRange.duration))*value, self.videoItem.timeRange.duration.timescale);
    CMTime end = CMTimeMake( (self.rulerView.rightProgress/CMTimeGetSeconds(self.videoItem.timeRange.duration))*value, self.videoItem.timeRange.duration.timescale);
    CMTime duration = CMTimeSubtract(end, start);
    
    cmd.clipRange = CMTimeRangeMake(start, duration);
    
    return cmd;
}


- (void)close
{
    [self.playerView pause];
    [movie cancelProcessing];
    [movie endProcessing];
    [movie removeTarget:self.playerView];
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if(self.presentationController)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else
    {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}
#pragma mark handleAction
- (void)handleAction:(id)sender
{
    if(sender == self.backButton)
    {
        [self close];

    }
    else if(sender == self.rotateButton)
    {
        self.playerView.layer.transform = CATransform3DConcat(self.playerView.layer.transform,CATransform3DMakeRotation(M_PI_2, 0, 0, 1));
    }
    else if(sender == self.clipButton)
    {
        //

        [self.clips addObject:[self getClipCommand]];
        UIImageView *imageV = [self.rulerView snapShot];
        
        if(self.animationView)
        {
            [self.animationView.layer removeAllAnimations];
            [self.animationView removeFromSuperview];
            self.animationView = nil;
        }
        
        if(imageV)
        {
            self.animationView = imageV;
            self.animationView.frame = [self.rulerView convertRect:imageV.frame toView:self.view];
            [self.view addSubview:self.animationView];

            [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.animationView.frame = self.addButton.frame;
               self.animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                [self.addButton setNumber:(int)self.clips.count];
            } completion:^(BOOL finished) {
                [self.animationView.layer removeAllAnimations];
                [self.animationView removeFromSuperview];
                self.animationView = nil;
            }];
            
        }
    }
    else if(sender == self.cropButton)
    {
        ///设置的分辨率
//        if(self.playerView.fillMode ==  kGPUImageFillModePreserveAspectRatio)
//        {
//            [self.cropButton setTitle:@"原比例" forState:0];
//            self.playerView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
//        }
//        else
//        {
//            self.playerView.fillMode = kGPUImageFillModePreserveAspectRatio;
//            [self.cropButton setTitle:@"填充" forState:0];
//        }
    }
    else if(sender == self.addButton)
    {
        //关闭 + 回调
        if(self.addActionHandler)
        {
            if(self.clips.count <= 0)
            {
                [self.clips addObject:[self getClipCommand]];
            }
            self.addActionHandler(self.videoItem);
        }
//        [self close];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
