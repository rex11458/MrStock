//
//  UUStockListViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/5/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockListViewController.h"
#import "UUStockSearchViewController.h"
#import "UUStockBlockCollectionViewCell.h"
#import "UUDailyLimitViewController.h"
#import "UUPersonalStockDetailViewController.h"
#import "UUFavourisManagerViewController.h"
#import "UUStockIdxDetailViewController.h"
#import "UUDatabaseManager.h"
#import "UUStockKeyboard.h"
#import "UUStockModel.h"
#import "UUExponentView.h"
#import "UUMarketQuationHandler.h"
#import "UUReportSortStockModel.h"
#import "UUFavourisStockModel.h"
#import "UUStockDetailViewController.h"
#define fontSize  15.0f
#define moreFontSize 12.0f

#define UUStockBlockHeaderViewHeight (SQUARE_HEIGHT + k_TOP_MARGIN)

static UUStockListViewController *g_vc = nil;

@implementation UUStockBlockHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];//[UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f];
  
        [self configSubViews];
    }
    
    return self;
}

- (void)configSubViews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k_TOP_MARGIN * 0.5,PHONE_WIDTH, SQUARE_HEIGHT)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];

    _exponentViewArray = [NSMutableArray array];
    NSInteger count = 3;
    
    for (NSInteger i = 0;i < count; i++) {
        UUExponentView *exponentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUExponentView class]) owner:self options:nil] firstObject];
        exponentView.frame = CGRectMake(i * SQUARE_LENGTH + 2, 0, SQUARE_LENGTH - 3, SQUARE_HEIGHT);
        exponentView.tag = i;
        [exponentView addTarget:self action:@selector(headerViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:exponentView];
        [_exponentViewArray addObject:exponentView];
    }
    
    _newStockButton = [UIKitHelper buttonWithFrame:CGRectZero title:@"新股日历" titleHexColor:@"#474747" font:[UIFont boldSystemFontOfSize:15.0f]];

    _newStockButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    [_newStockButton addTarget:self action:@selector(headerViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_newStockButton setImage:[UIImage imageNamed:@"Stock_list_xingurili"] forState:UIControlStateNormal];
    [_newStockButton setImage:[UIImage imageNamed:@"Stock_list_xingurili"] forState:UIControlStateHighlighted];
//    [self addSubview:_newStockButton];
    
    _dailyListedButton = [UIKitHelper buttonWithFrame:CGRectZero title:@"今日上市" titleHexColor:@"#474747" font:[UIFont boldSystemFontOfSize:15.0f]];
    _dailyListedButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_dailyListedButton setImage:[UIImage imageNamed:@"Stock_list_jinrishangshi"] forState:UIControlStateNormal];
    [_dailyListedButton setImage:[UIImage imageNamed:@"Stock_list_jinrishangshi"] forState:UIControlStateHighlighted];
//    [self addSubview:_dailyListedButton];
}

- (void)setIndexDataArray:(NSArray *)indexDataArray
{
    if (indexDataArray == nil || _indexDataArray == indexDataArray) {
        return;
    }
    _indexDataArray = [indexDataArray copy];
    
    if (_indexDataArray.count != _exponentViewArray.count) {
        return;
    }
    
    for (NSInteger i = 0; i < _exponentViewArray.count; i++) {
        UUExponentView *v = [_exponentViewArray objectAtIndex:i];
        v.indexDetailModel = [_indexDataArray objectAtIndex:i];
    }
    
}

#pragma mark - 
- (void)headerViewAction:(UIView *)exponentView
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedView:)]) {
        [_delegate headerView:self didSelectedView:(UUExponentView *)exponentView];
    }
}

