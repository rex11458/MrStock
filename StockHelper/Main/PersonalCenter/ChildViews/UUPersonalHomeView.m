//
//  UUPersonalHomeView.m
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalHomeView.h"
#import "BaseDataSource.h"
#import "UUStockDetailCommentViewCell.h"
@implementation UUPersonalHomeView

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

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = k_BG_COLOR;//[UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f];
        
        self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UUStockDetailCommentViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:UUStockDetailCommentViewCellId];

        
        [self addSubview:self.tableView];
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
    [self.tableView reloadData];
    BaseDataSource *dataSource = self.dataSource;
    if (dataSource.dataArray.count == 0) {
        
        [dataSource loadDataType:0 Success:^(id obj) {
            [_tableView reloadData];
            [self.tableView.header endRefreshing];
        } failure:^(NSString *errorMessage) {
            [self.tableView.header endRefreshing];
        }];
    }
}


- (void)layoutSubviews
{
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
