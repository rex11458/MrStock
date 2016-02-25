//
//  UUFavTopicViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavTopicViewController.h"
#import "UUCommunityViewCell.h"
#import "UUCommunityHandler.h"
#import "UUCommunityTopicDetailViewController.h"
#import "UUCommunityTopicListModel.h"
#import "UUPersonalStockDetailViewController.h"
@interface UUFavTopicViewController ()
{
    NSInteger _pageIndex;
    NSInteger _pageCount;
    
}
@end

@implementation UUFavTopicViewController

- (instancetype)init
{
    if (self = [super init]) {
        _pageIndex = 1;
        _pageCount = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configSubViews];

    [self loadData];
}

- (void)loadData
{
    [self showLoading];
    [[UUCommunityHandler sharedCommunityHandler] getColletionListWithType:1 start:_pageIndex count:_pageCount success:^(NSArray *models) {
        _dataArray = models;
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
    [self.view addSubview:_tableView];
    
 
    [self addRefreshView];
}

#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUCommunityViewCellId";

    UUCommunityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUCommunityViewCell class]) owner:self options:nil] lastObject];
        cell.target = self;

        cell.stockDetailAction = @selector(stockDetailAction:);
    }
    cell.normalListModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUCommunityViewCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewControllerWithIndexPath:indexPath editing:NO];
    
}

#pragma mark - 评论
- (void)commentAction:(UUCommunityViewCell *)cell
{
    [self pushViewControllerWithIndexPath:[_tableView indexPathForCell:cell] editing:YES];
}

- (void)pushViewControllerWithIndexPath:(NSIndexPath *)indexPath editing:(BOOL)editing
{
    UUCommunityTopicDetailViewController *topicDetailVC = [[UUCommunityTopicDetailViewController alloc] init];
    topicDetailVC.editing = editing;
    //删除话题
    [topicDetailVC deleteTopic:^() {
        if (indexPath.section == 0)
        {
            
        }
        else if (indexPath.section == 1)
        {
            NSMutableArray *dataArray = [_dataArray mutableCopy];
            [dataArray removeObjectAtIndex:indexPath.row];
            _dataArray = [dataArray copy];
            [_tableView reloadData];
        }
    }];
    
    [topicDetailVC praiseTopic:^{
        [_tableView reloadData];
    }];
    
        topicDetailVC.topicModel = [_dataArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

#pragma mark - 点赞
- (void)praiseAction:(UUCommunityViewCell *)cell
{
    cell.praiseButton.userInteractionEnabled = NO;
    [[UUCommunityHandler sharedCommunityHandler] praiseTopicWithSubId:cell.normalListModel.id isSupport:!cell.normalListModel.selfIsSupport  success:^(id obj) {
        
        UUCommunityTopicNormalListModel *topicModel = cell.normalListModel;
        topicModel.selfIsSupport = !topicModel.selfIsSupport;
        
        topicModel.supportAmount += topicModel.selfIsSupport ? 1 : -1;
        
        [_tableView reloadData];
        
        cell.praiseButton.userInteractionEnabled = YES;
        
    } failure:^(NSString *errorMessage) {
        //        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        cell.praiseButton.userInteractionEnabled = YES;
    }];
}


#pragma mark - 下拉和上拉刷新
- (void)addRefreshView
{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)refreshAction
{
    _pageIndex = 1;
    
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getColletionListWithType:1 start:_pageIndex count:_pageCount success:^(NSArray *models) {
        _dataArray = models;
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [self stopLoading];
    } failure:^(NSString *errorMessage) {
        [self stopLoading];
    }];
}
- (void)loadMore
{
    _pageIndex = (++_pageIndex) * _pageCount;
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getColletionListWithType:1 start:_pageIndex count:_pageCount success:^(NSArray *models) {
        _dataArray = [_dataArray arrayByAddingObjectsFromArray:models];
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
        [self stopLoading];
    } failure:^(NSString *errorMessage) {
        [self stopLoading];
    }];
}

#pragma mark - 股票详情
- (void)stockDetailAction:(NSString *)stockCode
{
#warning --
    /*
    UUPersonalStockDetailViewController *stockDetailVC = [[UUPersonalStockDetailViewController alloc] init];
    stockDetailVC.code = stockCode;
    [self.navigationController pushViewController:stockDetailVC animated:YES];
     */
}

@end