//
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 0.5f);
//    CGContextSetStrokeColorWithColor(context,k_LINE_COLOR.CGColor);
//    CGContextMoveToPoint(context, 0, CGRectGetHeight(self.bounds) - 0.5f);
//    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 0.5f);
//    CGContextMoveToPoint(context, CGRectGetWidth(self.bounds) * 0.5,UUStockBlockHeaderViewHeight - 41.0f);
//    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds) * 0.5,UUStockBlockHeaderViewHeight - 10.0f);
//
//    CGContextStrokePath(context);
//}
//
//- (void)layoutSubviews
//{
//    _newStockButton.frame = CGRectMake(0,UUStockBlockHeaderViewHeight - 51.0f, CGRectGetWidth(self.bounds) * 0.5, 51.0f);
//    _dailyListedButton.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.5,UUStockBlockHeaderViewHeight - 51.0f, CGRectGetWidth(self.bounds) * 0.5, 51.0f);
//
//}

@end



@implementation UUStockBlockSectionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];//[UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f];

    }
    return self;
}


- (id)initWithFrame:(CGRect)frame title:(NSString *)title  index:(NSInteger)index
{
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    NSDictionary *attributes = @{
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                                    NSForegroundColorAttributeName : k_BIG_TEXT_COLOR
                                 };
    [_title drawAtPoint:CGPointMake(3 * k_LEFT_MARGIN, (UUStockBlockSectionViewHeight - fontSize) * 0.5)  withAttributes:attributes];

    attributes = @{
                   NSFontAttributeName : [UIFont boldSystemFontOfSize:moreFontSize],
                   NSForegroundColorAttributeName : [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]
                   };
    [@"更多" drawAtPoint:CGPointMake(CGRectGetWidth(self.frame) - k_LEFT_MARGIN - moreFontSize * 3, (UUStockBlockSectionViewHeight - moreFontSize) * 0.5)  withAttributes:attributes];
    
    UIImage *image = [UIImage imageNamed:@"Stock_list_more"];
    [image drawInRect:CGRectMake(CGRectGetWidth(self.frame) - k_LEFT_MARGIN - image.size.width,(UUStockBlockSectionViewHeight - image.size.height) * 0.5 + 1.0f ,image.size.width,image.size.height)];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   CGPoint point = [[touches anyObject] locationInView:self];
    CGRect actionRact = CGRectMake(CGRectGetWidth(self.frame) - k_LEFT_MARGIN - moreFontSize * 3, 0, moreFontSize * 3, UUStockBlockSectionViewHeight);
    
    if (point.x > CGRectGetMinX(actionRact) && point.x < CGRectGetMaxX(actionRact)) {
        if ([_delegate respondsToSelector:@selector(sectionViewDidSeletedMore:)]) {
            [_delegate sectionViewDidSeletedMore:self];
        }
    }
}

@end

@interface UUStockListViewController ()<UUStockBlockHeaderViewDelegate,UUStockBlockSectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    UUStockBlockHeaderView *_headerView;
    
    NSArray *_sectionTitleArray;
    
    id _observer;
    id _indexObserver;
    id _hotProfessionObserver;
    id _conceptObserver;
    //指数
    NSArray *_indexDataArray;
    //热门行业
    NSArray *_hotProfessionArray;
    //概念板块
    NSArray *_conceptArray;
    //排序数据
    NSArray *_dataArray;

}
@end

@implementation UUStockListViewController

+ (UUStockListViewController *)sharedUUStockListViewController{
    return g_vc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        g_vc = self;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self configNavigationBar];
}

#pragma mark ----
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _sectionTitleArray = @[@"涨幅榜",@"跌幅榜",@"振幅榜",@"换手率榜"];
    
    [self configNavigationBar];
    
    [self configCollectionView];

//    [self loadData];
}


