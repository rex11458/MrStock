//
//  UUVirtualTansactionWithdrawViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/6.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionWithdrawViewController.h"
#import "UUVirtualTansactionWithdrawViewCell.h"
#import "UUToolBar.h"
#import "UUTabbar.h"
#import "UUTransactionHandler.h"
#import <MJRefresh/MJRefresh.h>
#import "UUTransactionDelegateModel.h"
@interface UUVirtualTansactionWithdrawViewController ()<UITableViewDataSource,UITableViewDelegate,UUToolBarDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
    
    UITableView *_tableView;
    UIButton *_selectedButton;
}
@end

@implementation UUVirtualTansactionWithdrawViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"模拟交易撤单";
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
                              @"title" : @"查询",
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
    

    [self.view addSubview:_tableView];
    
}


#pragma mark -  加载数据
- (void)loadData
{
    if (![_tableView.header isRefreshing]) {
        [self showLoading];
    }
    [[UUTransactionHandler sharedTransactionHandler] getCancelOrderListSuccess:^(NSArray *dataArray) {
        _dataArray = [dataArray mutableCopy];
        [_tableView.header endRefreshing];
        [self stopLoading];
        
        if (_dataArray.count == 0) {
        
            [self showNodataWithTitle:k_remainder(@"no_data_stock_delegate") inView:self.view];
            return ;
        }
        
        [_tableView reloadData];
    } failue:^(NSString *errorMessage) {
        [_tableView.header endRefreshing];
        [self stopLoading];
    }];
}


#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUVirtualTansactionWithdrawViewCell";
    //
    UUVirtualTansactionWithdrawViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUVirtualTansactionWithdrawViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId target:self action:@selector(withdrawAction:)];
    }
    cell.transactionModel = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUVirtualTansactionWithdrawViewCellHeight;
}


#pragma mark - 撤单
- (void)withdrawAction:(UIButton *)button
{
    _selectedButton = button;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定撤销此次委托?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UUVirtualTansactionWithdrawViewCell * cell = (UUVirtualTansactionWithdrawViewCell *)[self superviewOfType:[UUVirtualTansactionWithdrawViewCell class] forView:_selectedButton];
        [SVProgressHUD showWithStatus:@"正在执行..." maskType:SVProgressHUDMaskTypeBlack];
        [[UUTransactionHandler sharedTransactionHandler] cancelOrderWithOrderID:cell.transactionModel.orderID success:^(id obj) {
            [SVProgressHUD showSuccessWithStatus:@"撤单成功"];
            
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_tableView reloadData];
            
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }
}


- (UIView *)superviewOfType:(Class )paramSuperviewClass forView:(UIView *)paramView{
    if (paramView.superview != nil)
    {
        if ([paramView.superview isKindOfClass:paramSuperviewClass])
        {
            return paramView.superview;
        }
        else
        {
            return [self superviewOfType:paramSuperviewClass forView:paramView.superview];
        }
    }
    return nil;
}


@end
