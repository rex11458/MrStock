//
//  UUDataBaseManager.h
//  StockHelper
//
//  Created by LiuRex on 15/6/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUMarketStructs.h"
@class UUStockModel;
@class UUFavourisStockModel;
@interface UUDatabaseManager : NSObject



+ (UUDatabaseManager *)manager;

//增
- (void)insertStockModel:(UUStockModel *)stockModel;
- (void)insertStockModelArray:(NSArray *)stockModelArray;
//删
- (void)deleteStockModel:(UUStockModel *)stockModel;
//改
- (void)changeStockModel:(UUStockModel *)stockModel1 withStockModel:(UUStockModel *)stockModel2;

//查  根据股票代码或名字查询 买入页面type 传入 1
- (NSArray *)selectStockModelWithCondition:(NSString *)condition type:(NSInteger)type;
//更新本地股票列表
- (void)updateStockModelArray:(NSArray *)stockModelArray;

//根据代码和市场查找股票
- (UUStockModel *)selectStockModelWithCode:(NSString *)code market:(UUMarketDataType)market;

//根据股票名称和代码查找股票
//- (UUStockModel *)selectStockModelWithCode:(NSString *)code name:(NSString *)name;

////打开数据库
//- (void)open;
////关闭数据库
//- (void)close;

@end

@interface UUDatabaseManager (Operation)

//添加自选列表
- (BOOL)addFavourisList:(NSArray *)favourisList;
//添加自选
- (BOOL)addfavouris:(UUFavourisStockModel *)stockModel;

//自选列表
- (void)favoriousList:(void(^)(id obj))success;
//当前用户是否加入了自选
- (UUFavourisStockModel *)isFavouris:(NSString *)code;
//删除自选
- (BOOL)deleteFavouris:(NSString *)code;


//添加或删除 自选
//- (void)favoriousOperation:(UUStockModel *)stockModel;

//股票搜索记录列表
- (NSArray *)stockSearchRecordList;

//添加搜索记录
- (void)addStockSearchRecord:(UUStockModel *)stockModel;
//是否已经在搜索记录中
- (BOOL)isSearchRecord:(NSString *)code;

//清空搜索记录
- (void)removeAllSearchRecord;

@end