- (void)loadData
{
    removeObserver(_observer)
    removeObserver(_indexObserver)
    removeObserver(_hotProfessionObserver)
    removeObserver(_conceptObserver)
//    上证指数
    UUFavourisStockModel *favStockModel1 = [[UUFavourisStockModel alloc] initWithName:@"上证指数" code:@"000001" market:4352];
    //深圳成指
    UUFavourisStockModel *favStockModel2 = [[UUFavourisStockModel alloc] initWithName:@"深证成指" code:@"399001" market:4608];
    //创业板指
    UUFavourisStockModel *favStockModel3 = [[UUFavourisStockModel alloc] initWithName:@"创业板指" code:@"399006" market:4608];
    
    NSArray *modelArray = @[favStockModel1,favStockModel2,favStockModel3];
    [_indicator startAnimating];

//    if (![_collectionView.header isRefreshing]) {
//        [self showLoading];
//    }
    _indexObserver = [[UUMarketQuationHandler sharedMarkeQuationHandler] getStockDetailWithFavStockModelArray:modelArray success:^(NSArray *indexDataArray) {
//        [self stopLoading];
        [_indicator stopAnimating];

        [modelArray enumerateObjectsUsingBlock:^(UUFavourisStockModel *favStockModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexDataArray enumerateObjectsUsingBlock:^(UUIndexDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([favStockModel.code isEqualToString:model.code]) {
                    model.name = favStockModel.name;
                }
            }];
        }];
        
        [_collectionView.header endRefreshing];
        
        _headerView.indexDataArray = indexDataArray;
        [self loadStockSortRank];

    } failue:^(NSString *errorMessage) {
        [self loadStockSortRank];

        [_indicator stopAnimating];
        [_collectionView.header endRefreshing];

    }];
//    //热门行业
//    _hotProfessionObserver = [[UUMarketQuationHandler sharedMarkeQuationHandler] getReportBlockWithType:0 count:6 sortType:0 Success:^(NSArray *dataArray) {
//
//        _hotProfessionArray = [dataArray copy];
//        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
//
//    } failure:^(NSString *errorMessage) {
//
//    }];
    
//    //概念板块
//    _conceptObserver = [[UUMarketQuationHandler sharedMarkeQuationHandler] getReportBlockWithType:1 count:6 sortType:0 Success:^(NSArray *dataArray) {
//
//        _conceptArray = [dataArray copy];
//        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
//
//    } failure:^(NSString *errorMessage) {
//
//    }];
}

- (void)loadStockSortRank
{
    //    //排名
    _observer = [[UUMarketQuationHandler sharedMarkeQuationHandler] getReportSortSuccess:^(NSArray *dataArray) {
        _dataArray = [dataArray copy];
        [_collectionView reloadData];
        [_collectionView.header endRefreshing];
        if (self.loadDataCompeleted) {
            self.loadDataCompeleted();
        }
    } failure:^(NSString *errorMessage) {
        [_collectionView.header endRefreshing];
        if (self.loadDataCompeleted) {
            self.loadDataCompeleted();
            self.loadDataCompeleted = nil;
        }
    }];
}

- (void)configNavigationBar
{
//    self.tabBarController.navigationItem.title = @"行情";
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(PHONE_WIDTH* 0.5 - 80, 0, 160.0f, 44.0f)];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.text = @"行情";
    [titleView addSubview:label];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator = indicator;

    indicator.hidesWhenStopped = YES;
    [titleView addSubview:indicator];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleView);
    }];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.right.equalTo(label.mas_left).mas_offset(-5);
    }];
    
    self.tabBarController.navigationItem.titleView = titleView;
    UIImage *searchImage = [UIImage imageNamed:@"Nav_search"];
    UIButton *searchButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, searchImage.size.width  * 2, searchImage.size.height) title:nil titleHexColor:nil font:nil];
    [searchButton setImage:searchImage forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    self.tabBarController.navigationItem.rightBarButtonItems = @[item1];
}


- (void)configCollectionView
{
    CGFloat height = 0;
    
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        // 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
        height = keyWindow.safeAreaInsets.bottom;
    }
