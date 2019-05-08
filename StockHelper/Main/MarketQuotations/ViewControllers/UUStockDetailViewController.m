//
//  UUStockDetailViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/11/10.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailViewController.h"
#import "UUStockCommomHeaderView.h"
#import "UUMarketQuationHandler.h"
#import "UUStockDetailTitleView.h"
#import "UUDatabaseManager.h"
#import <Masonry/Masonry.h>
NSString * const stockDetailDidLoadSuccessNotificaiton = @"StockDetailDidLoadSuccessNotificaiton";
@interface UUStockDetailViewController ()
{
    UUStockDetailTitleView *_titleView;
    /*观察者*/
    id _stockDetailObserver;//行情
    id _shareTimeObserver;  //分时
    id _stockTickObserver;  //分价
    id _kLineObserver;      //k线
    id _financailObsever;    //财务数据
    BOOL _financailLoaded; //财务数据
}
@end

static UUStockDetailViewController *g_shared;

@implementation UUStockDetailViewController

+ (UUStockDetailViewController *)g_sharedStockDetailViewController
{
    return g_shared;
}

- initWithStockModel:(UUStockModel *)stockModel
{
    if (self = [super init]) {
        self.stockModel = stockModel;
        g_shared = self;
    }
    return self;
}

- (UUStockDetailTitleView *)createTitleView
{
    UUStockDetailTitleView *titleView = [[UUStockDetailTitleView alloc] initWithFrame:CGRectMake(PHONE_WIDTH* 0.5 - 80, 0, 160.0f, 44.0f)];
    titleView.title = [NSString stringWithFormat:@"%@(%@)",_stockModel.name,_stockModel.code];
    
    return titleView;
}

- (void)addRightBarButtons
{
    UIImage *searchImage = [UIImage imageNamed:@"Nav_search"];
    
    UIButton *searchButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, searchImage.size.width  * 2, searchImage.size.height) title:nil titleHexColor:nil font:nil];
    [searchButton setImage:searchImage forState:UIControlStateNormal];
   
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItems = @[item];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_stockModel.code.length == 0) return;
    _titleView = [self createTitleView];
//    [self addRightBarButtons];
    self.navigationItem.titleView = _titleView;

    if ([[UUDatabaseManager manager] isFavouris:_stockModel.code] != nil) {
        _isFav = YES;
    }
    
    UUMarketDataType market = _stockModel.market;
    if (k_IS_INDEX(market))
    {
        _indexViewController = [[UUStockIdxDetailViewController alloc] init];
        _indexViewController.stockModel = _stockModel;
        [self addChildViewController:_indexViewController];
         _protraitView = _indexViewController.view;
        [self.view addSubview:_protraitView];
        
        _indexViewController.isFav = _isFav;
        
        _headerView = _indexViewController.headerView;
        _landspaceView.stockType = 1;//指数
    }
    else
    {
        _personalViewController = [[UUPersonalStockDetailViewController alloc] init];
        _personalViewController.stockModel = _stockModel;
        _protraitView = _personalViewController.view;
        [self.view addSubview:_protraitView];
        _headerView = _personalViewController.headerView;
        _personalViewController.isFav = _isFav;

        _landspaceView.stockType = 0;//个股

        //复权
        __weak typeof(self) weakSelf = self;
        _landspaceView.exRights = ^(NSInteger index){
            //0:不复权 1:前复权 2:后复权
       
            [[UUMarketQuationHandler sharedMarkeQuationHandler] exRightsWithCode:weakSelf.stockModel.code type:weakSelf.stockModel.market success:^(NSArray *exRightsArray) {
                
                    weakSelf.landspaceView.exRightsArray = exRightsArray;
                //
            } failure:^(NSString *errorMessage) {
                
            }];
        };
    }
    [self loadData];
}

- (void)loadData
{
    [self loadStockDetail];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showLineWithIndex:self.lineIndex];
    });
}

- (void)showLineWithIndex:(NSInteger)index
{
    if (index == 0) {
        [self loadShareTime];
        return;
    }
    
    if (_landspaceView.stockType == 0) {
        if (index == 1) {
            [self loadSharePrice];
        }else {
            [self loadKLineWithIndex:index-1];
        }
    }else{
        [self loadKLineWithIndex:index];
    }
}

- (void)loadStockDetail
{
    removeObserver(_stockDetailObserver)
    
    __weak typeof(self) weakSelf = self;
   _stockDetailObserver = [[UUMarketQuationHandler sharedMarkeQuationHandler] getStockDetailWithCode:self.stockModel.code type:self.stockModel.market success:^(UUStockModel *stockModel) {
        stockModel.name = weakSelf.stockModel.name;
        weakSelf.headerView.stockModel = stockModel;
        weakSelf.landspaceView.stockModel = stockModel;
        
       _titleView.accesoryTitle = [NSString stringWithFormat:@"%@ %@",weakSelf.stockModel.lstMarktDate?:@"",stockModel.time];
    
       //个股 获取财务数据
       if (!k_IS_INDEX(_stockModel.market) && _financailLoaded == NO) {
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              
               [weakSelf loadFinancialInfo];
          
           });
       }
       
        [[NSNotificationCenter defaultCenter] postNotificationName:stockDetailDidLoadSuccessNotificaiton object:nil];
        
    } failue:^(NSString *errorMessage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:stockDetailDidLoadSuccessNotificaiton object:nil];
    }];
}

