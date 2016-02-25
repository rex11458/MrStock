//
//  UUPersonalHomeViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalHomeViewController.h"
#import "UUPersonalHomeView.h"
#import "UUStockDetailComment.h"
#import "UUTradeAnalyViewController.h"
#import "UUMeHandler.h"
#import "UULoginHandler.h"
#import "UUTransactionHandler.h"
#import "UUPersonalHomeSubView.h"
#import "UUTransactionAssetModel.h"
#import <Masonry/Masonry.h>
#import "UULoginViewController.h"
#import "UUCommunityHandler.h"
#import "UUPersonalReplyModel.h"
#import "UUPersonalReplyViewCell.h"
#import "UUPersonalReplyTopicDataSource.h"
#import "UUCommunityTopicDetailViewController.h"
@interface UUPersonalHomeViewController ()<UITableViewDelegate,UUPersonalHomeSectionViewDelegate,UUPersonalHomeHeaderViewDelegate>
{
    UUPersonalHomeView *_homeView;
    UUPersonalHomeSectionView *_sectionView;
    UUPersonalHomeHeaderView *_headerView;
    NSArray *_dataSourceArray;
    UIButton *_favButton;
    
    NSInteger _focusId;
}
@end

@implementation UUPersonalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人主页";
    [self addRightButtonWithSelected:NO];
    
    [self configSubViews];

    [self loadData];
}

- (void)addRightButtonWithSelected:(BOOL)selected
{
    UIImage *favImage = [UIImage imageNamed:@"Nav_collection"];
    UIImage *favSelectedImage = [UIImage imageNamed:@"Nav_Collection_selected"];
    UIButton *favButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, favImage.size.width  * 2, favImage.size.height) title:nil titleHexColor:nil font:nil];
    favButton.selected = selected;
    _favButton = favButton;
    [favButton setImage:favImage forState:UIControlStateNormal];
    [favButton setImage:favSelectedImage forState:UIControlStateSelected];
    
    [favButton addTarget:self action:@selector(favAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:favButton];
    
    self.navigationItem.rightBarButtonItems = @[item1];
}

