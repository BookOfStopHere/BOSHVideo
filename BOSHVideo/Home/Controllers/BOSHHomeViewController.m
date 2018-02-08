//
//  BOSHHomeViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/9/27.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHHomeViewController.h"
#import "BOTHBlockView.h"
#import "UIView+Geometry.h"
#import "BOSHDefines.h"
#import "BOSHHomeLayoutManager.h"
#import "MMDrawerController.h"
#import "BOTHMacro.h"
#import "BOTHVideoPickerController.h"
#import "BOTHEditorRulerView.h"
#import "BOTHSegmentEditorViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BOSHOverlay.h"
#import "BOSHProgressView.h"
#import "BOTHEditorViewController.h"
#import "BOSHTimelineViewController.h"
#import "BOSHShareManager.h"
#import "BOSHOutputViewController.h"
#import "BOSHFontAnimationView.h"
#import "BOSHTimelineViewController.h"


@interface BOSHHomeViewController ()
{
    BOSHFontAnimationView *sssv;
}

@property (nonatomic, strong) BOSHHomeLayoutManager *layout;

@end

@implementation BOSHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOTHEditorRulerView *view = [[BOTHEditorRulerView alloc] initWithFrame:CGRectMake(50, 180, self.view.width - 100, [BOTHEditorRulerView preferHeight])];
    UIImage *image = [UIImage imageNamed:@"bgStory"];
    
    [view setImages:@[image,image,image,image,image,image]];
    [self.view addSubview:view];
    
    sssv = [[BOSHFontAnimationView alloc] initWithFrame:CGRectMake(0, 90, self.view.width, 100)];
//    sssv.layer.borderWidth = 3;
    [self.view addSubview:sssv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.layout = [[BOSHHomeLayoutManager alloc] initWithTarget:self.view model:@[]];
    
    @weakify(self);
    self.layout.actionHandler = ^(BOSH_FUNCTION_ACTION type){
        [weakself responseToAction:type];
    };
}

- (void)responseToAction:(BOSH_FUNCTION_ACTION)actionType
{
    if(actionType == -1)//@Just Test
    {
        BOTHSegmentEditorViewController *vc = [[BOTHSegmentEditorViewController alloc] init];
        vc.videoURL =  [[NSBundle mainBundle] URLForResource:@"s12" withExtension:@"mp4"];
        [self presentViewController:vc animated:YES completion:nil];
        [vc setAddActionHandler:^(BOSHVideoItem *item) {
            
        }];
    }
    else if(actionType == BOSH_ACTION_EDIT_VIDEO)
    {
        BOTHVideoPickerController *imagePickerVc = [[BOTHVideoPickerController alloc] initWithMaxImagesCount:9 delegate:self];

        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingMultipleVideo = YES;
        imagePickerVc.allowPickingImage = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowTakePicture = YES;
        imagePickerVc.showSelectBtn = NO;
        imagePickerVc.view.backgroundColor = UIColorFromRGB(0x101010);
        __weak typeof(imagePickerVc) weakimagePickerVc = imagePickerVc;
        [imagePickerVc setDidFinishPickingMediaHandle:^(BOSHMediaItem *media) {
            BOTHEditorViewController *controller = BOTHEditorViewController.new;
            controller.videoItem = media;
            [weakimagePickerVc pushViewController:controller animated:YES];
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    else if(actionType == BOSH_ACTION_CREATE_GIF)
    {
//        [self makeFireworksDisplay:self.view.layer];
        [sssv startAnimation];
        
    }
    else if(actionType == BOSH_ACTION_HELP)
    {
        BOSHTimelineViewController *vc = [BOSHTimelineViewController new];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if(actionType == BOSH_ACTION_JOIN_Camera)
    {
//        CALayer *layer = [BOSHGifOverlay overlay].overlayer;
//        layer.frame = CGRectMake(80, 80, layer.bounds.size.width/2,  layer.bounds.size.height/2);
//        [self.view.layer addSublayer:layer];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [[NSBundle mainBundle] URLForResource:@"sh.gif" withExtension:nil] ]];
//        [UIImage imageNamed:@"timg.png"]
        
//        [BOSHShareManager shareImage:image completion:^(NSError *erro) {
//
//        }];
        [BOSHShareManager shareVideo:[[NSBundle mainBundle] URLForResource:@"ss.mp4" withExtension:nil] completion:^(NSError *erro) {

        }];
    }
    else if(actionType == BOSH_ACTION_JOIN_LONG_PICTURE)
    {
        
        BOSHOutputViewController *vc  = [BOSHOutputViewController new];
         [self presentViewController:vc animated:YES completion:nil];
        return;
//        [self presentiTunesMediaPickerController];
        BOSHProgressView *pregross = [[BOSHProgressView alloc] initWithFrame:CGRectMake(20, 30, self.view.width - 40, [BOSHProgressView  preferHeight])];
        [self.view addSubview:pregross];
        pregross.duration = 90000;
        UIImage *image = [UIImage imageNamed:@"bgStory"];
        [pregross setImages:@[image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image]];
    }
}



#pragma mark -使用系统自带的控制器

- (void)presentiTunesMediaPickerController
{
    //1.创建媒体选择器
    /**MPMediaType（大概有13种，这里只列出比较常用的几种）
     MPMediaTypeMusic:音乐歌曲
     MPMediaTypePodcast：博客（有声杂志）
     MPMediaTypeAudioITunesU:iTuneU中的有声读物
     MPMediaTypeMovie：电影
     */
    MPMediaPickerController *controller = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    //2.是否支持多选,默认为no
    controller.allowsPickingMultipleItems = YES;
    //在导航栏的上方添加一个提示文本
//    controller.prompt = @"传智播客-黑马程序员";
    //3.设置代理（代理比较简单，只有两个方法，完成选取和取消选取）
    controller.delegate = self;
    //4.弹出媒体选择器
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark -MPMediaPickerControllerDelegate

//完成选取
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    for (MPMediaItem *song in mediaItemCollection.items) {
        
        //解析数据
        [self resolverMediaItem:song];
        
    }
    
    
    //解除媒体选择器器
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

//取消选取
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    //解除媒体选择器器
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -解析iTune音乐数据
- (void)resolverMediaItem:(MPMediaItem *)song
{
    //歌名
    NSString *name = [song valueForProperty: MPMediaItemPropertyTitle];
    //歌曲路径
    NSString *url = [song valueForProperty: MPMediaItemPropertyAssetURL];
    //歌手名字
    NSString *songer = [song valueForProperty: MPMediaItemPropertyArtist];
    //歌曲时长（单位：秒）
    NSTimeInterval INW = [[song valueForProperty: MPMediaItemPropertyPlaybackDuration] doubleValue];
    NSString *time;
    if((int)INW%60<10)
    {
        time = [NSString stringWithFormat:@"%d:0%d",(int)INW/60,(int)INW%60];
    }
    else
    {
        time = [NSString stringWithFormat:@"%d:%d",(int)INW/60,(int)INW%60];
    }
    if(songer == nil)
    {
        songer = @"未知歌手";
    }
    //歌曲插图（如果没有插图，则返回nil）
    MPMediaItemArtwork *artwork = [song valueForProperty: MPMediaItemPropertyArtwork];
    //从插图中获取图像，参数size是图像的大小
    UIImage *image = [artwork imageWithSize:CGSizeMake(50, 50)];
    
//    self.label.text = [NSString stringWithFormat:@"歌名：%@ \n 歌曲路径：%@ \n 歌手名字:%@ \n 歌曲时长%@ \n 歌曲插图：%@",name,url,songer,time,image];
}

@end
