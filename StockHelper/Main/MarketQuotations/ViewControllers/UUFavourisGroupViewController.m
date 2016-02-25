//
//  UUFavourisGroupViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisGroupViewController.h"
#import "UUFavourisViewCell.h"
#import "UUStockListHeaderView.h"
@interface UUFavourisGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation UUFavourisGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configSubViews];
}

- (void)configSubViews
{
    UUStockListHeaderView *headerView = [[UUStockListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUStockListHeaderViewHeight) titleArray:@[@"名称代码",@"净值",@"日收益"]];
    [self.view addSubview:headerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UUStockListHeaderViewHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - UUStockListHeaderViewHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;//_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUFavourisViewCell";
    UUFavourisViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UUFavourisViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell fillData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}

@end
