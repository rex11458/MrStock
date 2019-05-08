//
//  UUPersonalSettingViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalSettingViewController.h"
#import "UULoginHandler.h"
#import "UUPersonalSettingViewCell.h"
@interface UUPersonalSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSArray *_viewControllers;
}
@end

@implementation UUPersonalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";

    _dataArray = @[
                   @[@"修改密码"/*,@"推送设置"*/,@"行情刷新"],
                   @[@"意见反馈"],
                   @[@"退出"]
                   ];
    
    _viewControllers = @[
                    @[@"UUpersonalChangePasswordViewController"
                      ,@"UUPersonalRefrashTimeViewController"],
                         @[@"UUSuggestionViewController"],
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
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUPersonalSettingViewCell";
    
    UUPersonalSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUPersonalSettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
        cell.arrowImageView.hidden = (indexPath.section == 2 && indexPath.row == 1) ;
    
    cell.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUPersonalSettingViewCellHeight;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alertView show];
    }else
    {
        UIViewController *vc = [[NSClassFromString(_viewControllers[indexPath.section][indexPath.row]) alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"正在登出..." maskType:SVProgressHUDMaskTypeBlack];
        [[UULoginHandler sharedLoginHandler] logoutWithSessionID:[UUserDataManager sharedUserDataManager].user.sessionID success:^(id obj) {
            
            [SVProgressHUD showSuccessWithStatus:@"登出成功!" maskType:SVProgressHUDMaskTypeBlack];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }
}


@end
