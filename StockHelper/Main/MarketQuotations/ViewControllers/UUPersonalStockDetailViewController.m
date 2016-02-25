//
//  UUPersonalStockDetailViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/17.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalStockDetailViewController.h"
#import "UUStockDetailPortraitView.h"
#import "UUStockDetailLandspaceView.h"
#import "UUStockDetailTitleView.h"
#import "UUOptionView.h"
#import "UUStockDetailF10Info.h"
#import "UUStockDetailNews.h"
#import "UUStockDetailComment.h"
#import "UUStockDetailShortBrief.h"
#import "UUStockDetailView.h"
#import "UUMarketQuotationView.h"
#import "UUToolBar.h"
#import "UUTabbar.h"
#import "UUMarketQuationHandler.h"
#import "UUStockDetailModel.h"
#import "UUStockDetailPriceView.h"
#import "UUStockDetailCurrentPriceView.h"
#import "UUStockTimeEntity.h"
#import <Masonry/Masonry.h>
#import "UUVirtualTansactionBuyingViewController.h"
#import "UUStockModel.h"
#import "NSTimer+Addition.h"
#import "UUTopicContainerView.h"
#import "UUCommunityHandler.h"
#import <MJRefresh/MJRefresh.h>
#import "UUCommunityTopicDetailViewController.h"
#import "UUStockFinancialModel.h"
#import "UUStockDetailViewController.h"
#import "UUStockDetailFinance.h"
#import "UUStockDetailStockHolder.h"
@interface UUPersonalStockDetailViewController ()<UUOptionViewDelegate,UITableViewDelegate,UUToolBarDelegate,UUStockDetailCommentViewCellDelegate>
{
//    UUStockDetailTitleView *_titleView;
    
    UUToolBar *_toolBar;
    
    NSInteger _selectedLineOptionIndex;
//    
//    
//    NSTimer *_stockDetailTimer;
//    NSTimer *_lineTimer;
    
    UUOptionView *_optionView;
    
    NSMutableArray *_dataSourceArray;
    NSMutableArray *_delegateArray;
    
    UUStockDetailPortraitView *_stockDetailPortaitView;
    
    UIButton *_favButton;
    

}

@property (nonatomic,strong) UUStockDetailView *detailView;
@property (nonatomic,strong) UUStockDetailLandspaceView *stockDetailLandspaceView;

@property (nonatomic,strong) id financailObsever;

@end

@implementation UUPersonalStockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubViews];

}

- (void)configSubViews
{
//    //竖屏
    _stockDetailPortaitView = [[UUStockDetailPortraitView alloc] initWithFrame:self.view.bounds];
    _stockDetailPortaitView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.view = _stockDetailPortaitView;
//
    _detailView = [[UUStockDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) -UUToolBarHeight)];
    _detailView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _detailView.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//
    _headerView = [self tableHeaderView];
    _detailView.tableView.tableHeaderView = _headerView;
    
    _detailView.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:[UUStockDetailViewController g_sharedStockDetailViewController] refreshingAction:@selector(loadData)];

    [_stockDetailPortaitView addSubview:_detailView];

//    //工具条
    NSArray *orgItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UUStockDetailIToolBartems.plist" ofType:nil]];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0 ; i < orgItems.count ;i++) {
        NSDictionary *dic = [orgItems objectAtIndex:i];
        NSString *title = [dic objectForKey:@"title"];
        UIImage *image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        UIImage *selectedImage = [UIImage imageNamed:[dic objectForKey:@"selectedImage"]];
        UUTabbarItem *item = [[UUTabbarItem alloc] initWithTitle:title image:image selectedImage:selectedImage tag:i];
        [items addObject:item];
    }
    
    UUToolBar *toolBar = [[UUToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - UUToolBarHeight, CGRectGetWidth(self.view.bounds), UUToolBarHeight) items:items delegate:self];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolBar = toolBar;
    [_stockDetailPortaitView addSubview:toolBar];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataSuccess) name:stockDetailDidLoadSuccessNotificaiton object:nil];
    
    
    _dataSourceArray = [NSMutableArray array];
    _delegateArray = [NSMutableArray array];
    UUStockDetailShortBriefDataSource *dataSource1 = [[UUStockDetailShortBriefDataSource alloc] initWithStockCode:_stockModel.code];
    UUStockDetailShortBrief *delegate1 = [[UUStockDetailShortBrief alloc] init];
    [_delegateArray addObject:delegate1];
    [_dataSourceArray addObject:dataSource1];
    UUStockDetailFinanceDataSource *dataSource2 = [[UUStockDetailFinanceDataSource alloc] initWithStockCode:_stockModel.code];
    UUStockDetailFinance *delegate2 = [[UUStockDetailFinance alloc] init];
    [_delegateArray addObject:delegate2];
    [_dataSourceArray addObject:dataSource2];
    UUStockDetailStockHolderDataSource *dataSource3 = [[UUStockDetailStockHolderDataSource alloc] initWithStockCode:_stockModel.code];
    UUStockDetailStockHolder *delegate3 = [[UUStockDetailStockHolder alloc] init];
    [_delegateArray addObject:delegate3];
    [_dataSourceArray addObject:dataSource3];
    [self optionView:_optionView didSeletedIndex:0];
}

