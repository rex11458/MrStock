//
//  UUDiscoverViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUDiscoverViewController.h"
#import "UUDiscoverViewCell.h"
#import "UUPersonalStockDetailViewController.h"
#import "UUGeniusRankViewController.h"
#import "UUGeniusRankManagerViewController.h"
#import "UUStockListViewController.h"
#import "UUCommunityViewController.h"
#import "UUFavourisStockViewController.h"
#import "UUTabbar.h"
#import "UUHomeButtonView.h"
#import "UUDiscoverHandler.h"
#import "UUTradeChanceModel.h"
#import "UUPersonalHomeViewController.h"
#import "UUVirtualTansactionBuyingViewController.h"
#import "UUStockSearchViewController.h"
#import "UUStockModel.h"
#import "UUDatabaseManager.h"
#import "UUStockDetailViewController.h"
#import "UULoginViewController.h"
#define BUTTON_MARGIN 10.0f
#define TITLE_HEIGHT 30.0f

//static CGFloat kDeltaFactor = 0.5f;


@interface UUDiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    UUDiscoverSectionView *_sectionView;
    UUDiscoverHeaderView *_headerView;
    
    UIRefreshControl *_refreshControl;
}
@end

@implementation UUDiscoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configSubViews];
    [self loadData];
}

- (void)loadData
{
    [[UUDiscoverHandler sharedDiscoverHandler] getTradeChanceSuccess:^(NSArray *dataArray) {
        _dataArray = [dataArray copy];
        
        [_tableView.header endRefreshing];
        
        if (_dataArray == nil || _dataArray.count == 0) {
            
            if (!self.isShowNoData) {
                self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_tableView.tableHeaderView.frame) + _sectionView.frame.size.height, PHONE_WIDTH,CGRectGetHeight(_tableView.frame) - CGRectGetHeight(_tableView.tableHeaderView.frame) - _sectionView.frame.size.height)];
                
                [_tableView addSubview:self.noDataView];
                [self showNodataWithTitle:k_remainder(@"no_data_ transaction_ chance") inView:self.noDataView];
            }
            
            return ;
        }
        if (self.noDataView) {
            [self.noDataView removeFromSuperview];
        }
        [_tableView reloadData];
    } failure:^(NSString *errorMessage) {
        [_tableView.header endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"股先生";
    self.tabBarController.navigationItem.titleView = nil;
    UIImage *searchImage = [UIImage imageNamed:@"Nav_search"];
    UIButton *searchButton = [UIKitHelper buttonWithFrame:CGRectMake(0,0, searchImage.size.width  * 2, searchImage.size.height) title:nil titleHexColor:nil font:nil];
    [searchButton setImage:searchImage forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.tabBarController.navigationItem.rightBarButtonItems = @[item];
}

- (void)configSubViews
{
     CGRect frame = CGRectMake(0, 0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT);

    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    _headerView = [self tableHeaderView];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.tableHeaderView = _headerView;
 
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UUDiscoverViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UUDiscoverViewCellID"];
    
    [self.view addSubview:_tableView];
    [self initSectionView];
}

#pragma mark - 搜索
- (void)searchAction
{
    UUStockSearchViewController *searchVC = [[UUStockSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)initSectionView
{
    UUDiscoverSectionView *sectionView = [[UUDiscoverSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.bounds), 0)];
    sectionView.frame = sectionView.defaultFrame;
    
    _sectionView = sectionView;
    _sectionView.delegate = self;
}

- (UUDiscoverHeaderView *)tableHeaderView
{
    UUDiscoverHeaderView *headerView = [[UUDiscoverHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    CGRect frame = headerView.frame;
    frame.size.height = [headerView height];
    headerView.frame = frame;
    return headerView;
}

#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUDiscoverViewCellID";
    
    UUDiscoverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.target = self;
    cell.stockDetailAction = @selector(stockDetailAction:);
    cell.userDetailAction = @selector(userDetailAction:);
    cell.buyingAction = @selector(buyingAction:);
    cell.tradeChanceModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGRectGetHeight(_sectionView.currentFrame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUDiscoverViewCellHeight;
}

#pragma mark - UUDiscoverSectionViewDelegate
- (void)sectionView:(UUDiscoverSectionView *)sectionView didSelectedIndex:(NSInteger)index
{
    if (index == 0)
    {
        UUGeniusRankManagerViewController *geniusRankVC = [[UUGeniusRankManagerViewController alloc] init];
        [self.navigationController pushViewController:geniusRankVC animated:YES];
    }
    else if (index == 1)
    {
        UUStockListViewController *stockListVC = [[UUStockListViewController alloc] init];
        [self.navigationController pushViewController:stockListVC animated:YES];
    }
    else if (index == 2)
    {
        UUFavourisStockViewController *favourisVC = [[UUFavourisStockViewController alloc] init];
        [self.navigationController pushViewController:favourisVC animated:YES];
    }
    else if (index == 3)
    {
        UUCommunityViewController *communityVC = [[UUCommunityViewController alloc] init];
        [self.navigationController pushViewController:communityVC animated:YES];
    }
}

#pragma mark - stockDetailAction
- (void)stockDetailAction:(UUDiscoverViewCell *)cell
{
    UUStockModel *stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:cell.tradeChanceModel.code market:UUStockExchangeAShareType];

    UUStockDetailViewController *stockDetailVC = [[UUStockDetailViewController alloc] initWithStockModel:stockModel];

    [self.navigationController pushViewController:stockDetailVC animated:YES];
}

#pragma mark - userDetailAction
- (void)userDetailAction:(UUDiscoverViewCell *)cell
{
    UUPersonalHomeViewController *vc = [[UUPersonalHomeViewController alloc] init];
    vc.userId = cell.tradeChanceModel.userID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - buyingAction
- (void)buyingAction:(UUDiscoverViewCell *)cell
{
    if (![UUserDataManager userIsOnLine]) {
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:0 success:^{
            [self buyingAction:cell];
        } failed:^{
            
        }];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        UUVirtualTansactionBuyingViewController *vc = [[UUVirtualTansactionBuyingViewController alloc] init];
        vc.type = 0;//买入
        UUStockModel *stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:cell.tradeChanceModel.code market:UUStockExchangeAShareType];
        vc.stockModel = stockModel;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [_headerView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];

    [_sectionView layoutSectionViewForScrollViewOffset:scrollView.contentOffset headerViewHeight:[_headerView height]];
}
@end


#pragma mark - UUDiscoverHeaderView

@implementation UUDiscoverHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame ])
    {
        [self configSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configSubViews
{
    
    UIImage *image = [UIImage imageNamed:@"banner"];
    CGSize size = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds) * image.size.height / image.size.width);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView = [[UIScrollView alloc] initWithFrame:imageView.bounds];
    [_scrollView addSubview:imageView];
    
    [self addSubview:_scrollView];
    _defaultImageFrame = _scrollView.frame;
    
    _height = CGRectGetMaxY(_scrollView.frame);
    
    //      UIImage *searchImage = [UIImage imageNamed:@"Nav_search"];
    //    UIButton *searchButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, searchImage.size.width  * 2, searchImage.size.height) title:nil titleHexColor:nil font:nil];
    //    [searchButton setImage:searchImage forState:UIControlStateNormal];
    //    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    //
    //    item.rightBarButtonItems = @[searchButton];
}


- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    if (offset.y < 0)
    {
        
        CGFloat delta = 0.0f;
        CGRect rect = self.defaultImageFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.origin.x -= delta * 0.5;
        rect.size.height += delta;
        rect.size.width += delta;
        _scrollView.frame = rect;
        CGRect frame = _toolbar.frame;
        frame.origin.y = delta;
        _toolbar.frame = frame;
    }
}

@end

@implementation UUDiscoverSectionView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    NSArray *orgItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UUDiscoverItems.plist" ofType:nil]];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0 ; i < orgItems.count ;i++) {
        NSDictionary *dic = [orgItems objectAtIndex:i];
        NSString *title = [dic objectForKey:@"title"];
        UIImage *image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        UIImage *selectedImage = [UIImage imageNamed:[dic objectForKey:@"selectedImage"]];
        UIColor *backgroundColor = [UIColorTools colorWithHexString:[dic objectForKey:@"backgroundColor"] withAlpha:1.0f];
        UUTabbarItem *item = [[UUTabbarItem alloc] initWithTitle:title image:image selectedImage:selectedImage backgroundColor:backgroundColor tag:i];
        [items addObject:item];
    }
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    CGFloat margin = BUTTON_MARGIN;
    CGFloat buttonViewWidth = PHONE_WIDTH / (CGFloat)items.count;
    CGFloat buttonViewHeight = buttonViewWidth;
    CGFloat buttonWidth = buttonViewWidth - 2 * margin;
    CGFloat buttonHeight = buttonWidth * 1.25;
    
    
    for (NSInteger i = 0; i < items.count; i++) {
        
        UUTabbarItem *item = [items objectAtIndex:i];
        
//        UUButton *button = [UUButton buttonWithType:UIButtonTypeCustom];
        UUHomeButtonView *button = [[UUHomeButtonView alloc] initWithFrame:CGRectZero];
        button.frame = CGRectMake(margin + i* buttonViewWidth,k_TOP_MARGIN * 0.5 + (buttonViewHeight - buttonHeight) * 0.5, buttonWidth, buttonHeight);
//        button.backgroundColor = [UIColor purpleColor];
        button.tag = i;
//        button.layer.cornerRadius = buttonWidth * 0.5;
//        button.layer.masksToBounds = YES;
        button.imageButton.imageView.contentMode = UIViewContentModeCenter;
        [button.imageButton setBackgroundImage:[UIKitHelper imageWithColor:item.backgroundColor] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
//        [button setBackgroundImage:[UIKitHelper imageWithColor:item.backgroundColor] forState:UIControlStateNormal];
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setImage:item.image forState:UIControlStateNormal];
        [button setTitleColor:[UIColorTools colorWithHexString:@"#474747" withAlpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttonArray addObject:button];
    }
    _buttonArray = [buttonArray copy];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,buttonViewHeight, CGRectGetWidth(self.bounds), TITLE_HEIGHT)];
    view.backgroundColor = [UIColorTools colorWithHexString:@"F6F6F6" withAlpha:1.0f];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN,(TITLE_HEIGHT - 14)*0.5 + 5,14, 14.0f)];
    imageView.image = [UIImage imageNamed:@"discover_jyjh"];
    [view addSubview:imageView];
    
    UILabel *label = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + k_LEFT_MARGIN, 5,100.0f, CGRectGetHeight(view.bounds)) Font:[UIFont boldSystemFontOfSize:15.0f] textColor:[UIColorTools colorWithHexString:@"#474747" withAlpha:1.0f]];
    label.text = @"交易机会";
    [view addSubview:label];
    [self insertSubview:view atIndex:0];
    _titleView = view;
    _defaultTitleViewFrame = _titleView.frame;
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(view.frame);
    _defaultFrame = frame;
    
    _currentFrame = _defaultFrame;
}

