//
//  BaseModel.h
//  StockHelper
//
//  Created by LiuRex on 15/5/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "JSONModel.h"
@interface BaseModel : JSONModel


@property (nonatomic, copy) NSString<Optional> *message;
@property (nonatomic, assign) NSString<Optional> *statusCode;

@end
