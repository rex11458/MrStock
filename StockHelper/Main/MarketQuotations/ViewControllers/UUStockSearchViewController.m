//
//  UUStockSearchViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/5/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockSearchViewController.h"
#import "UUStockSearchBar.h"
#import "UUStockModel.h"
#import "UUFavourisStockModel.h"
#import "UUDatabaseManager.h"
#import "UUSearchViewCell.h"
#import "UUMarketQuationHandler.h"
#import "UUStockDetailViewController.h"
@interface UUStockSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UUStockSearchBarDelegate,UUSearchViewCellDelegate>
{
    UUDatabaseManager *_dbManager;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    
    UITableView *_searchTableView;
    
    UUSearchViewCell *_selectedCell;
}
@end

@implementation UUStockSearchViewController


- (id)init
{
    if (self = [super init])
    {
        _dbManager = [UUDatabaseManager manager];
    }
    return self;
}

- (void)addLeftBarButton
{
    UIImage *image = [UIImage imageNamed:@"Nav_back"];
    UIButton *leftBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width * 2, image.size.height)];
    [leftBackButton setImage:image forState:UIControlStateNormal];
    leftBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -18, 0,0);
    [leftBackButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackButton];
}

#pragma mark - backAction
- (void)backAction
{
    [self.navigationItem.titleView endEditing:YES];
    if (_type == 2) {
        //通过股票买卖界面返回
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        //--
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLeftBarButton];

    [self configSubView];
    
    [self loadData];
}

- (void)loadData
{
    //显示最近搜索记录
    _dataArray = [[_dbManager stockSearchRecordList] mutableCopy];
    [self showTableFooterAndHeaderView];
}

- (void)configSubView
{
    UUStockSearchBar *searchBar = [[UUStockSearchBar alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH - k_RIGHT_MARGIN - 2 * 24.0f, 30.0f)];
    searchBar.delegate = self;
    [searchBar becomeFirstResponder];
    self.navigationItem.titleView = searchBar;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = [self headerView];
    _tableView.tableFooterView = [self footerView];
    _tableView.contentSize = _tableView.frame.size;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGRect frame = _tableView.frame;
    frame.size.height -= keyboardHeight;
    _tableView.frame = frame;
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGRect frame = _tableView.frame;
    frame.size.height += keyboardHeight;
    _tableView.frame = frame;
}

- (UIView *)headerView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 44.0f)];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, CGRectGetHeight(headerView.bounds) * 0.25, 10.0f,CGRectGetHeight(headerView.bounds) * 0.5)];
    line.backgroundColor = [UIColorTools colorWithHexString:@"ADADAD" withAlpha:1.0f];
    [headerView addSubview:line];
    
    UILabel *lable = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(line.frame) + k_LEFT_MARGIN, 0, 200, CGRectGetHeight(headerView.bounds)) Font:[UIFont systemFontOfSize:16.0f] textColor:[UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]];
    lable.text = @"历史搜索记录";
    [headerView addSubview:lable];
    return headerView;
}

- (UIView *)footerView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 60.0f)];
    
    UIButton *button = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, 112.0f, 30.0f) title:@"清除搜索历史记录" titleHexColor:@"#ADADAD" font:[UIFont systemFontOfSize:14.0f]];
    button.center = CGPointMake(CGRectGetWidth(footerView.bounds) * 0.5, CGRectGetHeight(button.bounds) * 0.75);
    [button addTarget:self action:@selector(removeAllSearchRecord) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(button.bounds) - 0.5f, CGRectGetWidth(button.bounds), 0.5f)];
    line.backgroundColor = [UIColorTools colorWithHexString:@"ADADAD" withAlpha:1.0f];
    [button addSubview:line];
    return footerView;
}


