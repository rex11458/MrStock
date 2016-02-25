//
//  UUFansListViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/6.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFansListViewController.h"
#import "UUFansListViewCell.h"
#import "UUMeHandler.h"
#import "UUPersonalHomeViewController.h"
#import "UUFocusModel.h"
@interface UUFansListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    NSInteger _pageIndex;
    NSInteger _pageCount;
}
@end

@implementation UUFansListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = 1;
    _pageCount = 10;
    
    self.navigationItem.title = @"我的粉丝";
    [self configSubViews];
    
    [self loadData];
}

- (void)configSubViews
{
    CGRect frame = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    [self.view addSubview:_tableView];
    
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    _tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
}

- (void)loadData
{
    _pageIndex = 0;
    if (!_tableView.header.isRefreshing) {
        [self showLoading];
    }
    
    [[UUMeHandler sharedMeHandler] getFansListWithType:0 pageIndex:_pageIndex pageCount:_pageCount success:^(NSArray *models) {
        _dataArray = [models copy];
        [_tableView reloadData];
        [self stopLoading];
        [_tableView.header endRefreshing];

    } failure:^(NSString *errorMessage) {
        [self stopLoading];
        [_tableView.header endRefreshing];

    }];
}

- (void)loadMore
{
    _pageIndex = (_pageIndex + 1) * _pageCount;
    [[UUMeHandler sharedMeHandler] getFansListWithType:0 pageIndex:_pageIndex pageCount:_pageCount success:^(NSArray *models) {
        NSArray *temp = [[NSArray alloc] initWithArray:_dataArray];
        
        _dataArray = [temp arrayByAddingObjectsFromArray:models];
        
        [_tableView reloadData];
        [self stopLoading];
        [_tableView.footer endRefreshing];

    } failure:^(NSString *errorMessage) {
        [self stopLoading];
        [_tableView.footer endRefreshing];

    }];
}

#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUFansListViewCell";
    
    UUFansListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUFansListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    cell.focusModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUFansListViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUFansListViewCell *cell = (UUFansListViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    UUPersonalHomeViewController *homeVC = [[UUPersonalHomeViewController alloc] init];
    homeVC.userId = cell.focusModel.customerID;
    
    [self.navigationController pushViewController:homeVC animated:YES];
}

@end
