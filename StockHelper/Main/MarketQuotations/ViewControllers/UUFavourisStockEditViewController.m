//
//  UUFavourisStockEditViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisStockEditViewController.h"
#import "UUStockListHeaderView.h"
#import "UUFavourisEditTableViewCell.h"
#import "UUMarketQuationHandler.h"
#import "UUFavourisStockModel.h"
#import "UUDatabaseManager.h"

static const void *IndieBandNameKey = &IndieBandNameKey;

@interface UUFavourisStockModel (Position)

- (BOOL)selected;
- (void)setSelected:(BOOL)selected;
@end

@implementation UUFavourisStockModel (Position)

- (BOOL)selected
{
    return [objc_getAssociatedObject(self, IndieBandNameKey) boolValue];
}

- (void)setSelected:(BOOL)selected
{
    objc_setAssociatedObject(self, IndieBandNameKey,@(selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#define StockEditViewFooterViewHeight 44.0f
@interface UUFavourisStockEditViewController ()<UITableViewDelegate,UITableViewDataSource,UUFavourisEditTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_selectedStockModelArray;
    UIButton *_delButton;
}
@end

@implementation UUFavourisStockEditViewController

#pragma mark ----
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的自选";

    self.view.backgroundColor =  k_BG_COLOR;

    _selectedStockModelArray = [NSMutableArray array];
    
    
    [self configSubViews];
}

- (void)configSubViews
{
    UUStockListHeaderView *headerView = [[UUStockListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUStockListHeaderViewHeight) titleArray:@[@"名称代码"]];
    [self.view addSubview:headerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UUStockListHeaderViewHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - UUStockListHeaderViewHeight - StockEditViewFooterViewHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setEditing:YES];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    [self.view addSubview:_tableView];

    [self.view addSubview:[self footerView]];
}

- (UIView *)footerView
{
    CGFloat height = 0;
    
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        // 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
        height = keyWindow.safeAreaInsets.bottom;
    }
    CGFloat footerViewHeight = StockEditViewFooterViewHeight;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.bounds) - footerViewHeight - height, CGRectGetWidth(self.view.bounds), footerViewHeight)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIColor *titleColor = k_NAVIGATION_BAR_COLOR; 
    
    NSArray *titles = @[@"全选",@"删除"];
    NSArray *selectedTitle = @[@"取消全选",@""];
    CGFloat buttonWidth = PHONE_WIDTH / (float)titles.count;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIKitHelper imageWithColor:k_BG_COLOR] forState:UIControlStateNormal];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, footerViewHeight);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitle:selectedTitle[i] forState:UIControlStateSelected];

        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(footerViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:button];
        if (i == 1) {
            _delButton = button;
        }
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footerView.bounds), 0.5f)];
    line.backgroundColor = [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f];
    [footerView addSubview:line];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(footerView.bounds) * 0.5,  CGRectGetHeight(footerView.bounds) * 0.25, 0.5f, CGRectGetHeight(footerView.bounds) * 0.5)];
    line.backgroundColor = [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f];
    [footerView addSubview:line];
    
    return footerView;
}

- (void)footerViewButtonAction:(UIButton *)button
{
    if (button.tag == 0)
    {
        //全选
        button.selected = !button.isSelected;
        
        [_stockModelArray enumerateObjectsUsingBlock:^(UUFavourisStockModel *stockModel, NSUInteger idx, BOOL *stop) {
            stockModel.selected = button.isSelected;
        }];
        
        if (!button.isSelected)
        {
            [_selectedStockModelArray removeAllObjects];
        }
        else
        {
            [_selectedStockModelArray removeAllObjects];
            [_selectedStockModelArray addObjectsFromArray:_stockModelArray];
        }
        [_tableView reloadData];
        [_delButton setTitle:[NSString stringWithFormat:@"删除(%@)",@(_selectedStockModelArray.count)] forState:UIControlStateNormal];
    }
    else if (button.tag == 1)
    {
        //删除股票
        if (_selectedStockModelArray.count == 0) {
            return;
        }
        
        NSMutableArray *listIDArray = [NSMutableArray array];
        
        [_selectedStockModelArray enumerateObjectsUsingBlock:^(UUFavourisStockModel *stockModel, NSUInteger idx, BOOL *stop) {
            if (stockModel.listID != nil) {
                [listIDArray addObject:stockModel.listID];
            }
        }];
        
        [self deleteFavStocksSuccess];

    }
}

