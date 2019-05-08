//
//  UUAttentionViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUAttentionViewController.h"
#import "UUDiscoverViewCell.h"
#import "UUCommunityViewCell.h"
#import "UUMeHandler.h"
#import "UUAttentionTopicModel.h"
#import "UUAttentionTopicTradeModel.h"
#import "UUCommunityTopicDetailViewController.h"
@interface UUAttentionViewController ()
{
    NSInteger _pageNo;
    NSInteger _pageSize;
    
}
@end

@implementation UUAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNo = 1;
    _pageSize = 10;
    
    self.navigationItem.title = @"我的消息";

    [self configSubViews];

    [self loadData];
 
}

- (void)loadData
{
    [self showLoading];
    [[UUMeHandler sharedMeHandler] getAttetionListWithPageNo:_pageNo pageSize:_pageSize success:^(NSArray *dataArray) {
       
        [self stopLoading];
        
        [self cancelRemaind];
        _dataArray = [dataArray copy];
        [_tableView reloadData];
        
    } failure:^(NSString *errorMessage) {
        [self stopLoading];

    }];
}

//消除红点
- (void)cancelRemaind
{
    [[UUMeHandler sharedMeHandler] cancelRemaindWithMessageType:1 success:^(id obj) {
        
    } failure:^(NSString *errorMessage) {
        
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
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    
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




- (void)refresh
{
    _pageNo = 1;
    [[UUMeHandler sharedMeHandler] getAttetionListWithPageNo:_pageNo pageSize:_pageSize success:^(NSArray *dataArray) {
        

        _dataArray = [dataArray copy];
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    } failure:^(NSString *errorMessage) {
        [_tableView.header endRefreshing];
        
    }];
}

- (void)loadMore
{
    _pageNo++;
    [[UUMeHandler sharedMeHandler] getAttetionListWithPageNo:_pageNo pageSize:_pageSize success:^(NSArray *dataArray) {
        
        if (dataArray.count == 0) {
            [SVProgressHUD showImage:nil status:@"没有更多数据了"];
        }
        _dataArray = [_dataArray arrayByAddingObjectsFromArray:dataArray];
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
    } failure:^(NSString *errorMessage) {
        [self stopLoading];
        [_tableView.footer endRefreshing];
    }];
}

#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL type = [[_dataArray objectAtIndex:indexPath.row] messageType];
    
    if (type) {
        static NSString *cellId = @"UUDiscoverViewCellId";
        
        UUDiscoverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUDiscoverViewCell class]) owner:self options:nil] firstObject];
        }
        cell.tradeChanceModel = [_dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        static NSString *cellId = @"UUCommunityViewCellId";
        
        UUCommunityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUCommunityViewCell class]) owner:self options:nil] lastObject];
            cell.target = self;
            cell.userHomeAction = @selector(userHomeAction:);
        }
        cell.normalListModel = [_dataArray objectAtIndex:indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL type = [[_dataArray objectAtIndex:indexPath.row] messageType];

    
    return type==0 ? UUCommunityViewCellHeight:UUDiscoverViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isMemberOfClass:[UUCommunityViewCell class]]) {
        
        UUCommunityViewCell *tempCell = (UUCommunityViewCell *)cell;
        
        UUCommunityTopicDetailViewController *vc = [[UUCommunityTopicDetailViewController alloc] init];
        vc.topicModel = tempCell.normalListModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
