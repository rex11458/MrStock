//
//  UUGeniusRankViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/7/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UUGeniusHighYieldType,  //收益王
    UUGeniusSteadyType,     //稳健王
    UUGeniusExuberantType,  //人气王
} UUGeniusType;

@class UUGeniusModel;

#define UUGeniusRankViewCellHeight 152.0f
@interface UUGeniusRankViewCell : BaseViewCell
{
    UIImageView *_imageView;  //图标
    UIButton *_headImageButton; //  头像
    UILabel *_nameLabel;
    UILabel *_rankLabel;
    
    UIImageView *_leftBGImageView; //左侧背景图
    
    NSArray *_colors;
    NSArray *_imageNames;
    
    
    UIButton *_tradeTypeButton;  //交易类型

    //总收益
    UILabel *_profitLabel;
    UILabel *_profitContentLabel;
    //日收益
    UILabel *_dailyProfitLabel;
    UILabel *_dailyProfitContentLabel;
    //胜率
    UILabel *_earnProfitLabel;
    UILabel *_earnProfitContentLabel;
    //波动率
    UILabel *_undulateLabel;
    UILabel *_undulateContentLabel;
    //仓位
    UILabel *_holdLabel;
    UILabel *_holdContentLabel;
    //月均交易次数
    UILabel *_tradeTimesLabel;
    UILabel *_tradeTimesContentlabel;
    //平均持仓天数
    UILabel *_holdDateLabel;
    UILabel *_holdDateContentLabel;
}

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,strong)UUGeniusModel *geniusModel;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic) UUGeniusType type;

@end
