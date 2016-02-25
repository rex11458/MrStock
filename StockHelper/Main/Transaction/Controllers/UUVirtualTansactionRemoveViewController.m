
//
//  UUVirtualTansactionRemoveViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionRemoveViewController.h"
#import "UUVirtualTansactionBusinessViewCell.h"
#import "UUTabbar.h"
@implementation UUVirtualTansactionRemoveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"模拟交易撤单";
    self.view.backgroundColor = k_BG_COLOR;
    [self configSubViews];
}

#pragma mark - configSubViews
- (void)configSubViews
{
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
                              @"title" : @"查询",
                              @"image" : @"business_select",
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
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT);
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;

    [self.view addSubview:_tableView];
}

#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUVirtualTansactionBusinessViewCell";
    //
    UUVirtualTansactionBusinessViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUVirtualTansactionBusinessViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
//    cell.businessType = self.businessType;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUVirtualTansactionBusinessViewCellHeight;
}

@end
