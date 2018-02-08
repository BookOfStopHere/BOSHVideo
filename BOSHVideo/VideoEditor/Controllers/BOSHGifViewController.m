//
//  BOSHGifViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHGifViewController.h"
#import "BOSHAPI.h"
#import "BOTHMacro.h"
#import "UIView+Geometry.h"
#import "BOSHGIFGRequest.h"
#import "BOSHNetwork.h"
#import "BOSHWaterFlowLayout.h"
#import "BOSHCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "BOSHFileRequest.h"
#import "BOSHMaskView.h"
#import "BOSHTextInputViewController.h"


@interface BOSHGifViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate,BOSHWaterFlowLayoutDelegate>
@property (nonatomic, strong)  BOSHNetwork *network;
@property (nonatomic, strong)  BOSHNetwork *downloadNetwork;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) BOSHMaskView *maskView;
@end

@implementation BOSHGifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x101010);
    self.navigationController.navigationBarHidden = YES;
    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.frame = self.view.bounds;
//    [self.view addSubview:effectview];
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60 - 10, 20, 60, 44)];
    [btn setTitle:@"取消" forState:0];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(backHandler) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = btn;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 20, self.view.width - 60 - 10 - 5 - 10, 44)];
    _searchBar.text = @"请输入查找关键词";
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleBlack;
    _searchBar.barTintColor = UIColorFromRGBA(0x111111, .4);
    
//    [UIColor clearColor];
    [self.view addSubview:_searchBar];
    
    self.dataSource = [NSMutableArray array];
    [self loadContentView];
    
    [self requestWithKeyWords:@"美女" limit:50];
}

- (void)requestWithKeyWords:(NSString *)keywords limit:(int)limit
{
    BOSHGIFGRequest *request = [BOSHGIFGRequest new];
    request.q = keywords;
    request.limit = limit;
    if(!self.network)
    {
        self.network = [BOSHNetwork new];
    }
    [self.network cancel];
    [self.dataSource removeAllObjects];
    @weakify(self);
    [self.network sendRequest:request responseHandler:^(id response, NSError *err) {
        if(response && [response isKindOfClass:NSDictionary.class])
        {
            NSDictionary *dic = response;
            NSArray *data = dic[@"data"];
            if(data.count > 0)
            {
                for(NSDictionary *images in data)
                {
                    BOSHGIFModel *model = [BOSHGIFModel yy_modelWithDictionary:images];
                    if(model)
                    {
                        [weakself.dataSource addObject:model];
                    }
                }
                [weakself.collectionView reloadData];
               [MBProgressHUD hideHUDForView:weakself.view animated:YES];
            }
            
        }
        if(err)
        {
             [MBProgressHUD hideHUDForView:weakself.view animated:NO];
            MBProgressHUD *hub = [MBProgressHUD HUDForView:weakself.view];
            hub.label.text = @"加载失败";
            [hub hideAnimated:YES afterDelay:3.0];
        }
    }];
}

- (void)loadContentView
{
    BOSHWaterFlowLayout *waterFlowLayout = [[BOSHWaterFlowLayout alloc]init];
    waterFlowLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNAVIGATIONH, self.view.width, self.view.height - kNAVIGATIONH -kDeviceBottom) collectionViewLayout:waterFlowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    // 设置代理
    self.collectionView.delegate = self;
    // 设置数据源
    self.collectionView.dataSource = self;
    // 注册 cell
    [self.collectionView registerClass:[BOSHCollectionViewCell class] forCellWithReuseIdentifier:@"BOSHCollectionViewCell"];
    [self.view addSubview:self.collectionView];
}

- (BOSHGIFModel *)modelAbIndex:(NSIndexPath *)indexPath
{
    if(self.dataSource.count && indexPath.row < self.dataSource.count)
    {
        return self.dataSource[indexPath.row];
    }
    return nil;
}

