//
//  BOTHEditorViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/10/18.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHEditorViewController.h"
#import "BOSHVideoItem.h"
#import "BOTHButton.h"
#import "BOSHEditorLayout.h"
#import "BOSHAVEditor.h"
#import "BOSHEditorView.h"
#import "BOSHAudioView.h"
#import "BOSHFilterView.h"
#import "GPUImageMovie.h"
#import "BOSHUtils.h"
#import "BOSHAudioRecorder.h"
#import "BOSHVoiceItem.h"
#import "BOSHVideoTrack.h"
#import "BOSHAudioTrack.h"
#import "BOSHAudioItem.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "BOSHTimelineHelper.h"
#import "BOSHFile.h"
#import "BOSHGifViewController.h"
#import "BOSHEditorCache.h"
#import "BOSHTextInputViewController.h"
#import "OverlayContainer.h"
#import "BOSHTextOverlayContainer.h"
#import "BOSHMenuViewController.h"
#import <GPUImage.h>
#import "BOSHEditorItemsView.h"
#import "BOTHMacro.h"
#import "BOSHEditorItemsView.h"
#import "BOSHGifViewController.h"
#import "OverlayContainer.h"

@interface BOTHEditorViewController ()
{
    GPUImageMovie *movie;
    AVAudioRecorder *_recoder;
    AVAudioPlayer *player;
    
    
    GPUImageView *playView;
    GPUImageUIElement *elementView;
    GPUImageDissolveBlendFilter *filter;
    GPUImageMovie *imovie;
    UIImageView *imv;
    AVPlayerItem *pItem;
    AVPlayer *plyaer;
    GPUImageFilter *videoFilter;
    
    GPUImageBrightnessFilter *briFilter;
    
}
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) BOTHButton*addButton;
@property (nonatomic, strong) BOTHPlayerView *playerView;
@property (nonatomic, strong) BOSHEditorLayout *layout;
@property (nonatomic, strong) BOSHProgressView *progressView;
@property (nonatomic, strong) BOSHTimelineViewController *timelineVC;
@property (nonatomic, strong) BOSHAVEditor *editor;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIScrollView *playerContentView;

@property (nonatomic, strong) UIView *overlayView;

@property (nonatomic, strong) BOSHVoiceItem *currentVoice;

@property (nonatomic, strong) BOSHEditorCache *cache;


//@property (nonatomic, strong) BOSHTextOverlayContainer *overlayContainer;
@property (nonatomic, strong) OverlayContainer *overlayContainer;

@property (nonatomic, strong)  BOSHGifViewController *gifView;
@property (nonatomic, strong)   BOSHEditorItemsView  *editorItemView;
//记录一下初始化的player 的
@property (nonatomic) CGRect playerRect;
@end

@implementation BOTHEditorViewController


- (void)changePosition:(UIPanGestureRecognizer *)gs
{
    gs.view.centerX = [gs locationInView:gs.view.superview].x;
    [elementView update];
}

