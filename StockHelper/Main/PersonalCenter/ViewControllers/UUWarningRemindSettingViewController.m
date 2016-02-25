//
//  UUWarningRemindSettingViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUWarningRemindSettingViewController.h"
#import "UUWarningRemindSettingViewCell.h"
#import <Masonry/Masonry.h>
@implementation UUWarningRemindSettingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = k_UPPER_COLOR;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _nameLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:16.0f] textColor:[UIColor whiteColor]];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    
    _codeLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:12.0f] textColor:[UIColor whiteColor]];
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_codeLabel];
    
    _priceLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:26.0f] textColor:[UIColor whiteColor]];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLabel];
    
    _raiseCountLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:12.0f] textColor:[UIColor whiteColor]];
    _raiseCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_raiseCountLabel];
    
    _raiseRateLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:12.0f] textColor:[UIColor whiteColor]];
    _raiseRateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_raiseRateLabel];
    
    CGFloat width = PHONE_WIDTH / 3.0f;

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(width, UUWarningRemindSettingHeaderViewHeight * 0.5 - 10));
        make.top.mas_equalTo(self.mas_top).offset(10);

    }];
    
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    
        make.size.mas_equalTo(CGSizeMake(width, UUWarningRemindSettingHeaderViewHeight * 0.5 - 10));
    }];
    
  
    [_raiseRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, UUWarningRemindSettingHeaderViewHeight * 0.5 - 10));
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top).offset(10);
    }];
    
    [_raiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, UUWarningRemindSettingHeaderViewHeight * 0.5 - 10));
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(self.mas_height);
        
    }];
    
    
    [self loadData];
}

- (void)loadData
{
    _nameLabel.text = @"山西证券";
    _codeLabel.text = @"002500";
    _priceLabel.text = @"23.09";
    _raiseRateLabel.text = @"涨跌幅 +10.04%";
    _raiseCountLabel.text = @"涨 跌 +3.82";
}

@end

@interface UUWarningRemindSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation UUWarningRemindSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"预警提醒设置";
    _dataArray = @[
                   @[@"股价上涨到",@"股价下跌到"],
                   @[@"日涨跌幅到",@"浮动盈亏"],
                   @[@"公告提醒"],
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
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:_tableView];
}

- (UUWarningRemindSettingHeaderView *)tableHeaderView
{
    UUWarningRemindSettingHeaderView *headerView = [[UUWarningRemindSettingHeaderView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, UUWarningRemindSettingHeaderViewHeight)];
    
    return headerView;
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
    static NSString *cellId = @"UUWarningRemindSettingViewCell";
    
    UUWarningRemindSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUWarningRemindSettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    [cell setTitle:_dataArray[indexPath.section][indexPath.row] price:@"" remind:YES];
    cell.hiddenTextField = (indexPath.section == 2 && indexPath.row == 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUWarningRemindSettingViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 34.0f;
    }
    return k_TOP_MARGIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), k_TOP_MARGIN)];

    headerView.backgroundColor = tableView.backgroundColor;
    
    if (section == 0) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, 10, 5, 14)];
        [imageView setImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR]];
        [headerView addSubview:imageView];
  
        
        UILabel *textLabel = [UIKitHelper labelWithFrame:CGRectMake(k_LEFT_MARGIN + CGRectGetMaxX(imageView.frame), 0, 200, 34) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
        textLabel.text = @"预警提醒设置";
        [headerView addSubview:textLabel];
    }
    
    return headerView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