- (void)deleteFavStocksSuccess
{
    [SVProgressHUD showSuccessWithStatus:@"删除成功" maskType:SVProgressHUDMaskTypeBlack];
    NSMutableArray *stockModelArray = [_stockModelArray mutableCopy];

    [_selectedStockModelArray enumerateObjectsUsingBlock:^(UUFavourisStockModel *stockModel, NSUInteger idx, BOOL *stop) {

        if ([_stockModelArray containsObject:stockModel]) {
            
            [stockModelArray removeObject:stockModel];
        }
        [[UUDatabaseManager manager] deleteFavouris:stockModel.code];
        
    }];
    [_selectedStockModelArray removeAllObjects];
    _stockModelArray = [stockModelArray copy];
    [_tableView reloadData];
    
    //删除成功后返回
    if (_deleteSuccess) {
        _deleteSuccess(_stockModelArray);
    }
    if (_stockModelArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 删除成功后返回
- (void)deleteSuccess:(void (^)(NSArray *))success
{
    _deleteSuccess = [success copy];
}

#pragma mark - 排序成功后返回
- (void)updatePositionSuccess:(void (^)(NSArray *))success
{
    _updatePositionSuccess = [success copy];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _stockModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUFavourisEditTableViewCell";
    UUFavourisEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UUFavourisEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    cell.stockModel = [_stockModelArray objectAtIndex:indexPath.row];
    cell.checkButton.selected =  cell.stockModel.selected;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUFavourisEditTableViewCellHeight;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row == destinationIndexPath.row) {
        return;
    }
    [self exchangePositionSourceIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - UUFavourisEditTableViewCellDelegate
- (void)tableViewCell:(UUFavourisEditTableViewCell *)cell didSeletedIndex:(NSInteger)index
{
    if (index == 0) {
        cell.checkButton.selected = !cell.checkButton.isSelected;
        cell.stockModel.selected = cell.checkButton.selected;
        //复选
        if (cell.checkButton.isSelected)
        {
            [_selectedStockModelArray addObject:cell.stockModel];
        }
        else
        {
            if ([_selectedStockModelArray containsObject:cell.stockModel]) {
                [_selectedStockModelArray removeObject:cell.stockModel];
            }
        }
        [_delButton setTitle:[NSString stringWithFormat:@"删除(%@)",@(_selectedStockModelArray.count)] forState:UIControlStateNormal];

    }else if (index == 1){
        //提醒
    }else if (index == 2){
        //置顶
        NSIndexPath *sourceIndexPath = [_tableView indexPathForCell:cell];
        NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self exchangePositionSourceIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

- (void)exchangePositionSourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    UUFavourisStockModel *stockModelA = [_stockModelArray objectAtIndex:sourceIndexPath.row];
    UUFavourisStockModel *stockModelB = [_stockModelArray objectAtIndex:destinationIndexPath.row];
    [self exchangePostionWithStockModel:stockModelA destinationIndexPath:destinationIndexPath];

}

- (void)exchangePostionWithStockModel:(UUFavourisStockModel *)stockModel destinationIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *stockModelArray = [_stockModelArray mutableCopy];
    
    [stockModelArray removeObject:stockModel];
    
    [stockModelArray insertObject:stockModel atIndex:indexPath.row];
    
    _stockModelArray = [stockModelArray copy];
    if (_updatePositionSuccess) {
        _updatePositionSuccess(_stockModelArray);
    }
    
    [[UUDatabaseManager manager] addFavourisList:_stockModelArray];
    [_tableView reloadData];
//    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
}

@end
