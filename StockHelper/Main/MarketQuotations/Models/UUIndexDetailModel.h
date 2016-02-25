//
//  UUIndexDetailModel.h
//  StockHelper
//
//  Created by LiuRex on 15/10/14.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUStockModel.h"
@interface UUIndexDetailModel : UUStockModel
{
    int				m_lOpen;				// 今开盘
    int				m_lMaxPrice;			// 最高价
    int				m_lMinPrice;			// 最低价
    int				m_lNewPrice;			// 最新价
    unsigned int		m_lTotal;			// 成交量
    float			m_fAvgPrice;			// 成交金额，使用时需乘以100
    short			m_nRiseCount;			// 上涨家数
    short			m_nFallCount;			// 下跌家数
    int				m_nTotalStock1;		/* 对于综合指数：所有股票 - 指数
                                         对于分类指数：本类股票总数 */
    unsigned int		m_lBuyCount;			// 委买数
    unsigned int		m_lSellCount;			// 委卖数
    short			m_nType;				// 指数种类：0-综合指数 1-A股 2-B股
    short			m_nLead;            	// 领先指标
    short			m_nRiseTrend;       	// 上涨趋势
    short			m_nFallTrend;       	// 下跌趋势
    
    short		    m_nNo2[5];			// 保留
    
    short			m_nTotalStock2;		/* 对于综合指数：A股 + B股
                                         对于分类指数：0 */
    int				m_lADL;				// ADL 指标
    int				m_lNo3[3];			// 保留
    int				m_nHand;				// 每手股数
}

@property (nonatomic, assign) double    openPrice;
@property (nonatomic, assign) double    maxPrice;
@property (nonatomic, assign) double    minPrice;
@property (nonatomic, assign) double    newPrice;
@property (nonatomic, assign) double    preClose;
@property (nonatomic, assign) double    amount;
@property (nonatomic, assign) double    avgPrice;
@property (nonatomic, assign) NSInteger    raiseCount;
@property (nonatomic, assign) NSInteger    fallCount;
@property (nonatomic, assign) int    totalStock1;
@property (nonatomic, assign) double    buyCount;
@property (nonatomic, assign) double    sellCount;

@property (nonatomic, assign) double    lead;
@property (nonatomic, assign) double    riseTrend;
@property (nonatomic, assign) double    fallTrend;
//@property (nonatomic, copy) NSString *m_nNo2;       //???
@property (nonatomic, assign)  short totalStock2;
@property (nonatomic, copy) NSString *ADL;
//@property (nonatomic, copy) NSString *m_nNo3;   ?????
@property (nonatomic, copy) NSString *hand;


+ (UUIndexDetailModel *)indexDetailModelWith:(CommRealTimeData *)timeData;

@end
