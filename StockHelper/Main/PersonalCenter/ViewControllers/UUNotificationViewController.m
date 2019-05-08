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
    
    
    [self.view addSubview:[self m_emptyView]];
}


//自选为空
- (UIView *)m_emptyView
{
    UIView *emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
    emptyView.backgroundColor = k_BG_COLOR;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_none"]];
    imageView.center = CGPointMake(CGRectGetWidth(emptyView.frame) * 0.5, CGRectGetHeight(emptyView.frame) * 0.5 - kNavigationBarHeight - 20);
    imageView.userInteractionEnabled = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [emptyView addSubview:imageView];
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, CGRectGetWidth(emptyView.frame), 20)];
    label.text = @"暂无数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [emptyView addSubview:label];
    return emptyView;
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
