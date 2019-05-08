//
//  UUPersonalCenterViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/5/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalCenterViewController.h"
#import "UUTabbar.h"
#import "UULoginViewController.h"
#import "UUPersonalCenterViewCell.h"
#import "UUserDataManager.h"
#import "UIImageView+WebCache.h"
#import "UULoginHandler.h"
#import "UUPersonalSettingViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UUShareView.h"
#import "UUFavourisManagerViewController.h"
#import "UUAttentionListViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UUMeHandler.h"
#import "UUFillPersonalInfoViewController.h"
@interface UUPersonalCenterViewController ()<UUPersonalCenterHeaderViewDelegate,UUShareViewDelegate>
{
    NSArray *_viewControllers;
    NSDictionary *_remaindDic;
}
@end
@implementation UUPersonalCenterViewController

- (void)settingAction
{
    
    if (![UUserDataManager userIsOnLine])
    {
        [self headerView:_headerView didSelectedIndex:0]; //登录
    }
    else
    {
        UUPersonalSettingViewController *settingVC = [[UUPersonalSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UUPersonalCenterItems" ofType:@"plist"];
    _dataArray = [NSArray arrayWithContentsOfFile:path];
    
    
    _viewControllers = @[
@[@"UUFavourisStockViewController",@"UUAttentionViewController",@"UUNotificationViewController"]
                         ];
    [self configSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"我";
    self.tabBarController.navigationItem.titleView = nil;
    UIImage *settingImage = [UIImage imageNamed:@"Me_setting"];
    UIButton *settingButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, settingImage.size.width, settingImage.size.height) title:nil titleHexColor:nil font:nil];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:settingButton];

    self.tabBarController.navigationItem.rightBarButtonItems = @[item1];
    
    [_headerView showWithIsLogging:[UUserDataManager userIsOnLine]];
    
    if ([UUserDataManager userIsOnLine]) {
        [[UUMeHandler sharedMeHandler] isCheckedInSuccess:^(id obj) {
            _headerView.checkInButton.selected  =[obj boolValue];
            _headerView.checkInButton.userInteractionEnabled = ![obj boolValue];
            
        } failure:^(NSString *errorMessage) {
            
        }];
        
        [[UULoginHandler sharedLoginHandler] getUserInfoWithSessionId:[UUserDataManager sharedUserDataManager].user.sessionID success:^(UULoginUser *user) {
            _headerView.user = user;
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
        
        //获取红点提醒
        [[UUMeHandler sharedMeHandler] getRemaindSuccess:^(NSDictionary *dic) {
            
            _remaindDic = dic;
            
            
            [_tableView reloadData];
            
        } failure:^(NSString *errorMessage) {
            
        }];
    }
}

- (void)configSubViews
{
    CGRect frame = CGRectMake(0, 0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = k_BG_COLOR;
    _headerView = [self tableHeaderView];
    _headerView.delegate = self;
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
}


- (UUPersonalCenterHeaderView *)tableHeaderView
{
    UUPersonalCenterHeaderView *headerView = [[UUPersonalCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUPersonalCenterHeaderViewHieght)];
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
    static NSString *cellId = @"UUPersonalCenterViewCell";
    
    UUPersonalCenterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUPersonalCenterViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
    }
    
    if (indexPath.section == 0 && indexPath.row == 1 ) {
        cell.showRemaind = [_remaindDic[@"attentionMessageRed"] boolValue];
    }else if (indexPath.section == 0 && indexPath.row == 2){
        cell.showRemaind = [_remaindDic[@"systemMessageRed"] boolValue];
    }else{
        cell.showRemaind = NO;
    }
    
    cell.dictionary = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUPersonalCenterViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return k_TOP_MARGIN * 0.5;
}

//
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), k_TOP_MARGIN)];
    
    footerView.backgroundColor = tableView.backgroundColor;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        //分享
        UUShareView *shareView = [[UUShareView alloc] initWithFrame:CGRectMake(0,PHONE_HEIGHT - UUShareViewHeight, PHONE_WIDTH, UUShareViewHeight)];
        shareView.delegate = self;
        
        [shareView show];
    }
    else
    {
        if ([UUserDataManager userIsOnLine]) {
            UIViewController *vc = [[NSClassFromString(_viewControllers[indexPath.section][indexPath.row]) alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:0 success:^{
                
            } failed:^{
                
            }];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

#pragma mark - UUShareViewDelegate
- (void)shareView:(UUShareView *)shareView shareWithType:(ShareType)shareType
{
    if (shareType == ShareTypeSinaWeibo) {
        [self shareToSinaWeiBo];
    }else
    {
        
        [self shareMessage:shareType];   
    }
}
#define SHARE_ICON_URL @""
-(void)shareMessage:(ShareType)shareType
{
    id<ISSCAttachment> imageAttach = [ShareSDK imageWithUrl:SHARE_ICON_URL];
    
    id<ISSContent> contentObj = [ShareSDK content:@"仅供测试。。。"
                                   defaultContent:@"defaultContnt"
                                            image:imageAttach
                                            title:@"跟牛人买牛股,找股先生！"
                                              url:@"http://www.66aicai.com"
                                      description:@"仅供测试。。。"
                                        mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:contentObj
                      type:shareType
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSResponseStateSuccess) {
                        
                            [self sharedStatusAlert:@"提示" msg:@"分享成功"];
                        }
                    }];
}

- (void)sharedStatusAlert:(NSString *)strTitle msg:(NSString *)strMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)shareToSinaWeiBo
{
    id<ISSCAttachment> imageAttach = [ShareSDK imageWithUrl:SHARE_ICON_URL];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"海量基金任你选,牛市机遇不踏空;投资达人来助力,交易决策不再愁http://www.66toutou.com/download.html"
                                       defaultContent:@"defaultContnt"
                                                image:imageAttach
                                                title:@"我在投投买基金,找达人"
                                                  url:@"http://toutougonghui.com/"
                                          description:@"description"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //构建授权内容
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [authOptions setPowerByHidden:YES];
    
    //分享项目集合
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, nil];
    
    
    //一键分享
    [ShareSDK oneKeyShareContent:publishContent
                       shareList:shareList
                     authOptions:authOptions
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSResponseStateSuccess) {
                                  [self sharedStatusAlert:@"提示" msg:@"分享成功"];
                              }
                              //                                  if (state == SSResponseStateFail) {
                              //                                      [self sharedStatusAlert:@"提示" msg:@"分享失败"];
                              //                                  }
                              //                                  if (state == SSResponseStateCancel) {
                              //                                      [self sharedStatusAlert:@"提示" msg:@"分享取消"];
                              //                                  }
                          }];
    
    
}


