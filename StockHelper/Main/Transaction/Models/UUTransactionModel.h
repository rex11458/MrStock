//
//  UUTransactionModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/30.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"
/*
 orderID	String	委托单号
 code	String	股票代码
 name	String	股票名称
 buySell	int	委托类型：0-买 1-卖
 
 */

@protocol UUTransactionModel
@end

@interface UUTransactionModel : JSONModel

@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger buySell;

@end


