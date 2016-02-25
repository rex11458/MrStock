//
//  BaseDataSource.h
//  StockHelper
//
//  Created by LiuRex on 15/8/24.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHandler.h"
@interface BaseDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,copy) NSArray *dataArray;

@property (nonatomic,assign) NSInteger pagesize;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger type;  //0 刷新 ，1 加载更多


- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailueBlock)failure;

@end
