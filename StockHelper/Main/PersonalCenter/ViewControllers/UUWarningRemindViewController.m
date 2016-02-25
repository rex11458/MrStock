//
//  UUWarningRemindViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/7.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUWarningRemindViewController.h"
#import "UUWarningRemindViewCell.h"
#import "UUWarningRemindSettingViewController.h"
@interface UUWarningRemindViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *_dataArray;
    UITableView *_tableView;
    UUWarningRemindViewCell *_selectedCell;
}
@end

@implementation UUWarningRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"预警提醒";
    [self configSubViews];
}

- (void)configSubViews
{
    CGRect frame = self.view.bounds;
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
    static NSString *cellId = @"UUWarningRemindViewCell";
    
    UUWarningRemindViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUWarningRemindViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId target:self action:@selector(cellAction:)];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUWarningRemindViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUWarningRemindSettingViewController *warningSettingVC = [[UUWarningRemindSettingViewController alloc] init];
    [self.navigationController pushViewController:warningSettingVC animated:YES];
}


- (void)cellAction:(UUWarningRemindViewCell *)cell
{
    _selectedCell = cell;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认取消" message:@"汉麻产业(002500)\n的预警提醒?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    }
}

@end