- (void)test
{
            static int o = 0;
    o =0;
    UIImage *image = [UIImage imageNamed:@"mvhuabian.png"];
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imv setImage:image];
    
   
    [imv addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePosition:)]];
    imv.userInteractionEnabled = YES;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lab.font = [UIFont systemFontOfSize:32];
    lab.text = @"操";
    lab.textColor = [UIColor redColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    [contentView addSubview:lab];
    
    elementView = [[GPUImageUIElement alloc] initWithView:contentView];

    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    
    playView = [[GPUImageView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    playView.layer.borderWidth = 3;
    playView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:playView];
    
//    [playView addSubview:contentView];
   
    pItem = [[AVPlayerItem alloc]initWithURL: self.videoItem.url];  //[[NSBundle mainBundle] URLForResource:@"110126.mp4" withExtension:nil]];
    plyaer = [AVPlayer playerWithPlayerItem:pItem];
    imovie = [[GPUImageMovie alloc] initWithPlayerItem:pItem];
//    imovie.runBenchmark = NO;
    imovie.playAtActualSpeed = YES;
   
    
    
    GPUImageAlphaBlendFilter *filter = [[GPUImageAlphaBlendFilter alloc] init];
    filter.mix = 1.0;
//    filter = [[GPUImageDissolveBlendFilter alloc] init];
    
    //mix即为叠加后的透明度,这里就直接写1.0了
//    filter.mix = 0.5f;

    
    videoFilter = [[GPUImageFilter alloc] init];
//    [videoFilter setupFilterForSize:CGSizeMake(200, 200)];

    GPUImageThreeInputFilter *tt = [[GPUImageThreeInputFilter alloc] init];

   [imovie addTarget:videoFilter];
   [videoFilter addTarget:filter];
    [videoFilter addTarget:tt];
   [elementView addTarget:filter];
    
//    [videoFilter addTarget:playView];
//    imovie.audioEncodingTarget = nil;
    [videoFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime currentTime) {
        
        //在这里改变水印的位置、大小等属性；
        //直接改imageView的frame就好,修改了记得要update就好
//        CGFloat scale = (CMTimeGetSeconds(currentTime)/12.0);
//        imv.frame = CGRectMake(0, 0, (1- scale)*100, (1- scale)*100);
        [elementView update];
        if(CMTimeGetSeconds(currentTime) >= 3 && o == 0)
        {
            GPUImageGaussianBlurFilter *curFilter = [[GPUImageGaussianBlurFilter alloc] init];
            curFilter.blurRadiusInPixels = 30.0;
            
//             curFilter = [[GPUImageHighPassFilter alloc] init];
            
//            [filter removeTarget:playView];
//            [filter addTarget:curFilter];
//            [curFilter addTarget:playView];
            o = 1;
        }
    }];
    GPUImageSoftEleganceFilter *hhhfilter = [[GPUImageSoftEleganceFilter alloc] init];
    [filter addTarget:hhhfilter];
    [hhhfilter addTarget:playView];
    playView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
//    [pic processImage];
    [imovie startProcessing];
    [plyaer play];
}

- (void)dealloc
{
    [self.playerView pause];
//    [self.playerView removeObserver:self forKeyPath:@"progress"];
//    [movie cancelProcessing];
//    [movie endProcessing];
//    [movie removeTarget:self.playerView];
    self.navigationController.navigationBarHidden = NO;
}

- (UIView *)maskView
{
    if(!_maskView)
    {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
//        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        [self.view addSubview:_maskView];
    }
    return _maskView;
}

- (void)prepare
{
    self.cache = [BOSHEditorCache defaultCache];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
     self.view.backgroundColor = UIColorFromRGB(0x101010);
    self.headerBar.leftItemHidden = NO;
    self.headerBar.backgroundColor = UIColorFromRGB(0x101010);
    @weakify(self);
    [self.headerBar setLeftActionHandler:^{
        [weakself close];
    }];
    
    [self prepare];
    [self setUpUIElements];
    // Do any additional setup after loading the view.
//    self.layout = [[BOSHEditorLayout alloc] initWithContentVC:self];
//    self.playerView = self.layout.playerView;
//    [self processActions];
    [self loadViewsWithItem:self.videoItem];
    
    UIButton *exportBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 90 -10, 20, 100, 44)];
    [exportBtn setTitle:@"导出" forState:0];
    [self.view addSubview:exportBtn];
    [exportBtn addTarget:self action:@selector(exportAction) forControlEvents:UIControlEventTouchUpInside];

}


