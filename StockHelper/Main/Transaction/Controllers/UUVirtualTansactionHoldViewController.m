//
//  UUVirtualTansactionHoldViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/31.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionHoldViewController.h"

#import "UUVirtualTansactionSelectViewController.h"
#import "UUVirtualTansactionBuyingViewController.h"
#import "UUStockDetailViewController.h"
#import "UUTitleView.h"
#import "UUStockModel.h"
#import "UUTransactionHoldModel.h"
#import "UUTransactionHandler.h"
#import <MJRefresh/MJRefresh.h>
#import "UUDatabaseManager.h"
@interface UUVirtualTansactionHoldViewController ()

@end

@implementation UUVirtualTansactionHoldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = k_BG_COLOR;
    self.navigationItem.title = @"我的持仓";
    [self configSubViews];
    
    [self loadData];
}

- (void)loadData
{
        if (![_tableView.header isRefreshing]) {
            [self showLoading];
        }
    [[UUTransactionHandler sharedTransactionHandler] getHoldWithCode:@"" success:^(NSArray *dataArray) {
        _dataArray = [dataArray copy];
        [_tableView.header endRefreshing];
        [self stopLoading];
        if (_dataArray.count == 0) {
            [self showNodataWithTitle:k_remainder(@"no_data_stock_hold") inView:self.view];
            return ;
        }
        
        [_tableView reloadData];

    } failure:^(NSString *errorMessage) {
        [self stopLoading];
        [_tableView.header endRefreshing];
    }];
}


#pragma mark - configSubViews
- (void)configSubViews
{
    CGRect frame = CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGHT - 64);
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.view addSubview:_tableView];
}


#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUVirtualTansactionHoldStockViewCell";
    
    UUVirtualTansactionHoldStockViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUVirtualTansactionHoldStockViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    cell.holdModel = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = UUVirtualTansactionHoldStockViewCellHeight;
    
    if (_selectedIndexPath != nil && _selectedIndexPath.row == indexPath.row) {
        
        return height + 50.0f;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndexPath = indexPath;
    UUVirtualTansactionHoldStockViewCell *cell = (UUVirtualTansactionHoldStockViewCell *)[tableView cellForRowAtIndexPath:_selectedIndexPath];
    NSArray *cells = [tableView visibleCells];
    for (UUVirtualTansactionHoldStockViewCell *tempCell in cells) {
        tempCell.hiddenButtonView = YES;
    }
    cell.hiddenButtonView = NO;
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

#pragma mark - UUVirtualTansactionHoldStockViewCellDelegate
- (void)holdViewCell:(UUVirtualTansactionHoldStockViewCell *)cell operationWithIndex:(NSInteger)index
{
    UUTransactionHoldModel *holdModel = [_dataArray objectAtIndex:[[_tableView indexPathForCell:cell] row]];

    UUStockModel *stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:holdModel.code market:UUStockExchangeAShareType];
    
    if (index == 2)
    {
        //详情
        UUStockDetailViewController *vc = [[UUStockDetailViewController alloc] initWithStockModel:stockModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //买入或卖出
        UUVirtualTansactionBuyingViewController *buyingVC = [[UUVirtualTansactionBuyingViewController alloc] init];
        buyingVC.holdCount =  holdModel.amount - holdModel.tradeFreeze;
        buyingVC.type = index;
        buyingVC.stockModel = stockModel;
        [self.navigationController pushViewController:buyingVC animated:YES];
    }
}
@end