- (void)favAction
{
    if ([UUserDataManager userIsOnLine]) {
        if (_focusId == -1) {
            [[UUMeHandler sharedMeHandler] focusWithUserId:self.userId type:0 success:^(id obj) {
                [SVProgressHUD showSuccessWithStatus:@"关注成功" maskType:SVProgressHUDMaskTypeBlack];
                _focusId = [obj integerValue];
                _favButton.selected  =YES;
            } failure:^(NSString *errorMessage) {
                [SVProgressHUD showErrorWithStatus:errorMessage];
            }];
        }else
        {
            [[UUMeHandler sharedMeHandler] cancelFocusWithListId:[@(_focusId) stringValue] success:^(id obj) {
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功" maskType:SVProgressHUDMaskTypeBlack];
                _focusId = -1;
                _favButton.selected = NO;
            } failure:^(NSString *errorMessage) {
                [SVProgressHUD showErrorWithStatus:errorMessage];
            }];
        }
    }else
    {
        
        NSInteger index = self.navigationController.viewControllers.count - 1;
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:index success:^{
            [self loadData];
        } failed:^{
            
        }];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)loadData
{
    [self showLoading];
    //获取个人信息
    [[UULoginHandler sharedLoginHandler] getUserInfoWithUserId:self.userId success:^(User *user) {
        _headerView.user = user;
        [self stopLoading];

    } failure:^(NSString *errorMessage) {
        [self stopLoading];
    }];
    
    if ([UUserDataManager userIsOnLine])
    {
        if (![[UUserDataManager sharedUserDataManager].user.customerID isEqualToString:self.userId])
        {
            [[UUMeHandler sharedMeHandler] isFocusedWithUserId:self.userId type:0 success:^(NSNumber *focusId) {
                _focusId = [focusId integerValue];
                _favButton.selected  = (_focusId != -1);
            } failure:^(NSString *errorMessage) {
                
            }];
        }else{
            _favButton.hidden = YES;
        }
    }
    
//    [self showLoading];
    /**/
    //资金信息
    [[UUTransactionHandler sharedTransactionHandler] getBalanceWithUserId:_userId Success:^(UUTransactionAssetModel *assetModel) {
        _headerView.assetModel = assetModel;
    } failure:^(NSString *errorMessage) {
 
    }];
    
    //收益走势
    [[UUTransactionHandler sharedTransactionHandler] getProfitHistoryWithUserId:_userId startDate:@"" endDate:@"" success:^(NSArray *profitArray) {
        
        _headerView.chatView.profitArray = profitArray;
        
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void)configSubViews
{
    UUStockDetailCommentDataSource *commentDataSource = [[UUStockDetailCommentDataSource alloc] initWithUserId:_userId];
    UUPersonalReplyTopicDataSource *replyTopicDataSource = [[UUPersonalReplyTopicDataSource alloc] initWithUserId:_userId];
    _dataSourceArray = @[commentDataSource,replyTopicDataSource];

    _homeView = [[UUPersonalHomeView alloc] initWithFrame:self.view.bounds];
    _homeView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _homeView.delegate = self;
    _headerView = [self headerView];
    _homeView.tableView.tableHeaderView = _headerView;
    _homeView.dataSource = _dataSourceArray[0];
    [self.view addSubview:_homeView];
    [_homeView reload];
    
    _sectionView = [self sectionView];
}

- (UUPersonalHomeHeaderView *)headerView
{
    UUPersonalHomeHeaderView *headerView = [[UUPersonalHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, UUPersonalHomeHeaderViewHeight)];
    headerView.delegate = self;
    return headerView;
}

- (UUPersonalHomeSectionView *)sectionView
{
    UUPersonalHomeSectionView *sectionView = [[UUPersonalHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 30.0f)];
    sectionView.delegate = self;
    sectionView.titles = @[@"他的主贴",@"他的回复"];
    return sectionView;
}

#pragma mark - UUPersonalHomeHeaderViewDelegate
- (void)headerView:(UUPersonalHomeHeaderView *)headerView didSelectedIndex:(NSInteger)index
{
    if (_headerView.assetModel != nil &&  _headerView.chatView.profitArray != nil) {
        UUTradeAnalyViewController *analyVC = [[UUTradeAnalyViewController alloc] init];
        analyVC.userId = _headerView.user.customerID;
        analyVC.assetModel = _headerView.assetModel;
        analyVC.profitArray = _headerView.chatView.profitArray;
        [self.navigationController pushViewController:analyVC animated:YES];
    }
}

#pragma mark - UITableView DataSource,delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sectionView.index == 0) {
        return UUStockDetailCommentViewCellHeight;
    }else{
        return UUPersonalReplyViewCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUCommunityTopicDetailViewController *vc = [[UUCommunityTopicDetailViewController alloc] init];
    BaseDataSource *dataSource = [_dataSourceArray objectAtIndex:_sectionView.index];
    
    vc.topicModel = [dataSource.dataArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UUPersonalHomeSectionViewDelegate
- (void)sectionView:(UUPersonalHomeSectionView *)sectionView didSelectedIndex:(NSInteger)index
{
    _homeView.dataSource = _dataSourceArray[index];
    [_homeView reload];
}

@end


@implementation UUPersonalHomeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = k_BG_COLOR;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    
    UILabel *tradeInfo = [UIKitHelper labelWithFrame:CGRectMake(0, 126.0f, PHONE_WIDTH, 32.0f) Font:k_MIDDLE_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    tradeInfo.textAlignment = NSTextAlignmentCenter;
    tradeInfo.text = @"他的交易信息";
    [self addSubview:tradeInfo];
    
    CGFloat labelWidth = PHONE_WIDTH * 0.5;
    CGFloat labeHeight = 40.0f;
    CGFloat labelStartY = 126.0f + 32.0f;
    
    _labelArray = [NSMutableArray array];
    
    NSArray *contents = @[@"总收益",@"排名",@"月收益",@"胜率"];
    NSArray *titles = @[@"--",@"--",@"--",@"--"];
    for (NSInteger i = 0; i < titles.count; i++) {
        CGRect frame = CGRectMake((i%2) * labelWidth, labelStartY + i/2 * labeHeight, labelWidth, labeHeight);
        UILabel *label = [UIKitHelper labelWithFrame:frame Font:k_MIDDLE_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
        [_labelArray addObject:label];
        label.layer.borderWidth = 0.5f;
        label.layer.borderColor = k_LINE_COLOR.CGColor;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        NSString *tempString = [contents[i] stringByAppendingFormat:@"  %@",titles[i]];
        NSRange range = [tempString rangeOfString:titles[i]];
        
        NSDictionary *attributes = @{NSFontAttributeName:k_MIDDLE_TEXT_FONT, NSForegroundColorAttributeName: (i%2?k_BIG_TEXT_COLOR:k_UPPER_COLOR)};
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tempString];
        [attString setAttributes:attributes range:range];
        label.attributedText = attString;
        [self addSubview:label];
    }
    
    //图表
    _chatView = [[UUVirtualTransactionChatView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, UUPersonalHomeHeaderViewHeight - UUVirtualTransactionChatViewHeight - 45.0f, PHONE_WIDTH - 2 * k_LEFT_MARGIN, UUVirtualTransactionChatViewHeight)];
    [self addSubview:_chatView];
    //股票交易详解
    CGFloat buttonWith = 124.0f;
    //股票交易规则
    UIButton *stockDealButton = [UIKitHelper buttonWithFrame:CGRectMake(PHONE_WIDTH - buttonWith - k_LEFT_MARGIN,CGRectGetMaxY(_chatView.frame) ,buttonWith,40.0f) title:@"查看交易分析" titleHexColor:@"474747" font:k_BIG_TEXT_FONT];
    [stockDealButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [stockDealButton setImage:[UIImage imageNamed:@"transaction_jiaoyifenxi"] forState:UIControlStateNormal];
    [stockDealButton setImage:[UIImage imageNamed:@"transaction_jiaoyifenxi_hilighted"] forState:UIControlStateHighlighted];
    [stockDealButton setTitleColor:k_NAVIGATION_BAR_COLOR forState:UIControlStateHighlighted];
    stockDealButton.tag = 5;
    stockDealButton.imageEdgeInsets = UIEdgeInsetsMake(0, -CGRectGetWidth(stockDealButton.frame) * 0.4, 0, 0);
    stockDealButton.titleEdgeInsets = UIEdgeInsetsMake(0, -CGRectGetWidth(stockDealButton.frame) * 0.3, 0, 0);
    stockDealButton.titleLabel.font = k_MIDDLE_TEXT_FONT;
    [self addSubview:stockDealButton];
    UIImage *tempArrowImage = [UIImage imageNamed:@"Stock_list_more"];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:tempArrowImage];
    tempImageView.center = CGPointMake(CGRectGetWidth(stockDealButton.frame) - tempArrowImage.size.width * 0.5, CGRectGetHeight(stockDealButton.frame) * 0.5);
    [stockDealButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [stockDealButton addSubview:tempImageView];
    
    UUPersonalHomeSubView *subView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUPersonalHomeSubView class]) owner:self options:nil] firstObject];
    _subView = subView;
    [self addSubview:subView];

    [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(129);
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
}

#pragma mark - 查看交易分析
- (void)buttonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [_delegate headerView:self didSelectedIndex:0];
    }
}