- (UUPersonalStockHeaderView *)tableHeaderView
{
    __weak __typeof(self) weakSelf = self;
    UUPersonalStockHeaderView *headerView = [[UUPersonalStockHeaderView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH,  UUPersonalStockDetailHeaderViewHeight) operation:^(NSInteger index) {
        [weakSelf showkLineViewWithIndex:index];
    }];
    headerView.backgroundColor = k_BG_COLOR;
    UUOptionView *optionView = [[UUOptionView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN,UUPersonalStockDetailHeaderViewHeight - UUOptionViewHeight - k_TOP_MARGIN, PHONE_WIDTH - 2 * k_LEFT_MARGIN, UUOptionViewHeight) titles:@[@"简况",@"财务",@"股东"] delegate:self];
    _optionView = optionView;
    [headerView addSubview:_optionView];
    return headerView;
}

- (void)setIsFav:(BOOL)isFav
{
    _isFav = isFav;
    [_toolBar setSelected:isFav Index:3];
}

#pragma  -
- (void)loadDataSuccess
{
    [_detailView.tableView.header endRefreshing];
}

#pragma mark - 切换K线图
- (void)showkLineViewWithIndex:(NSInteger)index
{
    _selectedLineOptionIndex = index;
    [UUStockDetailViewController g_sharedStockDetailViewController].lineIndex = index;
    if (index == 1) {
        [[UUStockDetailViewController g_sharedStockDetailViewController] loadSharePrice];
    } else if (index > 1) {
        [[UUStockDetailViewController g_sharedStockDetailViewController] loadKLineWithIndex:index - 1];
    }
}

#pragma mark - 切换F10信息
- (void)optionView:(UUOptionView *)optionView didSeletedIndex:(NSInteger)index
{
    _detailView.dataSource = [_dataSourceArray objectAtIndex:index];
    _detailView.delegate = [_delegateArray objectAtIndex:index];
    [_detailView reload];
}

#pragma mark - UUToolBarDelegate
- (void)toolBar:(UUToolBar *)toolBar didSeletedIndex:(NSInteger)index
{
    if (index == 0 || index == 1) {
        //买入
        //买入或卖出
        [[UUStockDetailViewController g_sharedStockDetailViewController] stockBuyingOrSell:index];
    }else if (index == 2){
        
        //添加自选
        if (!_isFav) {
            
            NSString *code = _stockModel.code;
            //加自选
            [[UUMarketQuationHandler sharedMarkeQuationHandler] addFavourisStockWithCode:code pos:0 success:^(id obj) {
                
                [SVProgressHUD showSuccessWithStatus:@"添加成功" maskType:SVProgressHUDMaskTypeBlack];
                
                self.isFav = YES;
                
            } failue:^(NSString *errorMessage) {
                [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
            }];
        }else{
            
            [[UUMarketQuationHandler sharedMarkeQuationHandler] deleteFavourisStockWithListID:@"" success:^(id obj) {
                
                self.isFav = NO;
                [SVProgressHUD showSuccessWithStatus:@"删除自选成功" maskType:SVProgressHUDMaskTypeBlack];
                
            } failue:^(NSString *errorMessage) {
                
                [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
                
            }];
        }
    }else if (index == 3){
        
        //讨论
    }
}


@end