- (void)setUpUIElements
{
    //进度条
    BOSHProgressView *progressView = [[BOSHProgressView alloc] initWithFrame:CGRectMake(0, kNAVIGATIONH, self.view.width , [BOSHProgressView preferHeight])];
    [self.view addSubview:progressView];
    _progressView = progressView;
    progressView.backgroundColor = UIColorFromRGB(0x101010);
    
    //目前为了快速出第一版本支持方的视频 如苹果clips
    CGFloat maxPlayH = self.view.height - progressView.bottom - 64;
    self.playerRect = CGRectMake(0, progressView.bottom + (maxPlayH - self.view.width)/2, self.view.width, self.view.width);
    BOTHPlayerView *playerView = [[BOTHPlayerView alloc] initWithFrame:self.playerRect];
    playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:playerView];
    [self.view  sendSubviewToBack:playerView];
    _playerView = playerView;
    [playerView setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    //overlay container
    self.overlayContainer = [[OverlayContainer alloc] init];
    [self.playerView addSubview:self.overlayContainer];
    
    
    _timelineVC = [[BOSHTimelineViewController alloc] initWithFrame:CGRectMake(0, self.view.height -  64, self.view.width, 64)];
    [self addBOSHChildViewController:_timelineVC];
    @weakify(self);
    [_timelineVC setSegmentActionHandler:^(BOSHTimelineAction actionType) {
        [weakself showEditorItemView];
    }];
    [self processActions];
    [self test];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//添加贴图
- (void)addGifOverlay
{
    self.gifView  = [[BOSHGifViewController alloc] init];
    [self presentViewController:self.gifView animated:YES completion:^{
        
    }];
//    [self addBOSHChildViewController:self.gifView];
//    self.gifView.view.backgroundColor = [UIColor clearColor];
    @weakify(self);
    [self.gifView setSelectedHandler:^(BOSHGIFModel *model) {
        //
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.overlayContainer.playerItem = self.playerView.player.currentItem;
            BOSHGifOverlay *gifOverlay =  [BOSHGifOverlay overlay];
            CGSize size = CGSizeMake(100, 100 );
            gifOverlay.frame = CGRectMake(0,0, size.width, size.height);
            gifOverlay.gifURL = [NSURL URLWithString:model.url];
            BOSHOverlayTrack *track = [BOSHOverlayTrack itemWithOverlay:gifOverlay];
            
            [self.overlayContainer addOverlayTrack:track];
        });

    }];
}

//添加文本
- (void)addSubtitles
{
    BOSHTextInputViewController *textInputVC = BOSHTextInputViewController.new;
    [self presentViewController:textInputVC animated:YES completion:^{
        
    }];
    @weakify(self);
    [textInputVC setInputTextHandler:^(BOSHTextOverlay *textOverlay) {
        CGSize size = [textOverlay sizeToFitWidth:weakself.playerView.width];
        textOverlay.frame = CGRectMake((weakself.playerView.width - size.width)/2, (weakself.playerView.height - size.height) - 20, size.width, size.height);
        BOSHOverlayTrack *track = [BOSHOverlayTrack itemWithOverlay:textOverlay];
        [weakself.playerView.getAVSyncLayer addSublayer:track.overlayer];
    }];
}

//分段编辑菜单
- (void)showEditorItemView
{
    @weakify(self);
    if(self.editorItemView == nil)
    {
        
        self.editorItemView = [[BOSHEditorItemsView alloc] initWithFrame:CGRectMake(0,self.timelineVC.view.top, self.view.width, 0)];
        [self.view insertSubview:self.editorItemView belowSubview:self.timelineVC.view];
        self.editorItemView.backgroundColor = UIColorFromRGB(0x101010);
        
        [self.editorItemView setFoldHandler:^{
            [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                weakself.editorItemView.frame = CGRectMake(0,  weakself.timelineVC.view.top, weakself.view.width, 0);
            } completion:^(BOOL finished) {
            }];
        }];
        
        [self.editorItemView setSegmentActionHandler:^(BOSHTimelineAction actionType) {
            if(actionType == BOSHTimelineActionAddGIF)
            {
                [weakself addGifOverlay];
            }
            else if(actionType == BOSHTimelineActionAddSubtiles)
            {
                //文本输入
                [weakself addSubtitles];
            }
        }];
    }
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakself.editorItemView.frame = CGRectMake(0,  weakself.timelineVC.view.top - BOSHEditorItemsView.height, weakself.view.width, BOSHEditorItemsView.height);
    } completion:^(BOOL finished) {
    }];
    
}

- (void)reloadata
{
//    self.layout.timelineVC 
}

- (void)processActions
{
//    [self.layout.backButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.addButton  addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.layout.filterButton  addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.layout.editButton  addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.layout.audioButton  addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
//
//
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
//
    [self.playerView setProgressHandler:^{
        [weakself.progressView setCurTime:weakself.playerView.currentTime];
    }];
//
    [self.progressView setSeekHandler:^(double time, int state) {
        if(state == 0)
        {
            [weakself.playerView pause];
        }
        else if(state == 1)
        {
            [weakself.playerView seekTo:time completion:nil];
        }
        else if(state == 2)
        {
             [weakself.playerView seekTo:time completion:nil];
        }
    }];
}

