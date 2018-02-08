//
//  BOSHMenuViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHMenuViewController.h"
#import "BOSHEditorView.h"
#import "BOTHMacro.h"
#import "BOSHTextOverlayContainer.h"
#import "BOSHGifViewController.h"
#import "BOSHTextInputViewController.h"
#import "BOSHTextConfigViewController.h"
#import "BOSHTimelineViewController.h"

@interface BOSHMenuViewController ()
@property (nonatomic) CGRect frame;
@property (nonatomic, strong) BOSHEditorView *editorView;
@property (nonatomic, strong) BOSHTextOverlayContainer *overlayContainer;
@end

@implementation BOSHMenuViewController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if(self)
    {
        self.frame = frame;
    }
    return self;
}


- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:self.frame];
    self.editorView = [[BOSHEditorView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.editorView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0x101010);
    // Do any additional setup after loading the view.
    @weakify(self);
    [self.editorView setActionHandler:^(BOSHEditorViewAction actionType) {
        [weakself dispatchAction:actionType];
    }];
}


- (void)dispatchAction:(BOSHEditorViewAction) actionType
{
    if(actionType == BOSHEditorViewActionPasters)//贴纸
    {
        BOSHGifViewController *gifVC = [[BOSHGifViewController alloc] init];
//        [self pushViewController:gifVC animated:YES];
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
        BOSHTimelineViewController *transitionVC = [[BOSHTimelineViewController alloc] initWithFrame:self.view.bounds];
//        transitionVC.videTracks = self.timelineAsset.videos;
//        transitionVC.ins = self.timelineAsset.transations;
        [self.navigationController pushViewController:transitionVC animated:YES];

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
        BOSHTextConfigViewController *n  =[BOSHTextConfigViewController new];
        [self.navigationController pushViewController:n animated:YES];
        @weakify(self);
        [n setCompletitionHandler:^{
            if(weakself.delegate && [weakself.delegate respondsToSelector:@selector(menuViewController:didSelectFontParamters:)])
            {
                [weakself.delegate menuViewController:weakself didSelectFontParamters:nil];
            }
        }];
    }
    else if(actionType == BOSHEditorViewActionWatermark)//水印
    {
        BOSHTextInputViewController *textInputVC = BOSHTextInputViewController.new;
        [self.navigationController pushViewController:textInputVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
