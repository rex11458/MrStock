//
//  UUGeniusRankViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUGeniusRankViewController.h"
#import "UUPersonalHomeViewController.h"
#import "UUDiscoverHandler.h"
#import "UUGeniusModel.h"
@implementation UUGeniusRankViewController

- (id)initWithTitle:(NSString *)title type:(UUGeniusType)type
{
    if (self = [super init]) {
        self.navigationItem.title = title;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.view addSubview:_tableView];
}

- (void)loadData
{
    if (![_tableView.header isRefreshing]) {
        [self showLoading];
    }
    [[UUDiscoverHandler sharedDiscoverHandler] getGeniusListWithType:self.type success:^(NSArray *dataArray) {
        
        _dataArray = [dataArray copy];
        [_tableView reloadData];
        [self stopLoading];
        [_tableView.header endRefreshing];
        
    } failure:^(NSString *errorMessage) {
        [self stopLoading];
        [_tableView.header endRefreshing];
    }];
}

#pragma mark - UITableView delegatge、datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUGeniusRankViewCell";
    
    UUGeniusRankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUGeniusRankViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.type = self.type;
    }
    cell.indexPath = indexPath;
    cell.geniusModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUGeniusRankViewCellHeight ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUPersonalHomeViewController *personalHomeVC = [[UUPersonalHomeViewController alloc] init];
    UUGeniusModel *geniusModel = [_dataArray objectAtIndex:indexPath.row];
    personalHomeVC.userId = geniusModel.userID;
    [self.navigationController pushViewController:personalHomeVC animated:YES];
}


@end
