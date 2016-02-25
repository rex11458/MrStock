//
//  UUStockTopicViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/11/21.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockTopicViewController.h"
#import "UUTopicContainerView.h"
#import "UUCommunityViewCell.h"
#import "UUStockDetailTitleView.h"
#import "UUStockModel.h"
#import "UUCommunityHandler.h"
#import "UUCommunityTopicListModel.h"
#import "UUCommunityTopicDetailViewController.h"
@interface UUStockTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UUTopicContainerViewDelegate>
{
    NSInteger _pageNo;
    NSInteger _pageCount;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *dataArray;

@property (nonatomic,strong) UUTopicContainerView *containerView;

@property (nonatomic,strong) UIView *noDataBGView;//没有数据时显示的图片

@end

@implementation UUStockTopicViewController

- (UUStockDetailTitleView *)createTitleView
{
    UUStockDetailTitleView *titleView = [[UUStockDetailTitleView alloc] initWithFrame:CGRectMake(PHONE_WIDTH* 0.5 - 80, 0, 160.0f, 44.0f)];
    titleView.title = [NSString stringWithFormat:@"%@(%@)",_stockModel.name,_stockModel.code];
    
    return titleView;
}

- (instancetype)init
{
    if (self = [super init]) {
        _pageNo = 1;
        _pageCount = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [self createTitleView];
    
    [self configSubViews];
    
    [self loadData];
}

- (void)configSubViews
{
    CGRect frame = CGRectMake(0,0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds) - kUUTopicContainerViewHeight);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = k_BG_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self.view addSubview:_tableView];
    
    //输入框
    _containerView = [[UUTopicContainerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - kUUTopicContainerViewHeight, PHONE_WIDTH, kUUTopicContainerViewHeight)];
    _containerView.delegate = self;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_containerView];
    
    //空数据时显示的图片
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH,CGRectGetHeight(_tableView.frame) - kUUTopicContainerViewHeight)];
    [_tableView addSubview:bgView];
    _noDataBGView = bgView;
    [self showNodataWithTitle:k_remainder(@"no_data_community_topic_reply") inView:_noDataBGView];
    
    [self addRefreshView];
}

- (void)loadData
{
    NSString *relenvanceId = _stockModel.code;
    if (k_IS_INDEX(_stockModel.market)) {
        relenvanceId = [relenvanceId stringByAppendingString:@".INX"];
    }
//    [self showLoading];
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:relenvanceId status:0 type:1 pageNo:_pageNo pageSize:_pageCount success:^(UUCommunityTopicListModel *topicListModel) {
        _dataArray = topicListModel.list;
        [_tableView reloadData];
        
        _noDataBGView.hidden = _dataArray.count;
        [self stopLoading];
    } failure:^(NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
    }];
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
        cell.userHomeAction = @selector(userHomeAction:);
    }
    cell.normalListModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUCommunityViewCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUCommunityTopicDetailViewController *vc = [[UUCommunityTopicDetailViewController alloc] init];
    vc.topicModel = [_dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UUTopicContainerViewDelegate
#pragma mark - UUTopicContainerViewDelegate
- (void)containerView:(UUTopicContainerView *)containerView sendMessage:(NSString *)message
{
    if (message == nil || message.length == 0) {
        return;
    }
    [self.view endEditing:YES];
    NSString *relenvanceId = _stockModel.code;
    if (k_IS_INDEX(_stockModel.market)) {
        relenvanceId = [relenvanceId stringByAppendingString:@".INX"];
    }

    [[UUCommunityHandler sharedCommunityHandler] publicTopicWithRelevanceId:relenvanceId content:message images:@"" success:^(id obj) {
        [SVProgressHUD showSuccessWithStatus:@"发表成功" maskType:SVProgressHUDMaskTypeBlack];
        [self loadData];

    } failure:^(NSString *errorMessage) {
        
    }];
}


#pragma mark - 下拉和上拉刷新
- (void)addRefreshView
{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    _tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


- (void)refreshAction
{
    _pageNo = 1;
    NSString *relenvanceId = _stockModel.code;
    if (k_IS_INDEX(_stockModel.market)) {
        relenvanceId = [relenvanceId stringByAppendingString:@".INX"];
    }
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:relenvanceId status:0 type:1 pageNo:_pageNo pageSize:_pageCount success:^(UUCommunityTopicListModel *topicListModel) {
        _noDataBGView.hidden = _dataArray.count;
        _dataArray = topicListModel.list;
        [_tableView.header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSString *errorMessage) {
        [_tableView.header endRefreshing];
    }];}

- (void)loadMore
{
    NSString *relenvanceId = _stockModel.code;
    if (k_IS_INDEX(_stockModel.market)) {
        relenvanceId = [relenvanceId stringByAppendingString:@".INX"];
    }
    _pageNo++;
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:relenvanceId status:0 type:1 pageNo:_pageNo pageSize:_pageCount success:^(UUCommunityTopicListModel *topicListModel) {
        
        _dataArray = [_dataArray arrayByAddingObjectsFromArray:topicListModel.topList];
        [_tableView.footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSString *errorMessage) {
        [_tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
    }];
}


@end