//分时
- (void)loadShareTime
{
    removeObserver(_shareTimeObserver)
    __weak typeof(self) weakSelf = self;
  _shareTimeObserver = [[UUMarketQuationHandler sharedMarkeQuationHandler] getStockShareInfoWithCode:self.stockModel.code type:self.stockModel.market success:^(UUStockQuoteEntity *entity) {
        
        weakSelf.headerView.marketQuotationView.quoteEntity = entity;
        weakSelf.landspaceView.queotyEntity = entity;
        
    } failure:^(NSString *errorMessage) {
        
        
    }];
}

//分价
- (void)loadSharePrice
{
    removeObserver(_stockTickObserver)
    __weak typeof(self) weakSelf = self;
   _stockTickObserver = [[UUMarketQuationHandler sharedMarkeQuationHandler] getCurrentPriceWithCode:self.stockModel.code type:self.stockModel.market success:^(NSArray *timeEntityArray) {
        weakSelf.headerView.marketQuotationView.currentPriceView.priceModelArray = timeEntityArray;
        weakSelf.landspaceView.currentPriceModelArray = timeEntityArray;
    } failue:^(NSString *errorMessage) {
        
    }];
}

//K线
- (void)loadKLineWithIndex:(NSInteger)index
{
    removeObserver(_kLineObserver)
    __weak typeof(self) weakSelf = self;

    //K线
    NSInteger type = daily_kLine;
    if (index == 2) {
        type = week_kLine;
    }else if (index == 3){
        type = month_kLine;
    }
    [[UUMarketQuationHandler sharedMarkeQuationHandler] getKLineWithCode:self.stockModel.code type:self.stockModel.market lineType:type success:^(NSArray *kLineArray) {
        
        weakSelf.headerView.marketQuotationView.kLineModelArray = kLineArray;
        weakSelf.landspaceView.quotationView.kLineModelArray = kLineArray;
        
    } failure:^(NSString *errorMessage) {
        
    }];
}

//财务数据
- (void)loadFinancialInfo
{
    removeObserver(_financailObsever)
    __weak typeof(self) weakSelf = self;
    
    _financailObsever = [[UUMarketQuationHandler sharedMarkeQuationHandler] getFinancialInfoWithCode:self.stockModel.code type:self.stockModel.market success:^(UUStockFinancialModel *financialModel) {
        weakSelf.headerView.finacialModel = financialModel;
        weakSelf.landspaceView.finacialModel = financialModel;
        _financailLoaded = YES;

    } failure:^(NSString *errorMessage) {
        
    }];
}

#pragma mark - 切换横竖屏
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.navigationController setNavigationBarHidden:(toInterfaceOrientation != UIInterfaceOrientationPortrait)];
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        [_landspaceView removeFromSuperview];
        _protraitView.frame = self.view.bounds;
        [self.view addSubview:_protraitView];
        
        [_headerView showLineViewWithIndex:_lineIndex];
        _headerView.marketQuotationView.type = 0; //竖屏
    }
    else
    {
        _financailLoaded = NO;
        [_protraitView removeFromSuperview];
        _landspaceView = [[[NSBundle mainBundle] loadNibNamed:@"UUStockDetailLandspaceView" owner:self options:nil] firstObject];
        _landspaceView.frame = self.view.bounds;
        [self.view addSubview:_landspaceView];
        if (k_IS_INDEX(_stockModel.market)) {
            _landspaceView.stockType = 1;
        }
//        
        __weak typeof(self) weakSelf = self;
        [_landspaceView setSelectedIndex:^(NSInteger index){
            weakSelf.lineIndex = index;
            [weakSelf showLineWithIndex:weakSelf.lineIndex];
        }];
        _landspaceView.quotationView.type = 1;//横屏
        [self loadStockDetail];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf showLineWithIndex:weakSelf.lineIndex];
        });
        [_landspaceView showLineViewWithIndex:_lineIndex];
    }
}



- (void)backAction
{
    [super backAction];
    removeObserver(_stockDetailObserver)
    removeObserver(_shareTimeObserver)
    removeObserver(_kLineObserver)
    removeObserver(_kLineObserver)
    removeObserver(_financailObsever)
}

- (void)dealloc
{
    removeObserver(_stockDetailObserver)
    removeObserver(_shareTimeObserver)
    removeObserver(_kLineObserver)
    removeObserver(_kLineObserver)
    removeObserver(_financailObsever)
}

@end