#pragma mark - 资金信息
- (void)setAssetModel:(UUTransactionAssetModel *)assetModel
{
    if (assetModel == nil || _assetModel == assetModel) {
        return;
    }
    _assetModel = assetModel;
    [self fillAssetData];
}

- (void)fillAssetData
{
    NSArray *contents = @[@"总收益",@"排名",@"月收益",@"胜率"];
    NSArray *titles = @[
                        [NSString stringWithFormat:@"%.2f%%",_assetModel.profitRate*100],
                        
                        [NSString stringWithFormat:@"%.0ld",_assetModel.rank],
                        
                        [NSString stringWithFormat:@"%.2f%%",_assetModel.monthProfit*100],
                        
                        [NSString stringWithFormat:@"%.2f%%",_assetModel.winrate*100],
                        
                        ];
    
    [titles enumerateObjectsUsingBlock:^(NSString  *title, NSUInteger i, BOOL *stop) {
       
        NSString *tempString = [contents[i] stringByAppendingFormat:@"  %@",titles[i]];
        NSRange range = [tempString rangeOfString:titles[i]];
      
        UIColor *color = k_BIG_TEXT_COLOR;
        if (i%2 == 0) {
            if ([title floatValue] > 0) {
                color = k_UPPER_COLOR;
                title = [@"+" stringByAppendingString:title];
            }else if ([title floatValue] < 0){
                color = k_UNDER_COLOR;
            }else{
                color = k_EQUAL_COLOR;
            }
        }
        
        NSDictionary *attributes = @{NSFontAttributeName:k_MIDDLE_TEXT_FONT, NSForegroundColorAttributeName: color};
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tempString];
        [attString setAttributes:attributes range:range];
      
        UILabel *label = [_labelArray objectAtIndex:i];
        label.attributedText = attString;
        [self addSubview:label];
    }];
}

#pragma mark -  用户信息
- (void)setUser:(User *)user
{
    if (user == nil || _user == user) {
        return;
    }
    _user = user;
    _subView.user = user;
}

@end

@implementation UUPersonalHomeSectionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    if (titles == nil || _titles == titles) {
        return;
    }
    _titles = [titles copy];
    
    [self configSubViews];
}

- (void)configSubViews
{
    CGFloat buttonWidth = (CGRectGetWidth(self.bounds) - 2 *k_LEFT_MARGIN) / _titles.count;
    for (NSInteger i = 0; i < _titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame  =CGRectMake(k_LEFT_MARGIN + buttonWidth *i, 0, buttonWidth, CGRectGetHeight(self.bounds));
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = k_MIDDLE_TEXT_COLOR.CGColor;

        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:k_BIG_TEXT_COLOR forState:UIControlStateNormal];
        [button setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        button.titleLabel.font = k_MIDDLE_TEXT_FONT;
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
            _selectedButton = button;
        }
        [self addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)button
{
    self.index = button.tag;
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    if ([_delegate respondsToSelector:@selector(sectionView:didSelectedIndex:)]) {
        [_delegate sectionView:self didSelectedIndex:button.tag];
    }
}
@end