- (void)loadViewsWithItem:(BOSHVideoItem *)videoItem
{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.playerView playWithItem:videoItem.playItem];
    
    [self.progressView setImages:videoItem.thumbnail];
    self.progressView.duration = CMTimeGetSeconds(videoItem.asset.duration)* 1000;
    
    //    movie = [[GPUImageMovie alloc] initWithPlayerItem:self.playerView.player.currentItem];
    //    [movie addTarget:self.playerView];
    //    [movie  startProcessing];
    //    self.playerView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.playerView play];
    [self.cache.videoSegments addObject:videoItem];
    [_timelineVC addVideo:self.videoItem];
    
    
//    BOSHGifOverlay *gifOverlay =  [BOSHGifOverlay overlay];
//    CGSize size = CGSizeMake(200, 200 );
//    gifOverlay.frame = CGRectMake(0, 0, size.width, size.height);
//    gifOverlay.gifURL = [NSURL URLWithString:@""];
//    BOSHOverlayTrack *track = [BOSHOverlayTrack itemWithOverlay:gifOverlay];
//
//    [_playerView.getAVSyncLayer addSublayer:track.overlayer];
}

- (void)close
{
    [self.playerView pause];
//    [movie cancelProcessing];
//    [movie endProcessing];
//    [movie removeTarget:self.playerView];
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
     [self.view bringSubviewToFront :self.maskView];
    @weakify(self);
    if(sender == self.layout.backButton)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(sender == self.layout.filterButton)
    {
        
        [self test]; return;
        CGFloat height = MIN( ((((self.view.width - 3*15)/2)*9.0/16)*2 + 3*15), self.view.height - (self.playerView.bottom + 10));
        CGRect rect = CGRectMake(0, self.view.height - height, self.view.width, height);
        
        BOSHFilterView *filterView = [[BOSHFilterView alloc] initWithFrame:CGRectMake(0, self.view.height + 10,  self.view.width, height)];
        filterView.backgroundColor = UIColorFromRGB(0x101010);
        [self.maskView addSubview:filterView];
        self.overlayView = filterView;
        [UIView animateWithDuration:.35 animations:^{
            filterView.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    else if(sender == self.layout.editButton)
    {
        
        CGFloat height = MIN( ((((self.view.width - 3*15)/2)*9.0/16)*2 + 3*15), self.view.height - (self.playerView.bottom + 10));
        CGRect rect = CGRectMake(0, self.view.height - height, self.view.width, height);
        
//       BOSHEditorView  *editorView = [[BOSHEditorView alloc] initWithFrame:CGRectMake(0, self.view.height + 10,  self.view.width, height)];
//        editorView.backgroundColor = UIColorFromRGB(0x101010);
//        [editorView setActionHandler:^(BOSHEditorViewAction actionType) {
//            [weakself dispatchAction:actionType];
//        }];
//        [self.maskView addSubview:editorView];
//        self.overlayView = editorView;
//        [UIView animateWithDuration:.35 animations:^{
//            editorView.frame = rect;
//        } completion:^(BOOL finished) {
//
//        }];
        
        BOSHTimelineAsset *asset = [BOSHTimelineAsset defaultTimelineAsset];
        NSMutableArray *videos = [NSMutableArray array];
        NSMutableArray *trans = [NSMutableArray array];
        CMTime xTimeoffset = kCMTimeZero;
        for(int jj =0; jj < self.cache.videoSegments.count; jj++)
        {
            BOSHVideoTrack *video = [BOSHVideoTrack modelWithMediaItem:self.cache.videoSegments[jj]];
            video.timeRange = video.media.timeRange;
            video.startTime = xTimeoffset;
            xTimeoffset = CMTimeAdd(xTimeoffset, video.media.timeRange.duration);
            [videos addObject:video];
            
            if((jj+1)<= self.cache.videoSegments.count - 1)
            {
                BOSHTransitonInstruction *tr = [BOSHTransitonInstruction fadeTransitionWithDuration:[BOSHTransitonInstruction defaultInterval]];
                [trans addObject:tr];
            }
            
        }
        asset.videos = videos;
        asset.transations =  trans;
        
        
        BOSHMenuViewController *menu1 = [[BOSHMenuViewController alloc] initWithFrame:CGRectMake(0, 0,  self.view.width, height)];
        menu1.delegate = (id<BOSHMenuViewControllerProtocol>)self;
        menu1.timelineAsset = asset;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu1];
        nav.view.frame = CGRectMake(0, self.view.height + 10,  self.view.width, height);
        [self addBOSHChildViewController:nav];
//
        [UIView animateWithDuration:.35 animations:^{
            nav.view.frame = rect;
        } completion:^(BOOL finished) {

        }];
        
        
        
        
        
        
        
    }
    else if(sender == self.layout.audioButton)
    {
        CGFloat height = MIN( ((((self.view.width - 3*15)/2)*9.0/16)*2 + 3*15), self.view.height - (self.playerView.bottom + 10));
        CGRect rect = CGRectMake(0, self.view.height - height, self.view.width, height);
        
//        BOTHRange *range1 = [BOTHRange rangeWithStart:self.playerView.currentTime duration:self.playerView.duration/4];
//        BOTHRange *range2 = [BOTHRange rangeWithStart:self.playerView.duration/3 duration:self.playerView.duration/4];
//        BOTHRange *range3 = [BOTHRange rangeWithStart:self.playerView.duration/2 duration:self.playerView.duration/4];
        
        NSMutableArray *arr = [NSMutableArray array];
        for(BOSHVoiceItem *vItem in  self.cache.voiceSegments)
        {
            [arr addObject:vItem.timeRangeused];
        }
    
        BOSHAudioView *audioView = [[BOSHAudioView alloc] initWithFrame:CGRectMake(0, self.view.height + 10,  self.view.width, height) duration:self.playerView.duration  andRanges:arr];
        audioView.duration = self.playerView.duration;
        audioView.delegate = self;
       [audioView setCurTime:self.playerView.currentTime];
        audioView.backgroundColor = UIColorFromRGB(0x101010);
//        [self.playerView addObserver:audioView forKeyPath:@"progress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.maskView addSubview:audioView];
        self.overlayView = audioView;
        @weakify(self);
        [audioView.progressView setSeekHandler:^(double time, int state) {
            if(state == 0)
            {
                [weakself.playerView pause];
            }
            else if(state == 1)
            {
                [weakself.playerView seekTo:time completion:nil];
            }
            else if(state == 2)
            {
                [weakself.playerView seekTo:time completion:nil];
            }
        }];
        
        [self.playerView setProgressHandler:^{
            [audioView.progressView setCurTime:self.playerView.currentTime];
        }];
        
        [UIView animateWithDuration:.35 animations:^{
            audioView.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
}


#pragma mark
- (void)menuViewController:(BOSHMenuViewController *)mVC didSelectFontParamters:(id)parameters
{
//            self.overlayContainer = [[BOSHTextOverlayContainer alloc] initWithFrame:CGRectMake(0, 0, 100, 90)];
//            self.overlayContainer.center = CGPointMake(self.playerView.width/2, self.playerView.height/2);
//            self.overlayContainer.backgroundColor = UIColorFromRGBA(0xffffff, .3);
//            [self.playerView addSubview:self.overlayContainer];
//            [self.overlayContainer showKeyborad];
}


- (void)mergeVoiceRange
{
    if(self.currentVoice == nil) return;
    int flag = 0;
    for(int ii = 0; ii < self.cache.voiceSegments.count; ii++)
    {
        BOSHVoiceItem *vItem = self.cache.voiceSegments[ii];
        if([vItem.timeRangeused intersectionWithRange:self.currentVoice.timeRangeused])
        {
            [self.cache.voiceSegments replaceObjectAtIndex:ii withObject:self.currentVoice];
            flag = 1;
        }
    }
    if(!flag)
    {
        [self.cache.voiceSegments addObject:self.currentVoice];
    }
    
    self.currentVoice = nil;
}

#pragma mark BOSHAudioView delegate
- (void)audioViewDidFinishRecord:(BOSHAudioView *)audioView
{
    audioView.progressView.isRecording = NO;
    if(_recoder)
    {
        [_recoder stop];
        _recoder = nil;
    }
    self.currentVoice.timeRangeused.duration = self.playerView.currentTime - self.currentVoice.timeRangeused.start;
    //合并一下
    [self mergeVoiceRange];
    
    
     [self reloadPlayer];
}

- (void)audioViewWillStartRecord:(BOSHAudioView *)audioView
{
    audioView.progressView.isRecording = YES;
    NSString *m4aCachePath = [videoCachePath() stringByAppendingPathComponent:m4aFileNameForRecord()];
    _recoder  = [[BOSHAudioRecorder alloc] initWithURL: [NSURL fileURLWithPath:m4aCachePath] settings:[BOSHAudioRecorder defaultSettings] error:nil];
    [_recoder prepareToRecord];
    [_recoder record];
    @weakify(self);
    [self.playerView setProgressHandler:^{
        [audioView setCurTime:weakself.playerView.currentTime];
    }];
    self.currentVoice  = [BOSHVoiceItem new];
    self.currentVoice.filePath = m4aCachePath;
    self.currentVoice.timeRangeused = [BOTHRange new];
    self.currentVoice.timeRangeused.start = self.playerView.currentTime;
    [self.playerView play];
}

#pragma mark handle tap
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if(CGRectContainsPoint(self.playerView.frame,  [tap locationInView:self.view]))
    {
        CGRect frame = self.overlayView.frame;
        frame.origin.y += frame.size.height;
        [UIView animateWithDuration:.25 animations:^{
            self.overlayView.frame = frame;
        } completion:^(BOOL finished) {
            [self.overlayView removeFromSuperview];
            self.overlayView = nil;
            [self.view sendSubviewToBack:self.maskView];
        }];
        
        [self.playerView setProgressHandler:^{
            [self.layout.progressView setCurTime:self.playerView.currentTime];
        }];
        
        if([self.overlayView isKindOfClass:BOSHAudioView.class])
        {
            //
//            AVAudioMix *mix = [AVAudioMix audioMix];
//            AVMutableComposition *comp = [AVMutableComposition composition];
           
        }
    }
    
}


- (void)loadVideos
{
    BOSHTimelineAsset *asset = [BOSHTimelineAsset defaultTimelineAsset];
    NSMutableArray *videos = [NSMutableArray array];
    NSMutableArray *trans = [NSMutableArray array];
    CMTime xTimeoffset = kCMTimeZero;
    for(int jj =0; jj < self.cache.videoSegments.count; jj++)
    {
        BOSHVideoTrack *video = [BOSHVideoTrack modelWithMediaItem:self.cache.videoSegments[jj]];
        video.timeRange = video.media.timeRange;
        video.startTime = xTimeoffset;
        xTimeoffset = CMTimeAdd(xTimeoffset, video.media.timeRange.duration);
        [videos addObject:video];
        
//        if((jj+1)<= self.segments.count - 1)
//        {
//            BOSHTransitonInstruction *tr = [BOSHTransitonInstruction pushTransitonWithDuration:[BOSHTransitonInstruction defaultInterval]];
//            [trans addObject:tr];
//        }
        
    }
    asset.videos = videos;
    asset.transations =  trans;
   self.editor = [BOSHAVEditor  editorWithTimelineAsset:asset];
    [self.editor buildComposition];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self playWithPlayerItem:self.editor.playItem];
}

- (void)reloadPlayer
{
    
//BOSHVideoTrack
//BOSHAudioTrack
    BOSHTimelineAsset *asset = [BOSHTimelineAsset defaultTimelineAsset];

    NSMutableArray *videos = [NSMutableArray array];
    NSMutableArray *trans = [NSMutableArray array];
    CMTime xTimeoffset = kCMTimeZero;
    for(int jj =0; jj < self.cache.videoSegments.count; jj++)
    {
        BOSHVideoTrack *video = [BOSHVideoTrack modelWithMediaItem:self.cache.videoSegments[jj]];
        video.timeRange = video.media.timeRange;
        video.startTime = xTimeoffset;
        xTimeoffset = CMTimeAdd(xTimeoffset, video.media.timeRange.duration);
        [videos addObject:video];
        
//        if((jj+1)<= self.segments.count - 1)
//        {
//            BOSHTransitonInstruction *tr = [BOSHTransitonInstruction pushTransitonWithDuration:[BOSHTransitonInstruction defaultInterval]];
//            [trans addObject:tr];
//        }
    }
    asset.videos = videos;
    asset.transations =  trans;
    
    
    BOSHTextOverlay *overlay = [BOSHTextOverlay overlay];
    overlay.text = @"@yang出品";
    overlay.font = [UIFont boldSystemFontOfSize:32];
    overlay.fontSize = 32;
    overlay.textColor = [UIColor redColor];
    overlay.frame = BOSHConvertRectToDevice(asset.size,CGRectMake(asset.size.width - 200, asset.size.height - 70, 200, 70));
    
    
    BOSHOverlayTrack *overlayTrack = [BOSHOverlayTrack itemWithOverlay:(BOSHOverlay *)overlay];
    overlayTrack.startTime = self.playerView.player.currentItem.currentTime;
//    overlayTrack.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(3, 1));//不设置默认就是持续到视频结尾
    
    BOSHPicOverlay *picOverlay = [BOSHPicOverlay overlay];
    picOverlay.image = [UIImage imageNamed:@"timg.png"];
    picOverlay.frame = CGRectMake(0, 200, 50, 50);
    
    BOSHOverlayTrack *overlayTrack1 = [BOSHOverlayTrack itemWithOverlay:(BOSHOverlay *)picOverlay];
//    overlayTrack1.startTime =
//    self.playerView.player.currentItem.currentTime;
//    overlayTrack1.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(3, 1));
    
    
    BOSHBorderOverlay *borderOverlay = [BOSHBorderOverlay overlay];
    borderOverlay.image = [UIImage imageNamed:@"mvbiankuang2.png"];
    borderOverlay.frame = CGRectMake(0, 0, asset.size.width, asset.size.height);
    borderOverlay.borderMargin = UIEdgeInsetsMake(63, 33, 79, 161);
    BOSHOverlayTrack *overlayTrack2 = [BOSHOverlayTrack itemWithOverlay:(BOSHOverlay *)borderOverlay];
    
    
    
    BOSHGifOverlay *gifOverlay = [BOSHGifOverlay overlay];
    gifOverlay.gifURL = [[NSBundle mainBundle] URLForResource:@"mv" withExtension:@"gif"];
    gifOverlay.frame =  BOSHConvertRectToDevice(asset.size,CGRectMake(120, asset.size.height - 120, 120, 120));
    BOSHOverlayTrack *overlayTrack3 = [BOSHOverlayTrack itemWithOverlay:(BOSHOverlay *)gifOverlay];
    overlayTrack3.startTime = self.playerView.player.currentItem.currentTime;
    
    
    asset.overlays = @[overlayTrack,overlayTrack1,overlayTrack2,overlayTrack3];
    
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.voiceSegment[0].filePath] error:nil];
//    [player prepareToPlay];
//    [player play];
    NSMutableArray *arr = [NSMutableArray array];
    for(int ii = 0; ii < self.cache.voiceSegments.count; ii++)
    {
        BOSHVoiceItem *vItem = self.cache.voiceSegments[0];
        BOSHAudioTrack *audio = [BOSHAudioTrack audioTrackOfURL:[NSURL fileURLWithPath:vItem.filePath] atTime: BOSHCMTimeMake(vItem.timeRangeused.start/1000,self.playerView.player.currentItem.currentTime)];
        [arr addObject:audio];
    }
    asset.audios = arr;
    self.editor = [BOSHAVEditor  editorWithTimelineAsset:asset];
    [self.editor buildComposition];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self playWithPlayerItem:self.editor.playItem];
    
    
    AVSynchronizedLayer *parentLayer = self.playerView.getAVSyncLayer;
    
    parentLayer.frame = CGRectMake(0, 0,self.videoItem.videoSize.width,self.videoItem.videoSize.height);
    parentLayer.borderWidth = 3;
    parentLayer.borderColor = [UIColor redColor].CGColor;
    float scalew = self.playerView.width/self.videoItem.videoSize.width;
    float scaleh =  self.playerView.height/self.videoItem.videoSize.height;
    parentLayer.transform = CATransform3DScale(CATransform3DMakeTranslation(-self.videoItem.videoSize.width *(1- scalew)/2,-self.videoItem.videoSize.height *(1- scaleh)/2,0),scalew,scaleh, 1);//
    for(BOSHOverlayTrack *overlay in asset.overlays)
    {
        CALayer *layer = overlay.overlayer;
        [parentLayer addSublayer:layer];
    }
    
    [self.playerView seekTo:0.0 completion:^(BOOL finished) {
        
    }];

}

