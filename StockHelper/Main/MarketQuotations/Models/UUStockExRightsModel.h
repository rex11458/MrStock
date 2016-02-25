//
//  UUStockExchangeModel.h
//  StockHelper
//
//  Created by LiuRex on 15/11/3.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUMarketStructs.h"
/*
 unsigned int		m_time;	     // UCT
 float			m_fGive;	    // 每股送
 float			m_fPei;	       	// 每股配
 float			m_fPeiPrice;	// 配股价,仅当 m_fPei!=0.0f 时有效
 float			m_fProfit;	    // 每股红利

 */

@interface UUStockExRightsModel : NSObject

@property (nonatomic,assign) double m_time;     //Unix时间戳(距离1970年的秒数)
@property (nonatomic,assign) double m_fGive;
@property (nonatomic,assign) double m_fPei;
@property (nonatomic,assign) double m_fPeiPrice;
@property (nonatomic,assign) double m_fProfit;

+ (NSArray *)exRightsModelArrayWithAttribute:(UUCommAttribute *)attribute;


@end
