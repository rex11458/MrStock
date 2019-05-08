//
//  UUCommunityViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityViewController.h"
#import "UUCommunityTopicDetailViewController.h"
#import "UUCommunityBlockViewController.h"
#import "UUCommunityViewCell.h"
#import "UUTabbar.h"
#import "UUCommunityHeaderTableViewCell.h"
#import "UUPersonalStockDetailViewController.h"
#import "UUCommunityTopicListModel.h"
#import "UUCommunityColumnsModel.h"
#import "UUCommunityHandler.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UUPersonalHomeViewController.h"
@interface UUCommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UUCommunityHeaderViewDelegate>
{
    UITableView *_tableView;
    UUCommunityHeaderView *_headerView;
    
    UUCommunityTopicListModel  *_topicListModel;
    NSArray *_columnsArray;

    
    NSInteger _pageNo;
    NSInteger _pageCount;
}
@end

@implementation UUCommunityViewController

- (id)init
{
    if (self = [super init]) {
        _pageNo = 1;
        _pageCount = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"社区";
    self.view.backgroundColor = k_BG_COLOR;
    
    [self configSubViews];
    [self loadData];
}

//获取数据
- (void)loadData
{
    [self showLoading];
    //获取栏目列表
    [[UUCommunityHandler sharedCommunityHandler] getCommunityColumnsWithType:1 success:^(UUCommunityColumnsListModel * columnsListModel) {

        _columnsArray = [columnsListModel.columns copy];
        _tableView.tableHeaderView = [self tableHeaderView];
    
        [self stopLoading];
    } failure:^(NSString *errorMessage) {
//        self stopLoading
    }];
    
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:@"r1" status:0 type:1 pageNo:_pageNo pageSize:_pageCount success:^(UUCommunityTopicListModel *topicListModel) {
        _topicListModel = topicListModel;
        [_tableView reloadData];
    } failure:^(NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
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

    //添加刷新控件
    [self addRefreshView];
}

- (UUCommunityHeaderView *)tableHeaderView
{
    UUCommunityHeaderView *headerView = [[UUCommunityHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUCommunityHeaderViewHeight)];
    headerView.delegate = self;
    headerView.columnArray = _columnsArray;
    CGRect frame = headerView.frame;
    frame.size.height = [headerView height];
    headerView.frame = frame;
    return headerView;
}



#pragma mark - UUCommunityHeaderViewDelegate
- (void)headerView:(UUCommunityHeaderView *)headerView didSelectedIndex:(NSInteger)index
{
    UUCommunityBlockViewController *communityBlockVC = [[UUCommunityBlockViewController alloc] init];
    communityBlockVC.columnModel = [headerView.columnArray objectAtIndex:index];
    [self.navigationController pushViewController:communityBlockVC animated:YES];
}

#pragma mark - UITableView delegatge、datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _topicListModel.topList.count;
    }else if (section == 1){
        return _topicListModel.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        static NSString *cellId = @"UUCommunityHeaderTableViewCell";
        
        UUCommunityHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[UUCommunityHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
//        cell.topListModel = [_topicListModel.topList objectAtIndex:indexPath.row];
        return cell;
    }else
    {
        static NSString *cellId = @"UUCommunityViewCellId";
        
        UUCommunityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUCommunityViewCell class]) owner:self options:nil] lastObject];
            cell.target = self;
            cell.userHomeAction = @selector(userHomeAction:);
        }
        cell.normalListModel = [_topicListModel.list objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return  UUCommunityHeaderTableViewCellHeight;
    }
    
    return UUCommunityViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushViewControllerWithIndexPath:indexPath editing:NO];

}

#pragma mark -
- (void)pushViewControllerWithIndexPath:(NSIndexPath *)indexPath editing:(BOOL)editing
{
    UUCommunityTopicDetailViewController *topicDetailVC = [[UUCommunityTopicDetailViewController alloc] init];
    //删除话题
    [topicDetailVC deleteTopic:^() {
        if (indexPath.section == 0)
        {
            
        }
        else if (indexPath.section == 1)
        {
            NSMutableArray *dataArray = [_topicListModel.list mutableCopy];
            [dataArray removeObjectAtIndex:indexPath.row];
            _topicListModel.list = [dataArray copy];
            [_tableView reloadData];
        }
    }];
    
    [topicDetailVC praiseTopic:^{
        [_tableView reloadData];
    }];
    [topicDetailVC deleteReply:^{
        [_tableView reloadData];
    }];
    [topicDetailVC replySuccess:^{
        [_tableView reloadData];
    }];
    
    if (indexPath.section == 1) {
        topicDetailVC.topicModel = [_topicListModel.list objectAtIndex:indexPath.row];
    }
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}



