//
//  UUTransactionDelegateModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/30.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTransactionModel.h"
/*
 amount = 200;
 canceledAmount = 0;
 code = 002600;
 matchedAmount = 0;
 name = "\U6c5f\U7c89\U78c1\U6750";
 orderDate = "2015-07-30";
 orderID = 20150730000001;
 orderTime = "09:48:19";
 price = "7.88";

 
 price	Double	委托价格
 amount	Double	委托数量
 orderDate	String	委托日期 yyyy-MM-dd格式
 orderTime	Double	委托时间 HH:mm:ss格式
 matchedAmount	Double	已成交数量
 canceledAmount	Double	已撤销数量
 */

@protocol UUTransactionDelegateModel 

@end

@interface UUTransactionDelegateModel : UUTransactionModel

@property (nonatomic, copy) NSString *orderDate;

@property (nonatomic, copy) NSString *orderTime;

@property (nonatomic, assign) double price;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *matchedAmount;

@property (nonatomic,copy) NSString *canceledAmount;

@property (nonatomic,assign) NSInteger status;

//@property (nonatomic,assign) NSInteger buySell;

@end


@interface UUTransactionListDelegateModel : BaseModel

@property (nonatomic, copy) NSArray<UUTransactionDelegateModel> *data;

@end
