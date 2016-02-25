//
//  UUNotificationViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUNotificationViewController.h"
#import "UUStockDetailCommentViewCell.h"
#import "UUMeHandler.h"
#import "UUSystemMessageViewCell.h"
@interface UUNotificationViewController ()

@end

@implementation UUNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统通知";
    
    [self configSubViews];
    
    [self loadData];
}

- (void)loadData
{
    [self showLoading];
    [[UUMeHandler sharedMeHandler] getSystemMessageSuccess:^(NSArray *dataArray) {
        
        _dataArray = [dataArray copy];
        [_tableView reloadData];
        [self stopLoading];
    } failure:^(NSString *errorMessage) {
        [self stopLoading];
    }];
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
    [_tableView registerNib:[UINib nibWithNibName:@"UUSystemMessageViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UUSystemMessageViewCellId"];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUSystemMessageViewCellId";
    
    UUSystemMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUStockDetailCommentViewCellHeight;
}


@end