- (void)playWithPlayerItem:(AVPlayerItem *)playItem
{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    ///
    [self.layout setVideoRatio:self.videoItem.videoSize.width/self.videoItem.videoSize.height ];
    [self.playerView setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.playerView playWithItem:playItem];

    //     [self.timeLabel setCurTime:self.playerView.currentTime andDuration:self.playerView.duration];
    
//    [self.layout.progressView setImages:self.videoItem.thumbnail];
    self.layout.progressView.duration = CMTimeGetSeconds(self.editor.duration)* 1000;
    
//    movie = [[GPUImageMovie alloc] initWithPlayerItem:self.playerView.player.currentItem];
//    [movie addTarget:self.playerView];
//    [movie  startProcessing];
//    self.playerView.fillMode = kGPUImageFillModePreserveAspectRatio;
     [_playerView setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.playerView play];
    
    [self.playerView setProgressHandler:^{
        [self.layout.progressView setCurTime:self.playerView.currentTime];
    }];
    [self.playerView setPlayerStateHandler:^(BOTHPlayerState state) {
        
    }];
     [self.playerView setPlayActionHandler:^(BOOL paused) {
        
    }];
}

- (void)exportAction
{
   AVAssetExportSession *assetExport =  [self.editor assetExportSession];
    assetExport.outputURL = autoExportPath();
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        NSURL *exportURL = assetExport.outputURL;
        [BOSHUtils writeVideoToPhotosAlbum:exportURL completionHandler:^(NSURL *assetURL, NSError *error){
            if(!error)
            {
               [[[UIAlertView alloc] initWithTitle:@"" message:@"保存成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
            }
        }];
    }];
}

