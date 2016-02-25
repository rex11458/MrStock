//
//  UUFocusModel.h
//  StockHelper
//
//  Created by LiuRex on 15/8/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "JSONModel.h"

@interface UUFocusModel : JSONModel

@property (nonatomic, copy) NSString *customerID;
@property (nonatomic, copy) NSString *depict;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *nickName;

@end

