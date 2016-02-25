//
//  UUVirtualTransactionView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#import "UULabelView.h"
#import "UURemindButton.h"

@class UUTransactionAssetModel;
#define UUVirtualTransactionHeaderViewHeight 200.0f
@interface UUVirtualTransactionHeaderView : UIView
{
    UURemindButton *_rankContentButton;
    UIImageView *_arrowImageView;
    UILabel *_rankLabel;            //收益排名
    UULabelView *_totalAssetLabel;  //总资产
    UILabel *_totalMarketValueLabel;//总市值
    UILabel *_useableValueLabel;    //可用金额
    UILabel *_freezeValueLabel;     //冻结金额
    UILabel *_todayProfitLabel;     //今日盈亏
    UILabel *_totalProfitLabel;     //总盈亏
}

@property (nonatomic,strong) UUTransactionAssetModel *assetModel;

@end


#define UUVirtualTransactionChatViewHeight ((PHONE_WIDTH - 2 * k_LEFT_MARGIN) * 0.65)
@interface UUVirtualTransactionChatView : UIView
{
    NSMutableArray *_pointArray;
    
    CGFloat _maxValue;
    CGFloat _minValue;
    
    
    UILabel *_leftMaxLabel;
    UILabel *_leftMaxPaddingLabel;
    UILabel *_leftMiddelLabel;
    UILabel *_leftMinPaddingLabel;
    UILabel *_leftMinLabel;
    
    CAShapeLayer *_circleLayer;
    UIBezierPath *_path;
    UIButton *_profitRateLabel;
    UILabel *_dateLabel;
    
    //底部日期显示
    UILabel *_bottomStartDateLabel;
    UILabel *_bottomEndDateLabel;
}
@property (nonatomic,copy) NSArray *profitArray;

@end

@protocol UUVirtualTransactionViewDelegate;

@interface UUVirtualTransactionView : UIScrollView
{
    UUVirtualTransactionHeaderView *_headerView;
        
}

@property (nonatomic,strong) UUVirtualTransactionChatView *chatView;

@property (nonatomic,strong) UUTransactionAssetModel *assetModel;

@property (nonatomic,assign) id<UUVirtualTransactionViewDelegate> transactionDelegate;

@end

@protocol UUVirtualTransactionViewDelegate <NSObject>

@optional
/*
 *0买入   1卖出  2撤单 3持仓  4查询 5查看交易分析 6股票交易规则详解
 */
- (void)transactionView:(UUVirtualTransactionView *)transactionView didSelectedIndex:(NSInteger)index;

@end
