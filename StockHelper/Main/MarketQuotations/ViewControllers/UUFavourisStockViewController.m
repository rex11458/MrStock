//
//  UUFavourisViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisStockViewController.h"
#import "UUStockSearchViewController.h"
#import "UUStockListHeaderView.h"
#import "UUDatabaseManager.h"
#import "UUStockKeyboard.h"
#import "UUStockModel.h"
#import "UUFavourisViewCell.h"
#import "UUFavourisStockEditViewController.h"
#import "UUMarketQuationHandler.h"
#import "UUFavourisStockModel.h"
#import "UUFavourisStockModel.h"
#import "UUStockIdxDetailViewController.h"
#import "UUPersonalStockDetailViewController.h"
#import "UUTabbar.h"
#import "NSTimer+Addition.h"
#import "UUStockDetailModel.h"
#import "UUIndexDetailModel.h"
#import "UUStockDetailViewController.h"
@interface UUFavourisStockViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UUDatabaseManager *_bdManager;

    UITableView *_tableView;
    
    id _favObserver;  //
    
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIView *emptyView;

@property (nonatomic,strong) UIButton *editButton;

@end

@implementation UUFavourisStockViewController

- (id)init
{
    if(self = [super init])
    {
        _bdManager = [UUDatabaseManager manager];
        
    }
    return self;
}

- (void)addRightBarButtons
{
    UIImage *searchImage = [UIImage imageNamed:@"Nav_search"];
    UIImage *shareImage = [UIImage imageNamed:@"Nav_edit"];
    
    UIButton *searchButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, searchImage.size.width  * 2, searchImage.size.height) title:nil titleHexColor:nil font:nil];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:searchImage forState:UIControlStateNormal];
    
    UIButton *editButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, shareImage.size.width, shareImage.size.height) title:nil titleHexColor:nil font:nil];
    _editButton = editButton;
    _editButton.userInteractionEnabled = NO;
    [editButton setImage:shareImage forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}

#pragma mark ----
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的自选";
    [self addRightBarButtons];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configSubViews];
    
    //自选为空视图
    self.emptyView = [self m_emptyView];
    [self.view addSubview:_emptyView];
    self.emptyView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    //数据库获取
    [self loadDBData];
    
//    从网络获取自选列表
        [self loadData];
}

- (void)loadDBData
{
    
    __weak typeof(self) weakSelf = self;
    [_bdManager favoriousList:^(NSArray *dataArray) {
        weakSelf.dataArray = [dataArray mutableCopy];
        [self showNoDataView];
        [_tableView reloadData];
    }];
}

- (void)showNoDataView
{
    //    根据本地获取自选列表是否为空显示emptyView
    if (_dataArray == nil || _dataArray.count == 0) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
        [self getStocksDetailInfo];
    }
}


- (void)configSubViews
{
    UUStockListHeaderView *headerView = [[UUStockListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUStockListHeaderViewHeight) titleArray:@[@"名称代码",@"最新价",@"涨跌幅"]];
    [self.view addSubview:headerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UUStockListHeaderViewHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - UUStockListHeaderViewHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    [self.view addSubview:_tableView];
    

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStocksDetailInfo)];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UUFavourisViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UUFavourisViewCellID"];
}

//自选为空
- (UIView *)m_emptyView
{
    UIView *emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
    emptyView.backgroundColor = k_BG_COLOR;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fav_empty_bubble"]];
    imageView.center = CGPointMake(CGRectGetWidth(emptyView.frame) * 0.5, CGRectGetHeight(emptyView.frame) * 0.5);
    imageView.userInteractionEnabled = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    UUButton *button = [UUButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"fav_empty_add"];
    [button setTitle:@"点击添加自选股票" forState:UIControlStateNormal];
    [button setTitleColor:k_NAVIGATION_BAR_COLOR forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.frame = CGRectMake(0, 0, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame));
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    [emptyView addSubview:imageView];
    
    return emptyView;
}

