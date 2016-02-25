//
//  UUCommunityBlockViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityBlockViewController.h"
#import "UUCommunityPublicTopicViewController.h"
#import "UUCommunityTopicDetailViewController.h"
#import "UUCommunityHeaderTableViewCell.h"
#import "UUCommunityViewCell.h"
#import "UUCommunityHandler.h"
#import "UUCommunityColumnsModel.h"
#import "UUCommunityTopicListModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UUPersonalStockDetailViewController.h"
#import "UUStockIdxDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "UUTitleView.h"
#import "UULoginViewController.h"
@interface UUCommunityBlockViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UUCommunityTopicListModel *_topicListModel;
    
    NSInteger _status;  //    *  status	Int	Y	0最新发布 1最新回复 2精华

    NSInteger _pageNo;
    NSInteger _pageSize;
    
    UIButton *_publicTopicButton;
    
}
@end

@implementation UUCommunityBlockViewController

- (instancetype)init
{
    if (self = [super init]) {
        _status = 0;
        _pageNo = 1;
        _pageSize = 10;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self titleView];
    self.view.backgroundColor = k_BG_COLOR;
    
    [self configSubViews];
    
    [self addPublicTopicButton];

    
    [self loadData];
    

}

- (void)loadData
{
    [self showLoading];
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:_columnModel.relevanceId status:_status type:1 pageNo:_pageNo pageSize:_pageSize success:^(UUCommunityTopicListModel *topicListModel) {
        
        _topicListModel = topicListModel;
        [_tableView reloadData];
        [self stopLoading];
    } failure:^(NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
    }];
}


- (void)addPublicTopicButton
{
    
    UIButton *publicTopicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"Community_fatie"];
    publicTopicButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - image.size.width * 1.5f, CGRectGetHeight(self.view.bounds) - image.size.height * 1.5f, image.size.width, image.size.height);
    publicTopicButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [publicTopicButton setImage:image forState:UIControlStateNormal];
    [publicTopicButton addTarget:self action:@selector(publicTopicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publicTopicButton];
    _publicTopicButton = publicTopicButton;
}

#pragma mark - 发表话题
- (void)publicTopicButtonAction:(UIButton *)button
{
    
    if (![UUserDataManager userIsOnLine]) {
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:(self.navigationController.viewControllers.count - 1) success:^{
            [self pushToPublicTopic];
        } failed:^{
            
        }];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    [self pushToPublicTopic];
}

- (void)pushToPublicTopic
{
    
    UUCommunityPublicTopicViewController *publicTopicVC = [[UUCommunityPublicTopicViewController alloc] init];
    publicTopicVC.relevanceId = _columnModel.relevanceId;
    [publicTopicVC success:^(UUCommunityTopicNormalListModel *topicNormalModel) {
        
        [self loadData];
        
        /*
         NSMutableArray *topicNormalModelArray = [[NSMutableArray alloc] initWithArray:_topicListModel.list];
         [topicNormalModelArray insertObject:topicNormalModel atIndex:0];
         
         _topicListModel.list = [topicNormalModelArray copy];
         
         [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
         */
    }];
    [self.navigationController pushViewController:publicTopicVC animated:YES];
}

- (UIView *)titleView
{
    UUTitleView *titleView = [[UUTitleView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 30.0f) selectedIndex:^(NSInteger index) {
        //切换
        _status = index;
        [self loadData];
    }];
    titleView.titleArray = @[@"全部",@"新回复",@"看精华"];
    
    return titleView;
}

- (void)configSubViews
{
    CGRect frame = CGRectMake(0,0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds));
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    _tableView.tableHeaderView = [self tableHeaderView];
    [self.view addSubview:_tableView];
    //
    
    [self addRefreshView];
}

- (UIView *)tableHeaderView
{
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150.0f)];
    headerView.image = [UIImage imageNamed:@"gushidajiatan_header"];
    headerView.contentMode = UIViewContentModeScaleAspectFit;
    return headerView;
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
    }
    
    return   _topicListModel.list.count; //10;//_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"UUCommunityHeaderTableViewCell";
        
        UUCommunityHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[UUCommunityHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
        }
        cell.topListModel = [_topicListModel.topList objectAtIndex:indexPath.row];
        return cell;
    }
    
    static NSString *cellId = @"UUBlockCommunityViewCell";
    
    UUCommunityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUCommunityViewCell class]) owner:self options:nil] lastObject];
        cell.target = self;

        cell.stockDetailAction = @selector(stockDetailAction:);
    }
    cell.normalListModel = [_topicListModel.list objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  UUCommunityHeaderTableViewCellHeight;
    }
    
    return UUCommunityViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUCommunityTopicDetailViewController *topicDetailVC = [[UUCommunityTopicDetailViewController alloc] init];
    topicDetailVC.topicModel = [_topicListModel.list objectAtIndex:indexPath.row];
    
    [topicDetailVC deleteReply:^{
        [_tableView reloadData];
    }];
    [topicDetailVC replySuccess:^{
        [_tableView reloadData];
    }];
    [topicDetailVC praiseTopic:^{
        [_tableView reloadData];
    }];
    [topicDetailVC deleteTopic:^{
        
    }];
    
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
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPanGestureRecognizer *ges = scrollView.panGestureRecognizer;
    
    CGPoint point = [ges translationInView:scrollView];

    
    [UIView animateWithDuration:0.2 animations:^{

        _publicTopicButton.alpha = point.y > 0 ? YES : NO;

    }];
}

#pragma mark - 评论
- (void)commentAction:(UUCommunityViewCell *)cell
{
    UUCommunityTopicDetailViewController *topicDetailVC = [[UUCommunityTopicDetailViewController alloc] init];
    topicDetailVC.topicModel = cell.normalListModel;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
    [topicDetailVC setEditing:YES];

}

#pragma mark - 点赞
- (void)praiseAction:(UUCommunityViewCell *)cell
{
    [[UUCommunityHandler sharedCommunityHandler] praiseTopicWithSubId:cell.normalListModel.id isSupport:!cell.normalListModel.selfIsSupport  success:^(id obj) {
        
    } failure:^(NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
    }];
}


#pragma mark - 股票详情
- (void)stockDetailAction:(NSString *)stockCode
{
    NSRange rangeL = [stockCode rangeOfString:@"("];
    NSRange rangeR = [stockCode rangeOfString:@")"];
#warning ---
    if (rangeL.location != NSNotFound && rangeR.location != NSNotFound) {
        NSString *code = [stockCode substringWithRange:NSMakeRange(rangeL.location + 1, rangeR.location - rangeL.location - 1)];
//        if ([code hasSuffix:@".INX"])
//        {
//            //指数
//            UUStockIdxDetailViewController *vc = [[UUStockIdxDetailViewController alloc] init];
//            vc.code = code;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
//        {
//            //个股
//            UUPersonalStockDetailViewController *stockDetailVC = [[UUPersonalStockDetailViewController alloc] init];
//            stockDetailVC.code = code;
//            [self.navigationController pushViewController:stockDetailVC animated:YES];
//        }
    }
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
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:_columnModel.relevanceId status:_status type:1 pageNo:_pageNo pageSize:_pageSize success:^(UUCommunityTopicListModel *topicListModel) {
        
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
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:_columnModel.relevanceId status:_status type:1 pageNo:_pageNo pageSize:_pageSize success:^(UUCommunityTopicListModel *topicListModel) {
        
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
