//
//  UUVirtualTansactionBuyingViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionBuyingViewController.h"
#import "UUVirtualTansactionHoldStockViewCell.h"
#import "UUStockSearchViewController.h"
#import "UUStockModel.h"
#import "UUTransactionHandler.h"
#import "UUMarketQuationHandler.h"
#import "UUStockDetailModel.h"
#import "UUTransactionAssetModel.h"
#import "UUTransactionHoldModel.h"
#import "NSTimer+Addition.h"
#import "UUDatabaseManager.h"
@implementation UUVirtualTansactionBuyingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _type ? @"模拟卖出" :  @"模拟买入" ;
    self.view.backgroundColor = k_BG_COLOR;
    [self configSubViews];

    [self loadData];

    [self refreshData];
}

- (void)refreshData
{
    removeObserver(_observer)
    
    if (_buyingView.stockCode.length == 0) {
        return;
    }
   _observer = [[UUMarketQuationHandler sharedMarkeQuationHandler] getStockDetailWithCode:_buyingView.stockCode type:_buyingView.market success:^(UUStockDetailModel *detailModel) {
            _buyingView.detailModel = detailModel;

    } failue:^(NSString *errorMessage) {
        
    }];
}

- (void)loadData
{
    if (_type == 0)
    {
        [[UUTransactionHandler sharedTransactionHandler] getBalanceSuccess:^(UUTransactionAssetModel *assetModel) {
            _buyingView.useableValue = assetModel.usableBalance;
        } failure:^(NSString *errorMessage) {
            
        }];
    }
    else
    {
        _buyingView.useableValue = self.holdCount;
        if (_buyingView.stockCode != nil) {
            //获取单只股票持仓
            [[UUTransactionHandler sharedTransactionHandler] getHoldWithCode:_buyingView.stockCode success:^(NSArray *holdModelArray) {
                if (holdModelArray.count == 0) {
                    return ;
                }
                UUTransactionHoldModel *holdModel = [holdModelArray firstObject];
                self.holdCount = holdModel.amount - holdModel.tradeFreeze;
                _buyingView.useableValue = self.holdCount;
            } failure:^(NSString *errorMessage) {
                
            }];
        }
    }
    //获取持仓
    [[UUTransactionHandler sharedTransactionHandler] getHoldWithCode:@"" success:^(NSArray *dataArray) {
        _dataArray = [dataArray copy];
        [_tableView reloadData];
    } failure:^(NSString *errorMessage) {
    }];
}

#pragma mark - configSubViews
- (void)configSubViews
{
    CGRect frame = self.view.bounds;
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    _tableView.tableHeaderView = [self headerView];
    [self.view addSubview:_tableView];
}

- (UIView *)headerView
{
    _buyingView = [[UUVirtualTansactionBuyingView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUVirtualTansactionBuyingViewHeight) ];
    _buyingView.delegate = self;
    _buyingView.stockCode = _stockModel.code;
    _buyingView.stockName = _stockModel.name;
    _buyingView.market = _stockModel.market;
    _buyingView.type = self.type;
    return _buyingView;
}

#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    if (actionTag == stockCodeTextFieldActionTag) {
        UUStockSearchViewController *searhVC = [[UUStockSearchViewController alloc] init];
        searhVC.type = 2;
        [searhVC setSuccess:^(UUStockModel *stockModel){
        
            _buyingView.stockCode = stockModel.code;
            _buyingView.stockName = stockModel.name;
            _buyingView.market = stockModel.market;
            [self loadData];
            [self refreshData];
        }];
        [self.navigationController pushViewController:searhVC animated:NO];
    }else if (actionTag ==buyingButtonActionTag){
        
        if (_buyingView.stockCode == nil || _buyingView.stockCode.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入股票代码" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        
        if (_buyingView.count <= 0) {
            [SVProgressHUD showImage:nil status:@"委托数量必须大于零"];
            return;
        }
        
        NSString *title = nil;
        if (self.type == 0) {
            title = @"委托买入确认";
        }else if (self.type == 1){
            
            title = @"委托卖出确认";
        }
        
        NSString *message = [NSString stringWithFormat:@"市  场：A股模拟交易\n股票代码：%@\n股票名称：%@\n委托价格：%@\n委托数量：%@",_buyingView.stockCode,_buyingView.stockName,_buyingView.price,@(_buyingView.count)];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];

        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"正在执行..." maskType:SVProgressHUDMaskTypeBlack];
        [[UUTransactionHandler sharedTransactionHandler] makeOrderWithCode:_buyingView.stockCode buySell:_type price:[_buyingView.price floatValue] amount:_buyingView.count success:^(id obj) {
            [SVProgressHUD showSuccessWithStatus:@"委托成功"];
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
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
    static NSString *cellId = @"UUVirtualTansactionHoldStockViewCell";
    
    UUVirtualTansactionHoldStockViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUVirtualTansactionHoldStockViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.holdModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUVirtualTansactionHoldStockViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //持仓明细
    UILabel * titleLabel = [UIKitHelper labelWithFrame:CGRectMake(0, UUVirtualTansactionBuyingViewHeight + 0.5 + k_TOP_MARGIN, CGRectGetWidth(tableView.bounds), 36.0f) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    titleLabel.backgroundColor = k_BG_COLOR;
    titleLabel.text = @"   持仓明细";
    return titleLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUTransactionHoldModel *holdModel = [_dataArray objectAtIndex:indexPath.row];
    
   UUStockModel *stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:holdModel.code market:UUStockExchangeAShareType];

    _buyingView.stockName = stockModel.name;
    _buyingView.stockCode = stockModel.code;
    _buyingView.market = stockModel.market;
    
    [self loadData];
    [self refreshData];
    
    [_tableView setContentOffset:CGPointZero animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        [_buyingView endEditing:YES];
}

- (void)backAction
{
    [super backAction];
    
    removeObserver(_observer);
    
    
    
}

@end