#pragma mark - buttonAction
- (void)buttonAction:(UUHomeButtonView *)button
{
    if ([_delegate respondsToSelector:@selector(sectionView:didSelectedIndex:)]) {
        [_delegate sectionView:self didSelectedIndex:button.tag];
    }
}

- (void)layoutSectionViewForScrollViewOffset:(CGPoint)offset
{
    if (offset.y > 0)
     {
         CGFloat delta = offset.y * 0.1;
         CGRect frame = self.defaultFrame;
         
         frame.size.height -= delta;

         if (frame.size.height < CGRectGetHeight(self.defaultFrame) - 20.0f)
         {
             frame.size.height = CGRectGetHeight(self.defaultFrame) - 20.0f;
             
             if (delta != 0)
             {
                 self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1/delta];
                 _titleView.alpha = 0;
             }
             
             for (UUHomeButtonView *button in _buttonArray)
             {
                 button.titleLabel.hidden = YES;
             }
         }
         else
         {
             for (UUHomeButtonView *button in _buttonArray)
             {
                 button.titleLabel.hidden = NO;
             }
             
             CGRect titleFrame = _defaultTitleViewFrame;
             titleFrame.origin.y -= delta;
             _titleView.frame = titleFrame;
             
             self.backgroundColor = [UIColor whiteColor];
             _titleView.alpha = 1.0f;
         }
         self.frame = frame;
         self.currentFrame = frame;
     }
}