- (CGFloat)waterflowLayout:(BOSHWaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
      if(self.selectedIndexPath && self.selectedIndexPath.row == indexPath.row)
      {
            BOSHGIFModel *gifModel = [self modelAbIndex:indexPath];
            return (width/gifModel.height)*gifModel.height;
      }
    else
    {
        BOSHGIFModel *gifModel = [self modelAbIndex:indexPath];
        return (width/gifModel.coverW)*gifModel.coverH;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOSHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BOSHCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    if ([[self modelAbIndex:indexPath] isKindOfClass:[BOSHGIFModel class]]) {
        BOSHGIFModel *gifModel = [self modelAbIndex:indexPath];
        cell.gifModel = gifModel;
    }
    if(self.selectedIndexPath && self.selectedIndexPath.row == indexPath.row)
    {
        [cell.gifImageView sd_setImageWithURL:[NSURL URLWithString:cell.gifModel.url]];
        cell.cacheButton.hidden = NO;
        if([[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:cell.gifModel.url]])
        {
            [cell setCacheState:1];
        }
        else
        {
            [cell setCacheState:0];
        }
    }
    else
    {
        [cell.gifImageView sd_setImageWithURL:[NSURL URLWithString:cell.gifModel.coverImage]];
        cell.cacheButton.hidden = YES;
    }
    @weakify(self);
    [cell setDownloadActionHandler:^(BOSHGIFModel *gifModel){
        [weakself downloadGIF:gifModel];
    }];
    cell.layer.borderColor = RandomColor.CGColor;
    cell.layer.borderWidth = 1.5;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if(self.selectedIndexPath && self.selectedIndexPath.row == indexPath.row) return;
    BOSHCollectionViewCell *oldSeletedCell = (BOSHCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    if(oldSeletedCell)
    {
        BOSHGIFModel *gifModel = [self modelAbIndex:self.selectedIndexPath];
        [[SDImageCache sharedImageCache] removeImageForKey:oldSeletedCell.gifModel.url];
        [oldSeletedCell.gifImageView sd_setImageWithURL:[NSURL URLWithString:gifModel.coverImage]];
        oldSeletedCell.cacheButton.hidden = YES;
    }
    
    self.selectedIndexPath = indexPath;
    BOSHCollectionViewCell *seletedCell = (BOSHCollectionViewCell*)[collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    [seletedCell.gifImageView sd_setImageWithURL:[NSURL URLWithString:seletedCell.gifModel.url]];
    seletedCell.cacheButton.hidden = NO;
}
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark 下载
- (void)downloadGIF:(BOSHGIFModel *)gifModel
{
//    BOSHFileRequest *request = [BOSHFileRequest new];
//    request.url = gifModel.url;
//    if(self.downloadNetwork == nil)
//    {
//        self.downloadNetwork =  [BOSHNetwork new];
//    }
//    [self.downloadNetwork cancel];
//    [self.downloadNetwork sendFileRequest:request responseHandler:^(NSDictionary *response, NSError *err) {
//        if(response && [response isKindOfClass:NSData.class])
//        {
//
//        }
//    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:gifModel.url] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        [MBProgressHUD HUDForView:weakself.view].progress = (receivedSize  + 0.0)/expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL.absoluteString toDisk:YES];
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
         BOSHCollectionViewCell *seletedCell = (BOSHCollectionViewCell*)[weakself.collectionView cellForItemAtIndexPath:weakself.selectedIndexPath];
        [seletedCell setCacheState:1];
        if(weakself.selectedHandler) weakself.selectedHandler(gifModel);
        [weakself backHandler];
    }];
    
    
//    BOSHTextInputViewController *n = [BOSHTextInputViewController new];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:n];
//    nav.view.frame = CGRectMake(0, self.view.height - 300, self.view.width, 300);
////    [self presentViewController:nav animated:YES completion:nil];
//    [self.view addSubview:nav.view];
//    [self addChildViewController:nav];
}

- (void)backHandler
{
    [self hiddenKeyboard];
    [self dismissSelf];
}

- (void)addMaskView
{
    if(self.maskView == nil)
    {
        self.maskView = [[BOSHMaskView alloc] initWithFrame:self.view.bounds];
        self.maskView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.maskView];
        
        [self.maskView addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
        self.maskView.passthroughViews = @[self.searchBar,self.backBtn];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self addMaskView];
    searchBar.text = @"";
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestWithKeyWords:searchBar.text limit:200];
     [self hiddenKeyboard];
}

#pragma mark keyboard
- (void)dismissKeyboard
{
    self.searchBar.text = @"请输入查找关键词";
    [self hiddenKeyboard];
}

- (void)hiddenKeyboard
{
    [self.searchBar resignFirstResponder];
    self.maskView.passthroughViews = nil;
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
