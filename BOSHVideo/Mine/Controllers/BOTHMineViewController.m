//
//  BOTHMineViewController.m
//  BOSHVideo
//
//  Created by yang on 2017/10/30.
//  Copyright © 2017年 yang. All rights reserved.
//

#import "BOTHMineViewController.h"
#define kWidth 200
#define kHeight 90
@interface BOTHMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_table;
    NSArray *_items;
}
@end

@implementation BOTHMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    _items = @[@"设置分辨率",@"版本",@"关于",@"视频质量"];
    self.table;
}


- (UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - _items.count * kHeight)/2, kWidth, _items.count * kHeight) style:UITableViewStylePlain];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
    }
    return _table;
}

#pragma -mark
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = UITableViewCell.new;
    cell.textLabel.text = _items[indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithRed:abs(rand())%255/255.0 green:abs(rand())%255/255.0 blue:abs(rand())%255/255.0 alpha:1];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeight;
}

@end
