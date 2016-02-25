//
//  UUStockDetailView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailView.h"
#import "BaseDataSource.h"
#import <MJRefresh/MJRefresh.h>
#import "UUStockDetailCommentViewCell.h"
@implementation UUStockDetailView


- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    _tableView.dataSource = dataSource;
}

- (id<UITableViewDataSource>)dataSource
{
    return _tableView.dataSource;
}

- (id<UITableViewDelegate>)delegate
{
    return _tableView.delegate;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    _tableView.delegate = delegate;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = k_BG_COLOR;//[UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        
//        self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return self;
}

- (void)refresh
{
    BaseDataSource *dataSource = self.dataSource;
    [dataSource loadDataType:0 Success:^(id obj) {
        [self reload];
        [self.tableView.header endRefreshing];
    } failure:^(NSString *errorMessage) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMore
{
    BaseDataSource *dataSource = self.dataSource;
    if (dataSource == nil) {
        return;
    }
    [dataSource loadDataType:1 Success:^(id obj) {
        [_tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(NSString *errorMessage) {
        [self.tableView.footer endRefreshing];
    }];
}

- (void)reload
{
    BaseDataSource *dataSource = self.dataSource;
    
        [dataSource loadDataType:0 Success:^(id obj) {
            [_tableView reloadData];
            [self.tableView.header endRefreshing];
        } failure:^(NSString *errorMessage) {
            [self.tableView.header endRefreshing];
        }];
    [self.tableView reloadData];
    [self.tableView reloadData];
}

- (void)layoutSubviews
{
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


@end