#pragma mark - UUPersonalCenterHeaderViewDelegate

- (void)headerView:(UUPersonalCenterHeaderView *)heaaderView didSelectedIndex:(NSInteger)index
{
    if (![UUserDataManager userIsOnLine]) {
        NSInteger index = self.navigationController.viewControllers.count - 1;
        //登录
        if (![UUserDataManager userIsOnLine]) {
            UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:index success:^{
                
            } failed:^{
                
            }];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        return;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

@end


@implementation UUPersonalCenterHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor purpleColor];
        self.defaultImageFrame = frame;
        [self configSubView];
    }
    return self;
}

- (void)configSubView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"Me_bg"];
    [self addSubview:bgImageView];
    _bgImageView = bgImageView;
    CGFloat topMargin = 3 * k_TOP_MARGIN;
//    CGFloat imageWidth = 94.0f;
    UIImage *image = [UIImage imageNamed:@"Me_default_icon"];
    _headerImageView = [[UIImageView alloc] initWithImage:image];
    _headerImageView.userInteractionEnabled = YES;
    _headerImageView.layer.cornerRadius = CGRectGetWidth(_headerImageView.frame) * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.2].CGColor;
    _headerImageView.layer.borderWidth = 1.0f;
    _headerImageView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, topMargin + image.size.height * 0.5);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageAction:)];
    [_headerImageView addGestureRecognizer:tapGes];
    [self addSubview:_headerImageView];
    //92 * 63  46 31.5f
    //签到
    _checkInButton = [UIButton buttonWithType:UIButtonTypeCustom];
   UIImage *checkInImage = [UIImage imageNamed:@"me_check_in"];
    UIImage *checkedInImage = [UIImage imageNamed:@"me_checked_in"];
    [_checkInButton setImage:checkInImage forState:UIControlStateNormal];
    [_checkInButton setImage:checkedInImage forState:UIControlStateSelected];
    _checkInButton.hidden = YES;
    _checkInButton.tag = 1;
    [_checkInButton addTarget:self action:@selector(checkInAction:) forControlEvents:UIControlEventTouchUpInside];
    _checkInButton.frame = CGRectMake(CGRectGetMidX(self.bounds) + image.size.width * 0.5 + k_LEFT_MARGIN * 2, _headerImageView.center.y - checkInImage.size.height * 0.5, checkInImage.size.width, checkInImage.size.height);
    [self addSubview:_checkInButton];
    
    _nameLabel = [UIKitHelper labelWithFrame:CGRectMake(0, 0,CGRectGetWidth(_headerImageView.frame) * 2, 20.0f) Font:[UIFont systemFontOfSize:16.0f] textColor:[UIColor whiteColor]];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5,CGRectGetMaxY(_headerImageView.frame) + k_TOP_MARGIN + 10.0f);
    
    _nameLabel.text = @"登录";
    [self addSubview:_nameLabel];
    
    CGFloat labelHeight = 40.0f;
    CGFloat labelWidth = CGRectGetWidth(self.bounds) / 3.0f;
    //经验值
    _experienceLabel = [[UULabelView alloc] initWithFrame:CGRectMake(0, UUPersonalCenterHeaderViewHieght - k_BOTTOM_MARGIN - labelHeight, labelWidth, labelHeight)];
    _experienceLabel.upperAttributes = @{NSFontAttributeName:k_BIG_TEXT_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]};
    _experienceLabel.underAttributes = @{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]};
    _experienceLabel.underText = @"积分";
    _experienceLabel.upperText = @"0";