#pragma mark - UITableViewDataSource,Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUSearchViewCell";
    
    UUSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UUSearchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
        cell.hiddenAddFavButton = _type;
    }
    
    cell.stockModel = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationItem.titleView endEditing:YES];

    UUStockModel *stockModel = [_dataArray objectAtIndex:indexPath.row];

    if (_type == 0)
    {
        UUStockDetailViewController *vc = [[UUStockDetailViewController alloc] initWithStockModel:stockModel];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //    添加搜索记录
            if (![_dbManager isSearchRecord:stockModel.code])
            {
                [_dbManager addStockSearchRecord:stockModel];
            }
        });
        
    }else if(_type == 1)
    {
        //发表话题界面选择股票
        if (_success)
        {
            _success(stockModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(_type == 2)
    {
        //买卖界面
        int market = stockModel.market;
        if (k_IS_INDEX(market)) {
            [SVProgressHUD showInfoWithStatus:@"指数不可买卖" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        _success(stockModel);
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.navigationItem.titleView endEditing:YES];
}

- (void)SSMarketAction:(UUStockSearchBar *)searchBar
{
    [self.navigationItem.titleView endEditing:YES];
    UUStockModel *model = [[UUDatabaseManager manager] selectStockModelWithCode:@"000001" market:0];
    UUStockDetailViewController *vc = [[UUStockDetailViewController alloc] initWithStockModel:model];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)SZMarketAction:(UUStockSearchBar *)searchBar
{
    [self.navigationItem.titleView endEditing:YES];
    //深圳成指
    UUStockModel *model = [[UUDatabaseManager manager] selectStockModelWithCode:@"399001" market:0];
    UUStockDetailViewController *vc = [[UUStockDetailViewController alloc] initWithStockModel:model];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 添加和删除自选后返回
- (void)addFavouris:(void(^)(UUFavourisStockModel *))success
{
    _addFavSuccess = [success copy];
}

- (void)deleteFavourise:(void (^)(UUFavourisStockModel *))success
{
    _deleteFavSuccess = [success copy];
}

- (void)removeAllSearchRecord
{
    [_dbManager removeAllSearchRecord];
    [_dataArray removeAllObjects];
    [self showTableFooterAndHeaderView];
    [_tableView reloadData];
}

- (void)showTableFooterAndHeaderView
{
    if (_dataArray.count == 0) {
        _tableView.tableFooterView.hidden = YES;
        _tableView.tableHeaderView.hidden = YES;
    }else{
        _tableView.tableFooterView.hidden = NO;
        _tableView.tableHeaderView.hidden = NO;
    }
}



#pragma mark - UUStockSearchBarDelegate
- (void)searchBar:(UUStockSearchBar *)searchBar textDidChange:(NSString *)searchText
{
    UUDatabaseManager *dbManager = [UUDatabaseManager manager];
    NSArray *stockModelArray = nil;
    if (searchText.length == 0)
    {
        //显示最近搜索记录
        stockModelArray = [[_dbManager stockSearchRecordList] mutableCopy];
     
            _tableView.tableFooterView.hidden = !stockModelArray.count;
            _tableView.tableHeaderView.hidden = !stockModelArray.count;
    }
    else
    {
        //搜索到的股票
        NSInteger searchType = 0;
        if (_type == 2) {
            searchType = 1;
        }
       stockModelArray = [dbManager selectStockModelWithCondition:searchText type:searchType];
        if (stockModelArray.count == 0) {
            return;
        }
        _tableView.tableFooterView.hidden = YES;
        _tableView.tableHeaderView.hidden = YES;
    }
    _dataArray = [stockModelArray mutableCopy];
    [_tableView reloadData];
}

#pragma  mark - UUSearchViewCellDelegate
- (void)searchViewCell:(UUSearchViewCell *)cell favoriousOption:(UUStockModel *)stockModel
{
    _selectedCell = cell;
    UUFavourisStockModel *favStockModel = [[UUDatabaseManager manager] isFavouris:stockModel.code];
    
    if (favStockModel == nil)
    {
        [self addFavourisWithStockCode:stockModel];
    }else
    {
        [self delFavourisWithStockCode:favStockModel];
    }
}

- (void)addFavourisWithStockCode:(UUStockModel *)stockModel
{
    UUFavourisStockModel *favStockModel = [[UUFavourisStockModel alloc] init];
    favStockModel.name = stockModel.name;
    favStockModel.code = stockModel.code;
    favStockModel.market =stockModel.market;
    //用户在线，通过网络请求添加删除自选股
    if ([UUserDataManager userIsOnLine])
    {
        [SVProgressHUD showWithStatus:@"正在执行..." maskType:SVProgressHUDMaskTypeBlack];
        NSString *code = stockModel.code;
        if (k_IS_INDEX(stockModel.market)) {
            code = [code stringByAppendingString:@".INX"];
        }
        [[UUMarketQuationHandler sharedMarkeQuationHandler] addFavourisStockWithCode:code pos:self.pos success:^(NSString *listID) {
            self.pos++;
            //listID加入favStockModel中
            
           [self addLocalFavourisWithFavStockModel:favStockModel ListID:listID];
            
        } failue:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }else
    {
        [self addLocalFavourisWithFavStockModel:favStockModel ListID:@""];
    }
}

- (void)addLocalFavourisWithFavStockModel:(UUFavourisStockModel *)favStockModel ListID:(NSString *)listID
{
    favStockModel.listID = listID;
    
    [_dbManager addfavouris:favStockModel];
    
    _selectedCell.favButton.selected = YES;
    [SVProgressHUD showSuccessWithStatus:@"添加成功" maskType:SVProgressHUDMaskTypeBlack];
    
    if (_addFavSuccess) {
        _addFavSuccess(favStockModel);
    }
}

- (void)delFavourisWithStockCode:(UUFavourisStockModel *)favStockModel
{
    if ([UUserDataManager userIsOnLine])
    {
        [SVProgressHUD showWithStatus:@"正在执行..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[UUMarketQuationHandler sharedMarkeQuationHandler] deleteFavourisStockWithListID:favStockModel.listID success:^(id obj) {
            [self delLocalFavourisWithFavStockModel:favStockModel];
        } failue:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
    }
    else
    {
        [self delLocalFavourisWithFavStockModel:favStockModel];
    }
}

- (void)delLocalFavourisWithFavStockModel:(UUFavourisStockModel *)favStockModel
{
    _selectedCell.favButton.selected = NO;
    [_dbManager deleteFavouris:favStockModel.code];
    [SVProgressHUD showSuccessWithStatus:@"删除成功" maskType:SVProgressHUDMaskTypeBlack];
    if (_deleteFavSuccess) {
        _deleteFavSuccess(favStockModel);
    }
}
@end
