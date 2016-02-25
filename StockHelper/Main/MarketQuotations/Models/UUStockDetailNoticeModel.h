//
//  UUStockDetailNoticeModel.h
//  StockHelper
//
//  Created by LiuRex on 15/9/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"
/*
 {"data":[{"announmtID":"74773.00000000","announmtTitle":"上海大名城企业股份有限公司关于召开 2015 年第四次临时股东大会的通知","publishDate":"2015-08-12 00:00:00"}],"message":"成功","statusCode":0}
 */

@protocol UUStockDetailNoticeModel

@end

@interface UUStockDetailNoticeModel : JSONModel

@property (nonatomic, copy) NSString *announmtID;
@property (nonatomic, copy) NSString *announmtTitle;
@property (nonatomic, copy) NSString *publishDate;


@end

@interface UUStockDetailNoticeListModel : BaseModel

@property (nonatomic,copy) NSArray<UUStockDetailNoticeModel> *data;

@end