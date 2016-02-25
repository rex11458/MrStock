//
//  UUFavNewsViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavNewsViewController.h"
#import "UUStockDetailCommentViewCell.h"
@interface UUFavNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation UUFavNewsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
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
    [self.view addSubview:_tableView];
}

#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUStockDetailCommentViewCell";
    
    UUStockDetailCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUStockDetailCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUStockDetailCommentViewCellHeight;
}
@end
