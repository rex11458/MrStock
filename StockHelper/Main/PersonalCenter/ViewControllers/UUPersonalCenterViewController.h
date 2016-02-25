//
//  UUPersonalCenterViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/5/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UULabelView.h"
#define UUPersonalCenterHeaderViewHieght 200.0f
@class UUPersonalCenterHeaderView;

@protocol UUPersonalCenterHeaderViewDelegate ;

@interface UUPersonalCenterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    UUPersonalCenterHeaderView *_headerView;
}
@end


@interface UUPersonalCenterHeaderView : UIView
{
    UIImageView *_bgImageView;
    
    UIImageView *_headerImageView;      //头像
    UIButton    *_checkInButton;        //签到
    UILabel     *_nameLabel;            //昵称
    UULabelView     *_experienceLabel;       //经验值
    UULabelView     *_fansCountLabel;       //粉丝
    UULabelView     *_attentionCountLabel;  //关注数
    UIImageView *_fansCountRemindView;
}

@property (nonatomic,strong) UIButton *checkInButton;

@property (nonatomic,assign) CGRect defaultImageFrame;

@property (nonatomic,weak) id<UUPersonalCenterHeaderViewDelegate> delegate;

@property (nonatomic,strong) UULoginUser *user;

- (void)showWithIsLogging:(BOOL)isLogging;

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;

@end


@protocol UUPersonalCenterHeaderViewDelegate <NSObject>

@optional
/*
  *index  0登录 1签到 2粉丝列表  3关注列表
 */
- (void)headerView:(UUPersonalCenterHeaderView *)heaaderView didSelectedIndex:(NSInteger)index;

@end