//
//  UUTransactionViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTransactionViewController.h"
#import "UULoginViewController.h"
#import "UUTransactionHandler.h"
#import "UUVirtualTansactionBusinessViewController.h"
#import "UUVirtualTansactionBuyingViewController.h"
#import "UUVirtualTansactionHoldViewController.h"
#import "UUVirtualTansactionSelectViewController.h"
#import "UUVirtualTansactionWithdrawViewController.h"
#import "UUTradeAnalyViewController.h"
#import "UUTitleView.h"
#import <MJRefresh/MJRefresh.h>
@implementation UUTransactionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    self.tabBarController.navigationItem.titleView = [self titleView];
    self.tabBarController.navigationItem.title = @"模拟交易";
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    
    //是否显示登录界面
    _logoutView.hidden = [UUserDataManager userIsOnLine];
    
    if (![UUserDataManager userIsOnLine]) {
        NSInteger index = self.navigationController.viewControllers.count - 1;
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:index success:^{
            [self loadData];
        } failed:^{
            self.tabBarController.selectedIndex = 0;
        }];
        
        [self.tabBarController.navigationController pushViewController:loginVC animated:NO];
    }else{
        [self loadData];
    }
}

//- (UUTitleView *)titleView
//{
//    UUTitleView *titleView = [[UUTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 30.0f) selectedIndex:^(NSInteger index) {
//        
//    }];
//    titleView.titleArray = @[@"模拟交易",@"实盘交易"];
//    return titleView;
//}


- (void)loadData
{
//    [self showLoading];
    //资金信息
    [[UUTransactionHandler sharedTransactionHandler] getBalanceSuccess:^(UUTransactionAssetModel *assetModel) {
        _transactionView.assetModel = assetModel;
        [self stopLoading];
        [_transactionView.header endRefreshing];
    } failure:^(NSString *errorMessage) {
//        [self stopLoading];
        [_transactionView.header endRefreshing];
    }];
    //收益走势
    [[UUTransactionHandler sharedTransactionHandler] getProfitHistoryWithUserId:[UUserDataManager sharedUserDataManager].user.customerID startDate:@"" endDate:@"" success:^(NSArray *profitArray) {
        
        _transactionView.chatView.profitArray = profitArray;
        
    } failure:^(NSString *errorMessage) {
        
    }];
}

#pragma mark - configSubViews
- (void)configSubViews
{
    CGRect frame = CGRectMake(0, 0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT);

    _transactionView = [[UUVirtualTransactionView alloc] initWithFrame:frame];
    _transactionView.transactionDelegate = self;
    _transactionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  
    _transactionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    [_transactionView.header beginRefreshing];
    [self.view addSubview:_transactionView];
    
    //登录界面
//    _logoutView = [[UUTransactionLogoutView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGHT - k_TABBER_HEIGHT - 64) login:^{
//        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithSuccess:^{
//            
//        } failed:^{
//            
//        }];
//        
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }];
//    
    
    [self.view addSubview:_logoutView];
}

#pragma mark - UUVirtualTransactionViewDelegate
- (void)transactionView:(UUVirtualTransactionChatView *)transactionView didSelectedIndex:(NSInteger)index
{
    if (index == 0 || index == 1) {
       // 买入 卖出
        UUVirtualTansactionBuyingViewController *buyingVC = [[UUVirtualTansactionBuyingViewController alloc] init];
        buyingVC.type = index;
        [self.navigationController pushViewController:buyingVC animated:YES];
    }else if (index == 2){
        //撤单
        UUVirtualTansactionWithdrawViewController *withdrawVC = [[UUVirtualTansactionWithdrawViewController alloc] init];
        [self.navigationController pushViewController:withdrawVC animated:YES];
    }else if(index == 3){
        //持仓
        UUVirtualTansactionHoldViewController *holdVC = [[UUVirtualTansactionHoldViewController alloc] init];
        [self.navigationController pushViewController:holdVC animated:YES];
    }else if (index == 4){
        UUVirtualTansactionSelectViewController *selectVC = [[UUVirtualTansactionSelectViewController alloc] init];
        [self.navigationController pushViewController:selectVC animated:YES];
    }else if (index == 5){
        //查看交易分析
        if (_transactionView.assetModel != nil && _transactionView.chatView.profitArray != nil) {
            UUTradeAnalyViewController *analyVC = [[UUTradeAnalyViewController alloc] init];
            analyVC.userId = [UUserDataManager sharedUserDataManager].user.customerID;
            analyVC.assetModel = _transactionView.assetModel;
            analyVC.profitArray = _transactionView.chatView.profitArray;
            [self.navigationController pushViewController:analyVC animated:YES];
        }
    }
}
@end
