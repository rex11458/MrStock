//
//  UUPersonalPushSettingViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalPushSettingViewController.h"
#import "UUPersonalPushSettingViewCell.h"

@interface UUPersonalPushSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation UUPersonalPushSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推送设置";
    
    _dataArray = @[
                   @{
                       k_TITLE : @"自选股信息",
                       k_SUB_TITLE : @"",
                       k_SETTING_VALUE : [[NSUserDefaults standardUserDefaults] objectForKey:@"cell0"] == nil ? @(1):[[NSUserDefaults standardUserDefaults] objectForKey:@"cell0"],
                       },
                   @{
                       k_TITLE : @"资讯信息",
                       k_SUB_TITLE : @"",
                       k_SETTING_VALUE : [[NSUserDefaults standardUserDefaults] objectForKey:@"cell1"] == nil ? @(1):[[NSUserDefaults standardUserDefaults] objectForKey:@"cell1"],
                       },
                   @{
                       k_TITLE : @"关注",
                       k_SUB_TITLE : @"接收我关注的人的最新动态提示",
                       k_SETTING_VALUE : [[NSUserDefaults standardUserDefaults] objectForKey:@"cell2"] == nil ? @(1):[[NSUserDefaults standardUserDefaults] objectForKey:@"cell2"],
                       }
                   ];
    

    [self configSubViews];
}

- (void)configSubViews
{
    CGRect frame = CGRectMake(0, 0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds));
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUPersonalPushSettingViewCell";
    
    UUPersonalPushSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUPersonalPushSettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId target:self action:@selector(valueChanged:)];
    }
    cell.values = [_dataArray objectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUPersonalPushSettingViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return k_TOP_MARGIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), k_TOP_MARGIN)];
    
    headerView.backgroundColor = tableView.backgroundColor;
    return headerView;
}

#pragma mark - valueChanged

- (void)valueChanged:(UISwitch *)swth
{
    UUPersonalPushSettingViewCell * cell = (UUPersonalPushSettingViewCell *)[self superviewOfType:[UUPersonalPushSettingViewCell class] forView:swth];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(swth.on) forKey:[NSString stringWithFormat:@"cell%ld",indexPath.section]];
    [defaults synchronize];
    
}

- (UIView *)superviewOfType:(Class )paramSuperviewClass forView:(UIView *)paramView{
    if (paramView.superview != nil)
    {
        if ([paramView.superview isKindOfClass:paramSuperviewClass])
        {
            return paramView.superview;
        }
        else
        {
            return [self superviewOfType:paramSuperviewClass forView:paramView.superview];
        }
    }
    return nil;
}


@end