//    [self addSubview:_experienceLabel];
    //粉丝数
    _fansCountLabel = [[UULabelView alloc] initWithFrame:CGRectMake(labelWidth, UUPersonalCenterHeaderViewHieght - k_BOTTOM_MARGIN - labelHeight, labelWidth, labelHeight)];
    _fansCountLabel.upperAttributes = @{NSFontAttributeName:k_BIG_TEXT_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]};
    _fansCountLabel.underAttributes = @{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]};
    _fansCountLabel.underText = @"粉丝数";
    _fansCountLabel.upperText = @"0";
    _fansCountLabel.tag = 2;
    [_fansCountLabel addTarget:self action:@selector(fansCountAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_fansCountLabel];
    //关注
    //经验值
    _attentionCountLabel = [[UULabelView alloc] initWithFrame:CGRectMake(labelWidth * 2, UUPersonalCenterHeaderViewHieght - k_BOTTOM_MARGIN - labelHeight, labelWidth, labelHeight)];
    _attentionCountLabel.upperAttributes = @{NSFontAttributeName:k_BIG_TEXT_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]};
    _attentionCountLabel.underAttributes = @{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]};
    _attentionCountLabel.underText = @"关注";
    _attentionCountLabel.upperText = @"0";
    _attentionCountLabel.tag = 3;
    [_attentionCountLabel addTarget:self action:@selector(fansCountAction:) forControlEvents:UIControlEventTouchUpInside];

//    [self addSubview:_attentionCountLabel];
    
    //提醒
    _fansCountRemindView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Me_fans_remaind"]];
    _fansCountRemindView.hidden = YES;
    _fansCountRemindView.center = CGPointMake(CGRectGetMidX(_fansCountLabel.frame) + 20, CGRectGetMinY(_fansCountLabel.frame));
    [self addSubview:_fansCountRemindView];

}

//
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    if (offset.y < 0)
    {
        CGFloat delta = 0.0f;
        CGRect rect = self.defaultImageFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.origin.x -= delta * 0.5;
        rect.size.height += delta;
        rect.size.width += delta;
        _bgImageView.frame = rect;
        
//        if (delta != 0) {
//            _headerImageView.alpha = 1 / delta;
//            _nameLabel.alpha = 1 / delta;
//        }
    }
}


- (void)setUser:(UULoginUser *)user
{
    if (user == nil || _user == user) {
        return ;
    }
    _user = user;
    
    [self fillData];
}

- (void)fillData
{
    _experienceLabel.upperText = [_user.scores stringValue];
    _fansCountLabel.upperText = [_user.fansCount stringValue];
    _attentionCountLabel.upperText = [_user.followCount stringValue];

    _nameLabel.text = _user.nickName;
//    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_user.headImg]];
    _headerImageView.image = [UIImage imageNamed:@"Me_default_icon"];

//
//    //显示小红点
    _fansCountRemindView.hidden = [_user.fansCount integerValue] == [[UUserDataManager sharedUserDataManager].user.fansCount integerValue];

}

- (void)showWithIsLogging:(BOOL)isLogging
{
//    _checkInButton.hidden = !isLogging;
    if (isLogging)
    {
        UULoginUser *user = [UUserDataManager sharedUserDataManager].user;
//        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:user.headImg] placeholderImage:[UIImage imageNamed:@"Me_default_icon"]];
        _headerImageView.image = [UIImage imageNamed:@"Me_default_icon"];
        _nameLabel.text = user.nickName;
    }
    else
    {
        _experienceLabel.upperText = @"0";
        _fansCountLabel.upperText = @"0";
        _fansCountRemindView.hidden = YES;
        _attentionCountLabel.upperText = @"0";
        _nameLabel.text = @"登录";
        _headerImageView.image = [UIImage imageNamed:@"Me_default_icon"];
    }
}

#pragma mark - 签到
- (void)checkInAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [_delegate headerView:self didSelectedIndex:button.tag];//点击头像
    }
}

#pragma mark - 点击头像
- (void)headerImageAction:(UIGestureRecognizer *)ges
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [_delegate headerView:self didSelectedIndex:0];//点击头像
    }
}

#pragma mark - 粉丝数
- (void)fansCountAction:(UULabelView *)labelView
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [_delegate headerView:self didSelectedIndex:labelView.tag];//点击头像
    }
}



@end
