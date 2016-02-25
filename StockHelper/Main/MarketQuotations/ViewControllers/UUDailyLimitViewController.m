//
//  UUDailyLimitViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUDailyLimitViewController.h"
#import "UUDailyLimitViewCell.h"
#import "UUStockDetailViewController.h"
#import "UUReportSortStockModel.h"
@interface UUDailyLimitViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    id _observer;
}
@end

@implementation UUDailyLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = nil;
    if (_rankType == UUIncreaseRateType) {
        title = @"涨幅榜";
    }else if (_rankType == UUDecreaseRateType){
        title = @"跌幅榜";
    }else if (_rankType == UUAmplitudeRateType){
        title = @"振幅榜";
    }else if (_rankType == UUExchangeRateType){
        title = @"换手率榜";
    }else if (_rankType == UUHotProfessionType){
        title = @"热门行业";
    }else if (_rankType == UUConceptType){
        title = @"概念板块";
    }
    self.navigationItem.title = title;

    [self configSubViews];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_rankType == UUDecreaseRateType) {
        [self.navigationController.navigationBar setBackgroundImage:[UIKitHelper imageWithColor:[UIColorTools colorWithHexString:@"5CD27D" withAlpha:1.0f]] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forBarMetrics:UIBarMetricsDefault];
}

- (void)configSubViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    [self.view addSubview:_tableView];
    
    UUDailyLimitViewHeaderView *headerView = [[UUDailyLimitViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUDailyLimitViewHeaderViewHeight)];
    headerView.rankType = _rankType;
    _tableView.tableHeaderView = headerView;
}

- (void)loadData
{
    [self showLoading];
    if (_rankType == UUHotProfessionType) {
        //热门行业
       [[UUMarketQuationHandler sharedMarkeQuationHandler] getReportBlockWithType:0 count:50 sortType:0 Success:^(NSArray *dataArray) {
           _dataArray = [dataArray copy];
           [_tableView reloadData];
           [self stopLoading];

           
       } failure:^(NSString *errorMessage) {
            
        }];
        
    }else if (_rankType == UUConceptType){
        //热门行业
        [[UUMarketQuationHandler sharedMarkeQuationHandler] getReportBlockWithType:1 count:50 sortType:0 Success:^(NSArray *dataArray) {
            _dataArray = [dataArray copy];
            [_tableView reloadData];
            [self stopLoading];

        } failure:^(NSString *errorMessage) {
            
        }];
    }
    else{
        //--
        [[UUMarketQuationHandler sharedMarkeQuationHandler] getReportSortWithType:_rankType count:10 success:^(NSArray *dataArray) {
            _dataArray = [dataArray copy];
            [_tableView reloadData];
            [self stopLoading];
            
        } failure:^(NSString *errorMessage) {
            [self stopLoading];
        }];
    }
}


#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUDailyLimitViewCell";
    
    UUDailyLimitViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUDailyLimitViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.rankType = _rankType;
    }
    if (_rankType == UUHotProfessionType || _rankType == UUConceptType)
    {
        cell.blockModel = [_dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        cell.sortStockModel = [_dataArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUDailyLimitViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUReportSortStockModel *model = [_dataArray objectAtIndex:indexPath.row];
    UUStockDetailViewController *vc = [[UUStockDetailViewController alloc] initWithStockModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
