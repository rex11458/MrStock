//
//  UUDiscoverViewCellTableViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUDiscoverViewCellHeight 170.0f

@class UUTradeChanceModel;

@interface UUDiscoverViewCell : BaseViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView; //头像


@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;  //用户名

@property (strong, nonatomic) IBOutlet UILabel *fansLabel;   //粉丝数

@property (strong, nonatomic) IBOutlet UILabel *victoryRate;    //胜率

@property (strong, nonatomic) IBOutlet UILabel *monthProftLabel; //月收益

@property (strong, nonatomic) IBOutlet UILabel *stockNameLabel; //股票名称

@property (strong, nonatomic) IBOutlet UILabel *buyPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *buyDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *holdRateLabel;

@property (strong, nonatomic) IBOutlet UIButton *buyingButton;

- (IBAction)buyingButtonAction:(UIButton *)sender;


@property (nonatomic,assign) id target;

@property (nonatomic)         SEL  stockDetailAction;

@property (nonatomic)         SEL  userDetailAction;

@property (nonatomic)         SEL  buyingAction;

@property (nonatomic,strong) UUTradeChanceModel *tradeChanceModel;

@end
