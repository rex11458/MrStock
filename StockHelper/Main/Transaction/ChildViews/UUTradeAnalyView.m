//
//  UUTradeAnalyView.m
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTradeAnalyView.h"
#import "BaseDataSource.h"
@implementation UUTradeAnalyView

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
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)reload
{
    BaseDataSource *dataSource = self.dataSource;
    if (dataSource == nil) {
        return;
    }
    [dataSource loadDataType:0 Success:^(NSArray *dataArray) {
       
        [_tableView reloadData];
    } failure:^(NSString *errorMessage) {
        
    }];
    
}

- (void)layoutSubviews
{
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}



@end