- (void)layoutSectionViewForScrollViewOffset:(CGPoint)offset headerViewHeight:(CGFloat)height
{
    
    CGFloat offsetY = offset.y;
//    CGRect frame = self.defaultFrame;

    if (offsetY < height)
    {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1];
        _titleView.alpha = 1;
        for (UUHomeButtonView *button in _buttonArray)
        {
            button.titleLabel.hidden = NO;
        }
    }
    else
    {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0];
        _titleView.alpha = 0;
//        frame.size.height -= TITLE_HEIGHT;
        for (UUHomeButtonView *button in _buttonArray)
        {
            button.titleLabel.hidden = YES;
        }
    }
//    self.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    
//    CGFloat buttonWidth = CGRectGetHeight(self.bounds) - TITLE_HEIGHT - BUTTON_MARGIN * 2;
//    CGFloat buttonHeight = buttonWidth;
//
//    CGFloat buttonViewWidth = PHONE_WIDTH / (CGFloat)_buttonArray.count;
//    
//    CGFloat fontSize = buttonWidth * 12.0f / (CGRectGetHeight(self.defaultFrame) - TITLE_HEIGHT - BUTTON_MARGIN);
//    for (NSInteger i = 0 ;i < _buttonArray.count ; i++) {
//        UIButton *button = [_buttonArray objectAtIndex:i];
//        
//        button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
//        button.center = CGPointMake((i + 0.5) * buttonViewWidth, (CGRectGetHeight(self.bounds) - TITLE_HEIGHT) * 0.5);
////        button.layer.cornerRadius = buttonWidth * 0.5;
//        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
//    }
    _titleView.frame = CGRectMake(0,CGRectGetHeight(self.bounds) - TITLE_HEIGHT, CGRectGetWidth(self.bounds), TITLE_HEIGHT);
}

@end


