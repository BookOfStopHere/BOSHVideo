//
//  BOSHFilterViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/11/13.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOSHFilterViewController.h"

@interface BOSHFilterViewController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation BOSHFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- ( UICollectionView *)collectionView
//{
//    if(!_collectionView)
//    {
//        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
//        [_collectionView setDataSource:self];
//        [_collectionView setDelegate:self];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
//        [_collectionView setBackgroundColor:[UIColor redColor]];
//        [_contentVC.view addSubview:_collectionView];
//    }
//    return _collectionView;
//}

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