#pragma mark - 用户详情
- (void)userHomeAction:(UUCommunityViewCell *)cell
{
    UUPersonalHomeViewController *homeVC = [[UUPersonalHomeViewController alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];
}

#pragma mark - 下拉和上拉刷新
 - (void)addRefreshView
{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)refreshAction
{
    _pageNo = 1;
    
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:@"r1" status:0 type:1 pageNo:_pageNo pageSize:_pageCount success:^(UUCommunityTopicListModel *topicListModel) {
        
        _topicListModel = topicListModel;
        [_tableView.header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSString *errorMessage) {
        [_tableView.header endRefreshing];
    }];}

- (void)loadMore
{
    _pageNo++;
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:@"r1" status:0 type:1 pageNo:_pageNo pageSize:_pageCount success:^(UUCommunityTopicListModel *topicListModel) {
        
        _topicListModel.list = (NSArray<UUCommunityTopicNormalListModel> *)[_topicListModel.list arrayByAddingObjectsFromArray:topicListModel.list];
        _topicListModel.topList = (NSArray<UUCommunityTopicTopListModel> *)[_topicListModel.topList arrayByAddingObjectsFromArray:topicListModel.topList];
        [_tableView.footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSString *errorMessage) {
        [_tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
    }];
}

@end


@interface UUCommunityHeaderView ()

@property (nonatomic,copy) NSArray *buttonArray;

@end

@implementation UUCommunityHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setColumnArray:(NSArray *)columnArray
{
    if (columnArray == nil || _columnArray == columnArray) {
        return;
    }
    _columnArray = columnArray;
    [self configSubViews];
}

- (void)configSubViews
{
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    NSInteger horButtonCount = 3;
    CGFloat buttonWidth = CGRectGetWidth(self.bounds) / (float)horButtonCount;
    for (NSInteger i = 0; i < _columnArray.count; i++) {
        UUCommunityColumnsModel *columnsModel = [_columnArray objectAtIndex:i];
        UUButton *button = [UUButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i%3 * buttonWidth,i/horButtonCount * buttonWidth, buttonWidth, buttonWidth);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitle:columnsModel.name forState:UIControlStateNormal];
        
        [button sd_setImageWithURL:[NSURL URLWithString:[k_BASE_URL stringByAppendingString:columnsModel.image]] forState:UIControlStateNormal];
        
//        [button setImage:[UIImage imageNamed:@"新手学堂"] forState:UIControlStateNormal];
        [button setTitleColor:k_BIG_TEXT_COLOR forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttonArray addObject:button];
    }
    self.buttonArray = buttonArray;
}

- (void)buttonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [_delegate headerView:self didSelectedIndex:button.tag];
    }
}

- (CGFloat)height
{
    UIButton *button = [_buttonArray lastObject];
    
    return CGRectGetMaxY(button.frame);
}

- (void)drawRect:(CGRect)rect
{
    UIButton *button = [_buttonArray lastObject];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
    CGContextMoveToPoint(context, CGRectGetWidth(button.frame),0);
    CGContextAddLineToPoint(context, CGRectGetWidth(button.frame), CGRectGetMaxY(button.frame));
    CGContextMoveToPoint(context,CGRectGetWidth(button.frame) * 2,0);
    CGContextAddLineToPoint(context, CGRectGetWidth(button.frame) * 2, CGRectGetMaxY(button.frame));
    
    CGFloat count = CGRectGetMaxY(button.frame) / CGRectGetHeight(button.frame);
    
    for (NSInteger i = 0; i <= count; i++) {
        CGContextMoveToPoint(context,k_LEFT_MARGIN,i * CGRectGetWidth(button.frame));
        CGContextAddLineToPoint(context, CGRectGetWidth(self.frame) - k_LEFT_MARGIN,i * CGRectGetWidth(button.frame));
    }
    CGContextStrokePath(context);
}


@end
