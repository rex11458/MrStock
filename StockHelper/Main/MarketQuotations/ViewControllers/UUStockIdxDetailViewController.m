//
//  UUStockDetailViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockIdxDetailViewController.h"
#import "UUStockBlockCollectionViewCell.h"
#import "UUMarketQuationHandler.h"
#import "UUStockDetailPortraitView.h"
#import "UUIndexStockHeaderView.h"
#import "UUStockDetailViewController.h"
#import "UUOptionView.h"
#import "UUStockSortViewCell.h"
#import "UUToolBar.h"
#import "UUTabbar.h"
#import "UUCommunityHandler.h"
#import "UUCommunityTopicListModel.h"
@interface UUStockIdxDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UUToolBarDelegate>
{
    UIView *_sectionView;
    NSInteger _selectedLineOptionIndex;
    
    UUToolBar *_toolbar;
    
    UUMarketRankType _rankType;
    
}

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation UUStockIdxDetailViewController

- (void)loadView
{
    [super loadView];
    
    [self configSubViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDataWithIndex:0];
    
//    [self getDiscussCount];
}

- (void)configSubViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - UUToolBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;//[UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f];
    [_tableView registerNib:[UINib nibWithNibName:@"UUStockSortViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UUStockSortViewCellId"];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:[UUStockDetailViewController g_sharedStockDetailViewController] refreshingAction:@selector(loadData)];
    [self.view addSubview:_tableView];
    
    //头视图
    UUIndexStockHeaderView *headerView = [[UUIndexStockHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 160.0f + VIEW_HEIGHT + UUOptionViewHeight) operation:^(NSInteger index) {
        [self showkLineViewWithIndex:index];
    }];
    _headerView = headerView;
    _tableView.tableHeaderView = headerView;
    _headerView.marketQuotationView.type = 0; //竖屏
    
    _sectionView = [self sectionView];
    
    //    //工具条
//    NSArray *orgItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UUToolBarItems.plist" ofType:nil]];
    
//    NSMutableArray *items = [NSMutableArray array];
//    for (NSInteger i = 0 ; i < orgItems.count ;i++) {
    NSString *title = @"自选";
    UIImage *image = [UIImage imageNamed:@"Toolbar_zixuan"];
    UIImage *selectedImage = [UIImage imageNamed:@"Toolbar_zixuan_selected"];
    UUTabbarItem *item = [[UUTabbarItem alloc] initWithTitle:title image:image selectedImage:selectedImage tag:0];
    _toolbar = [[UUToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - UUToolBarHeight, CGRectGetWidth(self.view.bounds), UUToolBarHeight) items:@[item] delegate:self];
//    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

    [self.view addSubview:_toolbar];
    
    [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(UUToolBarHeight);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(_toolbar.mas_top);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataSuccess) name:stockDetailDidLoadSuccessNotificaiton object:nil];
}

- (UIView *)sectionView
{
    UIView *m_sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.bounds), UUOptionViewHeight)];
    UUOptionView *optionView = [[UUOptionView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, 0, CGRectGetWidth(_tableView.bounds) - 2 * k_LEFT_MARGIN, UUOptionViewHeight) titles:@[@"涨幅榜",@"跌幅榜",@"换手率榜"] delegate:self];
    [m_sectionView addSubview:optionView];
    return m_sectionView;
}

- (void)loadDataWithIndex:(NSInteger)index
{
    UUMarketRankType type = UUIncreaseRateType;
    if (index == 1) {
        type = UUDecreaseRateType;
    }else if (index == 2){
        type = UUExchangeRateType;
        
    }
    _rankType = type;
    __weak typeof(self) weakSelf = self;
    [[UUMarketQuationHandler sharedMarkeQuationHandler] getReportSortWithType:type marketType:_stockModel.market count:10 success:^(NSArray *dataArray) {
        weakSelf.dataArray = dataArray;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void)getDiscussCount
{
    NSString *relenvanceId = _stockModel.code;
    if (k_IS_INDEX(_stockModel.market)) {
        relenvanceId = [relenvanceId stringByAppendingString:@".INX"];
    }
    //获取话题列表
    [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:relenvanceId status:0 type:1 pageNo:1 pageSize:1 success:^(UUCommunityTopicListModel *topicListModel) {
        
//        NSString *title = [NSString stringWithFormat:@"%@条讨论",topicListModel.todayAmount];
        
//        [_toolbar setTitle:title index:0];
        
    } failure:^(NSString *errorMessage) {
        
    }];
}

#pragma  - 
- (void)loadDataSuccess
{
    [_tableView.header endRefreshing];
}

#pragma mark - 切换K线图
- (void)showkLineViewWithIndex:(NSInteger)index
{
    _selectedLineOptionIndex = index;
    [[UUStockDetailViewController g_sharedStockDetailViewController] loadKLineWithIndex:index];
    [UUStockDetailViewController g_sharedStockDetailViewController].lineIndex = index;
}

#pragma mark - UUOptionViewDelegate
- (void)optionView:(UUOptionView *)optionView didSeletedIndex:(NSInteger)index
{
    [self loadDataWithIndex:index];
}


- (void)setIsFav:(BOOL)isFav
{
    _isFav = isFav;
    [_toolbar setSelected:isFav Index:1];
}

//
#pragma mark - UUToolBarDelegate
- (void)toolBar:(UUToolBar *)toolBar didSeletedIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    
    if (!_isFav) {
        
        NSString *code = _stockModel.code;
        code = [code stringByAppendingString:@".INX"];
        //加自选
        [[UUMarketQuationHandler sharedMarkeQuationHandler] addFavourisStockWithCode:code pos:0 success:^(id obj) {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功" maskType:SVProgressHUDMaskTypeBlack];
            
            weakSelf.isFav = YES;
            
        } failue:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }else{
        
        [[UUMarketQuationHandler sharedMarkeQuationHandler] deleteFavourisStockWithListID:@"" success:^(id obj) {
            
            weakSelf.isFav = NO;
            [SVProgressHUD showSuccessWithStatus:@"删除自选成功" maskType:SVProgressHUDMaskTypeBlack];
            
        } failue:^(NSString *errorMessage) {
            
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
            
        }];
    }
    
    return;
    

}

//
#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   UUStockSortViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUStockSortViewCellId"];
    cell.type = _rankType;
    cell.stockModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUStockSortViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UUOptionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUStockModel *stockModel = [_dataArray objectAtIndex:indexPath.row];
    UUStockDetailViewController *vc = [[UUStockDetailViewController alloc] initWithStockModel:stockModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:stockDetailDidLoadSuccessNotificaiton object:nil];
}

@end
