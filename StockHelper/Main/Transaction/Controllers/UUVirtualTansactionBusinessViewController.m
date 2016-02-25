//
//  UUVirtualTansactionBusinessViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionBusinessViewController.h"
#import "UUTransactionHandler.h"
#import "UUTransactionModel.h"
#import "UUTabbar.h"
#import <MJRefresh/MJRefresh.h>
@implementation UUVirtualTansactionBusinessViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = @"";
    
    switch (_businessType) {
        case UUVirtualTansactionBusinessDailyDealType:
            title = @"模拟当日成交";
            _remaindKey = @"当日无成交";
            break;
        case UUVirtualTansactionBusinessDailyDelegationType:
            title = @"模拟当日委托";
            _remaindKey = @"当日无委托";

            break;
        case UUVirtualTansactionBusinessPastDealType:
            title = @"模拟历史成交";
            _remaindKey = @"no_data_stock_transaction_history";
            break;
////        case UUVirtualTansactionBusinessPastDelegationType:
//            title = @"模拟历史委托";
            break;
    }
    self.navigationItem.title = title;
    self.view.backgroundColor = k_BG_COLOR;
    [self configSubViews];
    
    [self loadData];
}

#pragma mark - configSubViews
- (void)configSubViews
{
    NSArray *orgItems = @[
                          @{
                              @"title" : @"买入",
                              @"image" : @"Toolbar_buy",
                              @"selectedImage" : @""
                              },
                          @{
                              @"title" : @"卖出",
                              @"image" : @"Toolbar_sell",
                              @"selectedImage" : @""
                              },
                          @{
                              @"title" : @"撤单",
                              @"image" : @"business_remove",
                              @"selectedImage" : @""
                              }
                          ];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0 ; i < orgItems.count ;i++) {
        NSDictionary *dic = [orgItems objectAtIndex:i];
        NSString *title = [dic objectForKey:@"title"];
        UIImage *image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        UIImage *selectedImage = [UIImage imageNamed:[dic objectForKey:@"selectedImage"]];
        UUTabbarItem *item = [[UUTabbarItem alloc] initWithTitle:title image:image selectedImage:selectedImage tag:i];
        [items addObject:item];
    }
    UUToolBar *toolBar = [[UUToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT, CGRectGetWidth(self.view.bounds), k_TABBER_HEIGHT) items:items delegate:self];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:toolBar];
    
    
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT);
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    if (_businessType == UUVirtualTansactionBusinessPastDealType) {
        _tableView.tableHeaderView = [self tableHeaderView];
    }
    [self.view addSubview:_tableView];
    
}

- (UUVirtualTansactionBusinessHeaderView *)tableHeaderView
{
    _headerView = [[UUVirtualTansactionBusinessHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUVirtualTansactionBusinessHeaderViewHieght) target:self action:@selector(searchAction)];
    
    return _headerView;
}

#pragma mark - 查询
- (void)searchAction
{
    [_headerView endEditing:YES];
    [self loadData];
}

#pragma mark -  加载数据
- (void)loadData
{
    
    if (![_tableView.header isRefreshing]) {
        [self showLoading];
    }
    if (_businessType == UUVirtualTansactionBusinessDailyDelegationType)
    {
        /*当日委托*/
        [[UUTransactionHandler sharedTransactionHandler] getOrderSuccess:^(NSArray *dataArray)
         {
            _dataArray = [dataArray mutableCopy];
            [_tableView.header endRefreshing];
            [self stopLoading];
             
             if (_dataArray.count == 0) {
                 [self showNodataWithTitle:k_remainder(_remaindKey) inView:self.view];
                 return;
             }
             
             [_tableView reloadData];

        } failure:^(NSString *errorMessage) {
            [self stopLoading];
        }];
    }else if (_businessType == UUVirtualTansactionBusinessDailyDealType)
    {
        /*当日成交*/
        [[UUTransactionHandler sharedTransactionHandler] getResultSuccess:^(NSArray *dataArray) {
            _dataArray = [dataArray mutableCopy];
            [_tableView.header endRefreshing];
            [self stopLoading];
            
            if (_dataArray.count == 0) {
                [self showNodataWithTitle:k_remainder(_remaindKey) inView:self.view];
                return;
            }
            [_tableView reloadData];

        } failure:^(NSString *errorMessage) {
            [self stopLoading];
            
        }];
    }else if (_businessType == UUVirtualTansactionBusinessPastDealType)
    {
        //历史成交
        [[UUTransactionHandler sharedTransactionHandler] getPositionHistoryStartDate:_headerView.sartDate endDate:_headerView.endDate success:^(NSArray *dataArray) {
            _dataArray = [dataArray copy];
            [_tableView.header endRefreshing];
            [self stopLoading];
            if (_dataArray.count == 0) {
                [self showNodataWithTitle:k_remainder(_remaindKey) inView:self.view];
                return;
            }
            [_tableView reloadData];

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
    static NSString *cellId = @"UUVirtualTansactionBusinessViewCell";
//    
    UUVirtualTansactionBusinessViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUVirtualTansactionBusinessViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.type = self.businessType;
    cell.transactionModel = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUVirtualTansactionBusinessViewCellHeight;
}
@end
