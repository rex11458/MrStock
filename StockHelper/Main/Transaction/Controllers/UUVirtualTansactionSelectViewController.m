//
//  UUVirtualTansactionSelectViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionSelectViewController.h"
#import "UUVirtualTansactionSelectViewCell.h"
#import "UUVirtualTansactionBusinessViewController.h"
#import "UUVirtualTansactionRemoveViewController.h"
#import "UUVirtualTansactionBuyingViewController.h"
#import "UUTabbar.h"
@implementation UUVirtualTansactionSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"查询";
    
    NSArray *orgItems = @[
                          @{
                              @"title" : @"买入",
                              @"image" : @"Toolbar_buy",
                              @"selectedImage" : @""
                              },
                          @{
                              @"title" : @"卖出",
                              @"image" : @"Toolbar_sell",
                              @"selectedImage" : @""
                              },
                          @{
                              @"title" : @"撤单",
                              @"image" : @"business_remove",
                              @"selectedImage" : @""
                              }
                          ];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0 ; i < orgItems.count ;i++) {
        NSDictionary *dic = [orgItems objectAtIndex:i];
        NSString *title = [dic objectForKey:@"title"];
        UIImage *image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        UIImage *selectedImage = [UIImage imageNamed:[dic objectForKey:@"selectedImage"]];
        UUTabbarItem *item = [[UUTabbarItem alloc] initWithTitle:title image:image selectedImage:selectedImage tag:i];
        [items addObject:item];
    }
    UUToolBar *toolBar = [[UUToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT, CGRectGetWidth(self.view.bounds), k_TABBER_HEIGHT) items:items delegate:self];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:toolBar];

    _dataArray = @[
                   @[@"当日委托",@"当日成交"],
                   @[@"历史成交"],
                   @[@"配号",@"中签"]
                   ];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;

    [self.view addSubview:_tableView];
}

#pragma mark - UITableView delegatge、datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUVirtualTansactionSelectViewCell";
    //
    UUVirtualTansactionSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUVirtualTansactionSelectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
          }
    cell.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 10.0f)];
    sectionView.backgroundColor = k_BG_COLOR;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUVirtualTansactionSelectViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UUVirtualTansactionBusinessViewController *businessVC = [[UUVirtualTansactionBusinessViewController alloc] init];
    businessVC.businessType = indexPath.section*10 + indexPath.row;
    [self.navigationController pushViewController:businessVC animated:YES];
}

#pragma mark - UUTooBarDelegate
- (void)toolBar:(UUToolBar *)toolBar didSeletedIndex:(NSInteger)index
{
    if (index == 2) {
        //撤单
        UUVirtualTansactionRemoveViewController *removeVC = [[UUVirtualTansactionRemoveViewController alloc] init];
        [self.navigationController pushViewController:removeVC animated:YES];
        return;
    }
    
    
    UUVirtualTansactionBuyingViewController *buyingVC = [[UUVirtualTansactionBuyingViewController alloc] init];
    buyingVC.type = index;
    [self.navigationController pushViewController:buyingVC animated:YES];
}



@end
