//
//  UUFavourisGroupEditViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisGroupEditViewController.h"
#import "UUStockListHeaderView.h"
#import "UUFavourisEditTableViewCell.h"
#import "UUMarketQuationHandler.h"
#import "UUFavourisStockModel.h"
#define GroupStockEditViewFooterViewHeight 44.0f
@interface UUFavourisGroupEditViewController ()<UITableViewDelegate,UITableViewDataSource,UUFavourisEditTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_seletedIndexPathArray;
}
@end

@implementation UUFavourisGroupEditViewController
#pragma mark ----
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _seletedIndexPathArray = [NSMutableArray array];
    self.view.backgroundColor =  k_BG_COLOR;
    [self configSubViews];
}

- (void)configSubViews
{
    UUStockListHeaderView *headerView = [[UUStockListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUStockListHeaderViewHeight) titleArray:@[@"名称代码"]];
    [self.view addSubview:headerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UUStockListHeaderViewHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - UUStockListHeaderViewHeight - GroupStockEditViewFooterViewHeight) style:UITableViewStylePlain];
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
    CGFloat footerViewHeight = GroupStockEditViewFooterViewHeight;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.bounds) - footerViewHeight, CGRectGetWidth(self.view.bounds), footerViewHeight)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIColor *titleColor = k_NAVIGATION_BAR_COLOR;
    
    NSArray *titles = @[@"全选",@"删除"];
    NSArray *selectedTitle = @[@"取消全选",@""];
    CGFloat buttonWidth = PHONE_WIDTH / (float)titles.count;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, footerViewHeight);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitle:selectedTitle[i] forState:UIControlStateSelected];
        
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(footerViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:button];
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
    if (button.tag == 0) {
        //全选
        button.selected = !button.isSelected;
    }else if (button.tag == 1){
        //删除
//        UUFavourisStockModel *stockModel = [
//        [[UUMarketQuationHandler sharedMarkeQuationHandler] deleteFavourisStockWithListID:<#(NSString *)#> success:^(id obj) {
//            
//        } failue:^(NSString *errorMessage) {
//            
//        }];
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;//_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUFavourisEditTableViewCell";
    UUFavourisEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UUFavourisEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    
    cell.checkButton.selected = [_seletedIndexPathArray containsObject:indexPath];
    
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
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        //复选
        if (cell.checkButton.isSelected)
        {
            [_seletedIndexPathArray addObject:indexPath];
        }
        else
        {
            if ([_seletedIndexPathArray containsObject:indexPath]) {
                [_seletedIndexPathArray removeObject:indexPath];
            }
        }
    }else if (index == 1){
        //提醒
    }else if (index == 2){
        //置顶
    }
}@end
