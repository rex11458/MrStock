//
//  UUNewStockViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/17.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUNewStockViewController.h"
#import "UUNewStockViewCell.h"
#import "UUNewStockSectionView.h"
@interface UUNewStockViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation UUNewStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新股日历";
    [self configSubViews];
}


- (void)configSubViews
{
    CGRect frame = CGRectMake(0, 0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds));
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"UUNewStockViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UUNewStockViewCellId"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"UUNewStockSectionView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"UUNewStockSectionViewId"];
}

#pragma mark - UITableView delegatge、datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUNewStockViewCellId";
    
    UUNewStockViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

      return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UUNewStockSectionView *sectionView = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UUNewStockSectionViewId"];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
