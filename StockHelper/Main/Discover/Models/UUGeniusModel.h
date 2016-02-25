//
//  UUGeniusModel.h
//  StockHelper
//
//  Created by LiuRex on 15/9/1.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"

/*
 rank	int	排名 
 
 userID	String	用户名
 userName	String	昵称
 userPic	String	头像地址
 
 fans	Long	粉丝数量
 winrate	Double	胜率
 weekProfit	Double	周收益率
 monthProfit	Double	月收益率
 beforeProfit	Double	上期收益率
 retracement	Double	最大回撤率
 
 weekRank	Long	周排名
 monthRank	Long	月排名
 beforeRank	Long	上期排名
 avgTrade	Long	月均交易次数
 avgPosition	Long	平均持仓天数
 position	Double	仓位
 profitLoss	Double	总收益
 profitRate	Double	总收益率
 dayProfitLoss	Double	当日盈亏
 
 */

@protocol UUGeniusModel

@end

@interface UUGeniusModel : JSONModel

@property (nonatomic,assign) NSInteger rank;

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPic;

@property (nonatomic,assign) long fans;
@property (nonatomic,assign) double winrate;
@property (nonatomic,assign) double weekProfit;
@property (nonatomic,assign) double monthProfit;
@property (nonatomic,assign) double beforeProfit;
@property (nonatomic,assign) double retracement;

@property (nonatomic,assign) NSInteger weekRank;
@property (nonatomic,assign) NSInteger monthRank;
@property (nonatomic,assign) NSInteger beforeRank;
@property (nonatomic,assign) NSInteger avgTrade;
@property (nonatomic,assign) NSInteger avgPosition;

@property (nonatomic,assign) double position;
@property (nonatomic,assign) double profitLoss;
@property (nonatomic,assign) double profitRate;
@property (nonatomic,assign) double dayProfitLoss;
@end

@interface UUGeniusListModel : BaseModel

@property (nonatomic, copy) NSArray<UUGeniusModel> *data;


@end