//    [self.view addSubview:[self headerView]];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), PHONE_HEIGHT - kTabBarHeight - height);
 
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 20, UUStockBlockSectionViewHeight);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collectionView.backgroundColor = k_BG_COLOR;//[UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    _collectionView.contentInset = UIEdgeInsetsMake(UUStockBlockHeaderViewHeight, 0, 0, 0);
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_collectionView];
    
    _headerView = [self collectionHeaderView];
    [_collectionView addSubview:_headerView];
    
    [_collectionView registerClass:[UUStockBlockCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UUStockBlockCollectionViewCell class])];
    [_collectionView registerClass:[UUStockBlockSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UUStockBlockSectionView class])];
}

- (UUStockBlockHeaderView *)collectionHeaderView
{
    UUStockBlockHeaderView *headerView = [[UUStockBlockHeaderView alloc] initWithFrame:CGRectMake(0,-UUStockBlockHeaderViewHeight, CGRectGetWidth(self.view.bounds), UUStockBlockHeaderViewHeight)];
    headerView.delegate = self;
    return headerView;
}

#pragma mark - UUStockBlockHeaderViewDelegate
- (void)headerView:(UUStockBlockHeaderView *)headerView didSelectedView:(UUExponentView *)view
{
    UUIndexDetailModel *model = view.indexDetailModel;
    
    if (model == nil) {
        return;
    }
    
    UUStockDetailViewController *detailVC = [[UUStockDetailViewController alloc] initWithStockModel:model];

    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDelegate,Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UUStockBlockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UUStockBlockCollectionViewCell class]) forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UUStockBlockCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    
    cell.indexPath = indexPath;
    cell.reportSortStockModel = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UUStockBlockSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UUStockBlockSectionView class]) forIndexPath:indexPath];
        sectionView.title = [_sectionTitleArray objectAtIndex:indexPath.section];

        sectionView.index = indexPath.section;
        sectionView.delegate = self;

        return sectionView;
    }
    
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) - 2 * k_LEFT_MARGIN, UUStockBlockViewSortCellHeight);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(0, k_LEFT_MARGIN, 0, k_LEFT_MARGIN);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UUStockModel *stockModel = _dataArray[indexPath.section][indexPath.row];
    UUStockDetailViewController *stockDetailVC = [[UUStockDetailViewController alloc] initWithStockModel:stockModel];
    [self.navigationController pushViewController:stockDetailVC animated:YES];
}

#pragma mark - 搜索
- (void)searchAction
{
    UUStockSearchViewController *searchViewController = [[UUStockSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - UUStockBlockSectionViewDelegate
- (void)sectionViewDidSeletedMore:(UUStockBlockSectionView *)sectionView
{
    UUDailyLimitViewController *dailyLimitVC = [[UUDailyLimitViewController alloc] init];
    //更多
    switch (sectionView.index) {
//        case 0:
//            //热门行业
////            dailyLimitVC.rankType ;
//            dailyLimitVC.rankType = UUHotProfessionType;
//            break;
//        case 1:
//            //概念板块
//            //            dailyLimitVC.rankType ;
//            dailyLimitVC.rankType = UUConceptType;
//            break;
        case 0:
            //涨幅榜
                dailyLimitVC.rankType = UUIncreaseRateType;
            break;
        case 1:
            //跌幅榜
                dailyLimitVC.rankType = UUDecreaseRateType;
            break;
        case 2:
            //振幅榜
                dailyLimitVC.rankType = UUAmplitudeRateType;
            break;
        case 3:
            //换手率榜
            dailyLimitVC.rankType =UUExchangeRateType;
            break;
       
        default:
            break;
    }
    
    [self.navigationController pushViewController:dailyLimitVC animated:YES];
}

- (void)backAction
{
    removeObserver(_indexObserver)
    removeObserver(_observer)
    removeObserver(_hotProfessionObserver)
    removeObserver(_conceptObserver)
    [super backAction];
}

@end