//获取自选列表
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    
    [[UUMarketQuationHandler sharedMarkeQuationHandler] getFavourisStockListSuccess:^(NSArray *stockModelArray) {

        [weakSelf.tableView.header endRefreshing];
        
        if (stockModelArray.count == 0) {
            return ;
        }
  
        weakSelf.dataArray = [stockModelArray mutableCopy];
        
        if (weakSelf.dataArray.count > 0) {
            [weakSelf.tableView reloadData];
            [weakSelf getStocksDetailInfo];
            weakSelf.emptyView.hidden = YES;
            weakSelf.editButton.userInteractionEnabled = YES;
        }
        else
        {
            weakSelf.emptyView.hidden = NO;
            weakSelf.editButton.userInteractionEnabled = NO;
        }
   
    } failue:^(NSString *errorMessage) {
        [weakSelf stopLoading];
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (void)getStocksDetailInfo
{
    removeObserver(_favObserver);
    __weak typeof(self) weakSelf = self;

   _favObserver = [[UUMarketQuationHandler sharedMarkeQuationHandler] getStockDetailWithFavStockModelArray:_dataArray success:^(NSArray *stockModelArray)
     {
         [stockModelArray enumerateObjectsUsingBlock:^(UUStockModel *stockModel, NSUInteger idx, BOOL *stop) {
             
             double newPrice = [[stockModelArray objectAtIndex:idx] newPrice];
             
             double preClosePrice = [[stockModelArray objectAtIndex:idx] preClose];
             
             [weakSelf.dataArray enumerateObjectsUsingBlock:^(UUFavourisStockModel  *favStockModel, NSUInteger idx, BOOL * _Nonnull stop) {
                 
                 if (stockModel.market == favStockModel.market && [favStockModel.code isEqualToString:stockModel.code]) {
                     favStockModel.price = [NSString amountValueWithDouble:newPrice];
                     favStockModel.deltaPrice = [NSString amountValueWithDouble:newPrice - preClosePrice];
                     favStockModel.deltaRate = (preClosePrice == 0 ? 0 : [NSString stringWithFormat:@"%f",(newPrice - preClosePrice) / preClosePrice]);
                 }
             }];
         }];
         
         [weakSelf.tableView reloadData];
         weakSelf.editButton.userInteractionEnabled = YES;
         weakSelf.emptyView.hidden = YES;
         [weakSelf.tableView.header endRefreshing];
     } failue:^(NSString *errorMessage) {
         [weakSelf.tableView.header endRefreshing];
     }];
}

#pragma mark - 搜索
- (void)searchAction
{
    __weak typeof(self) weakSelf = self;

    UUStockSearchViewController *searchViewController = [[UUStockSearchViewController alloc] init];
    //添加成功后返回
    [searchViewController addFavouris:^(UUFavourisStockModel *stockModel) {
     
        if (weakSelf.dataArray.count > 0)
        {
            [weakSelf.dataArray insertObject:stockModel atIndex:0];
        }else
        {
            [weakSelf.dataArray addObject:stockModel];
        }
        [weakSelf.tableView reloadData];
         weakSelf.emptyView.hidden = weakSelf.dataArray.count;
        
         weakSelf.editButton.userInteractionEnabled = weakSelf.dataArray.count;
         [weakSelf getStocksDetailInfo];
     }];
    //删除成功后返回
    [searchViewController deleteFavourise:^(UUFavourisStockModel *stockModel) {
        [_dataArray enumerateObjectsUsingBlock:^(UUFavourisStockModel *favStockModel, NSUInteger idx, BOOL *stop) {
            if ([stockModel.code isEqualToString:favStockModel.code]) {
                [weakSelf.dataArray removeObject:favStockModel];
                [weakSelf.tableView reloadData];
            }
        }];
        
        weakSelf.emptyView.hidden = _dataArray.count;
        weakSelf.editButton.userInteractionEnabled = weakSelf.dataArray.count;

    }];

    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - 编辑
- (void)editingAction
{
    __weak typeof(self) weakSelf = self;

    UUFavourisStockEditViewController *favManagerViewController = [[UUFavourisStockEditViewController alloc] init];
    favManagerViewController.stockModelArray = _dataArray;
    [favManagerViewController deleteSuccess:^(NSArray *stockModelArray) {
        weakSelf.dataArray = [stockModelArray mutableCopy];
        [weakSelf.tableView reloadData];
        weakSelf.emptyView.hidden = _dataArray.count;
        weakSelf.editButton.userInteractionEnabled = _dataArray.count;
    }];
    
    [favManagerViewController updatePositionSuccess:^(NSArray *stockModelArray) {
        weakSelf.dataArray = [stockModelArray copy];
        [weakSelf.tableView reloadData];
    }];
    
    [self.navigationController pushViewController:favManagerViewController animated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUFavourisViewCellID";
    UUFavourisViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.stockModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUStockModel *stockModel = [_dataArray objectAtIndex:indexPath.row];
    
    UUStockDetailViewController *vc = [[UUStockDetailViewController alloc] initWithStockModel:stockModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUFavourisViewCellHeight;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_dataArray != nil) {
        [self getStocksDetailInfo];
    }
}

- (void)dealloc
{
    removeObserver(_favObserver)
}
@end