#pragma mark load
- (void)dispatchAction:(BOSHEditorViewAction) actionType
{
    if(actionType == BOSHEditorViewActionPasters)//贴纸
    {
        BOSHGifViewController *gifVC = [BOSHGifViewController new];
        [self presentViewController:gifVC animated:YES completion:nil];
        [gifVC setSelectedHandler:^(BOSHGIFModel *model) {
            
        }];
    }
    else if(actionType == BOSHEditorViewActionSpeed)//删除
    {
    }
    else if(actionType == BOSHEditorViewActionVolume)//静音
    {
    }
    else if(actionType == BOSHEditorViewActionTransition)//转场
    {
    }
    else if(actionType == BOSHEditorViewActionSubtitles)//标题
    {
//        BOSHTextInputViewController *textInputVC = BOSHTextInputViewController.new;
//        [self.navigationController pushViewController:textInputVC animated:YES];
//        self.overlayContainer = [[BOSHTextOverlayContainer alloc] initWithFrame:CGRectMake(0, 0, 100, 90)];
//        self.overlayContainer.center = CGPointMake(self.playerView.width/2, self.playerView.height/2);
//        self.overlayContainer.backgroundColor = UIColorFromRGBA(0xffffff, .3);
//        [self.playerView addSubview:self.overlayContainer];
//        [self.overlayContainer showKeyborad];
    }
    else if(actionType == BOSHEditorViewActionWatermark)//水印
    {
        BOSHTextInputViewController *textInputVC = BOSHTextInputViewController.new;
        [self.navigationController pushViewController:textInputVC animated:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
