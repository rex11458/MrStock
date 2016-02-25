//
//  UUDataBaseManager.m
//  StockHelper
//
//  Created by LiuRex on 15/6/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUDatabaseManager.h"
#import "UUStockModel.h"
#import "UUFavourisStockModel.h"
#import <FMDB/FMDB.h>
#define kDatabaseName @"stock.db"
static UUDatabaseManager *shared = nil;

@interface UUDatabaseManager ()


@property (nonatomic,strong) FMDatabase *fmdb;

@property (nonatomic,strong) FMDatabaseQueue *queue;
@end

@implementation UUDatabaseManager

+ (UUDatabaseManager *)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if (self = [super init]) {
        
        [self createDB];
        _queue = [FMDatabaseQueue databaseQueueWithPath:[self filePath]];
    }
    return self;
}

- (NSString *)filePath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",kDatabaseName];
}

-(void)createDB
{
//    
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSString *dbPath = [self filePath];
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"stock" ofType:@"db"];
//
//    //没存在则拷贝到document
//    if (![manager fileExistsAtPath:dbPath]) {
//        if ([manager copyItemAtPath:bundlePath toPath:dbPath error:nil]) {
//            DLog(@"copy ok...");
//        }
//        else
//        {
//            DLog(@"copy error...");
//        }
//    }
    NSString *dbPath = [self filePath];
    _fmdb = [[FMDatabase alloc] initWithPath:dbPath];
    [self createTable];
    NSLog(@"%@",[self filePath]);

}

- (void)createTable
{
    [_fmdb open];
    NSString *sql = @"CREATE TABLE IF NOT EXISTS Stock(code VARCHAR(20),name VARCHAR(20),pinyin VARCHAR(20),market VARCHAR(20),lstMarketDate VARCHAR(20),isFav BOOLEAN,isRecord BOOLEAN)";
    [_fmdb executeUpdate:sql];
    
    sql = @"CREATE TABLE IF NOT EXISTS FavStock(code VARCHAR(20),name VARCHAR(20),market VARCHAR(20),listID VARCHAR(20),userID VARCHAR(40))";
    [_fmdb executeUpdate:sql];
    
    sql = @"CREATE TABLE IF NOT EXISTS SearchRecordStock(code VARCHAR(20),name VARCHAR(20),market VARCHAR(20),isFav BOOLEAN)";
    [_fmdb executeUpdate:sql];
}

//增
- (void)insertStockModel:(UUStockModel *)stockModel
{
    NSString *sql = @"INSERT INTO Stock(code,name,pinyin,market,lstMarketDate,isFav,isRecord) values(?,?,?,?,?,?,?)";
    NSArray *stockInfo = @[stockModel.code,stockModel.name,stockModel.pinyin,@(stockModel.market),stockModel.lstMarktDate,@(stockModel.isFav),@(stockModel.isRecrod)];
    [_fmdb executeUpdate:sql withArgumentsInArray:stockInfo];
}

- (void)insertStockModelArray:(NSArray *)stockModelArray
{
    [_fmdb beginTransaction];
    BOOL isRollBack = NO;
    
    @try {
        for (UUStockModel *stockModel in stockModelArray) {
            
            [self insertStockModel:stockModel];
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [_fmdb rollback];
    }
    @finally {
        if (!isRollBack) {
            [_fmdb commit];
            DLog(@"插入成功");
        }
    }
}
//删
- (void)deleteStockModel:(UUStockModel *)stockModel
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Stock WHERE code=?"];
    NSArray *values = @[stockModel.code];
    [_fmdb executeUpdate:sql withArgumentsInArray:values];
}

//改
- (void)changeStockModel:(UUStockModel *)stockModel1 withStockModel:(UUStockModel *)stockModel2
{
    
}

//查  根据股票代码或名字查询
- (NSArray *)selectStockModelWithCondition:(NSString *)condition type:(NSInteger)type;
{
    NSString *sql = nil;

    if (condition == nil) {
        sql = [NSString stringWithFormat:@"SELECT * FROM Stock limit 20"];
        
    }else
    {
        if (type == 1)
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM Stock WHERE code LIKE '%%%@%%' AND isFav=1  or  pinyin LIKE '%%%@%%' AND isFav=1 limit 20 ",condition,condition];
        }else
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM Stock WHERE code LIKE '%%%@%%' or  pinyin LIKE '%%%@%%' limit 20 ",condition,condition];
        }
    }
    
    FMResultSet * resultSet = [_fmdb executeQuery:sql];

    return [self stockModelArray:resultSet];
}

//更新本地股票列表
- (void)updateStockModelArray:(NSArray *)stockModelArray
{
    [_fmdb open];
    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_queue inDatabase:^(FMDatabase *db) {
            
            //先清空stock表数据
            NSString *sql = @"delete from stock";
            BOOL success = [_fmdb executeUpdate:sql];
            //插入所有数据
            if (success) {
                NSTimeInterval t1 = [[NSDate date] timeIntervalSince1970];
                    [weakSelf insertStockModelArray:stockModelArray];
                NSTimeInterval t2 = [[NSDate date] timeIntervalSince1970];
                DLog(@"耗时：%@",@(t2 - t1));
            }
        }];
//    });
}

//根据代码和市场查找股票
- (UUStockModel *)selectStockModelWithCode:(NSString *)code market:(UUMarketDataType)market
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM stock WHERE code=? AND isFav=?"];
    NSArray *values = [NSArray arrayWithObjects:code,@(market), nil];
    FMResultSet *resultSet = [_fmdb executeQuery:sql withArgumentsInArray:values];
    return [[self stockModelArray:resultSet] firstObject];
}

/*
 *对数据库中搜索到的数据进行处理
 */
- (NSArray *)stockModelArray:(FMResultSet *)resultSet
{
    NSMutableArray *mArray = [NSMutableArray array];
    while ([resultSet next])
    {
        NSString *code = [resultSet objectForColumnIndex:0];
        NSString *name = [resultSet objectForColumnIndex:1];
        NSString *pinyin = [resultSet objectForColumnIndex:2];
        UUMarketDataType market = [[resultSet objectForColumnIndex:3] integerValue];
        NSString *lstMarketDate =  [resultSet objectForColumnIndex:4];
        BOOL isFav = [[resultSet objectForColumnIndex:5] boolValue];
        BOOL isRecord = [[resultSet objectForColumnIndex:6] boolValue];
        
        UUStockModel *stockModel = [[UUStockModel alloc] initWithName:name code:code pinyin:pinyin market:market isFav:isFav isRecord:isRecord];
        stockModel.lstMarktDate = lstMarketDate;
        [mArray addObject:stockModel];
    }
    return [mArray copy];
}

//添加自选列表
- (BOOL)addFavourisList:(NSArray *)favourisList
{
    [self removeAllFavouris];
    [_fmdb beginTransaction];
    BOOL isRollBack = NO;
    BOOL success = NO;
    @try {
        for (UUFavourisStockModel *stockModel in favourisList) {
            [self addfavouris:stockModel];
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [_fmdb rollback];
        success = NO;
    }
    @finally {
        if (!isRollBack) {
            success = YES;
            [_fmdb commit];
            DLog(@"添加自选列表成功");
        }
    }
    return success;
}

- (void)removeAllFavouris
{
    NSString *sql = @"delete from FavStock";
    [_fmdb executeUpdate:sql];
}

- (BOOL)addfavouris:(UUFavourisStockModel *)stockModel
{
    //    sql = @"CREATE TABLE FavStock(id INT AUTO_INCREMENT primary key,code VARCHAR(20), userID TEXT";
    NSString *sql = @"INSERT INTO FavStock(code,name,market,listID,userID) values(?,?,?,?,?)";
    
    
    NSString *userID = [UUserDataManager sharedUserDataManager].user.customerID;
    NSArray *stockInfo = [NSArray arrayWithObjects:stockModel.code,stockModel.name,[@(stockModel.market) stringValue],stockModel.listID,userID, nil];
    return [_fmdb executeUpdate:sql withArgumentsInArray:stockInfo];
}

//删除自选
- (BOOL)deleteFavouris:(NSString *)code
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM FavStock WHERE code=? AND userID=?"];
    NSArray *values = [NSArray arrayWithObjects:code,[UUserDataManager sharedUserDataManager].user.customerID, nil];
   BOOL success = [_fmdb executeUpdate:sql withArgumentsInArray:values];
    
    return success;
}

/*
 *自选列表
 */
- (void)favoriousList:(void(^)(id obj))success
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM FavStock WHERE userID='%@'",[UUserDataManager sharedUserDataManager].user.customerID];
            
                FMResultSet * resultSet = [db executeQuery:sql];
                NSMutableArray *stockModelArray = [NSMutableArray array];
                while ([resultSet next])
                {
                    NSString *code = [resultSet objectForColumnIndex:0];
                    NSString *name = [resultSet objectForColumnIndex:1];
                    NSString *market = [resultSet objectForColumnIndex:2];
                    NSString *listID = [resultSet objectForColumnIndex:3];
                    UUFavourisStockModel *stockModel = [[UUFavourisStockModel alloc] init];
                    stockModel.code = code;
                    stockModel.name = name;
                    stockModel.market = [market integerValue];
                    stockModel.listID = listID;
                    [stockModelArray addObject:stockModel];
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                success(stockModelArray);
            });
        }];
    });
}

//当前用户是否加入了自选
- (UUFavourisStockModel *)isFavouris:(NSString *)code
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM FavStock WHERE userID='%@' AND code='%@'",[UUserDataManager sharedUserDataManager].user.customerID,code];
    
    FMResultSet * resultSet = [_fmdb executeQuery:sql];
    if([resultSet next])
    {
        UUFavourisStockModel *stockModel = [[UUFavourisStockModel alloc] init];

        NSString *code = [resultSet objectForColumnIndex:0];
        NSString *name = [resultSet objectForColumnIndex:1];
        NSString *listID = [resultSet objectForColumnIndex:2];
        stockModel.code = code;
        stockModel.name = name;
        stockModel.listID = listID;
        return stockModel;
    }
    return nil;
}

//////添加或删除 自选
//- (void)favoriousOperation:(UUStockModel *)stockModel
//{
//    BOOL isFav = !stockModel.isFav;
//    NSString *sql = [NSString stringWithFormat:@"UPDATE Stock set isFav=? WHERE code=?"];
//    [_fmdb executeUpdate:sql withArgumentsInArray:@[@(isFav),stockModel.code]];
//}
/*
 *   股票搜索记录列表
 */

- (NSArray *)stockSearchRecordList
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SearchRecordStock"];
    
    FMResultSet * resultSet = [_fmdb executeQuery:sql];
    
    NSMutableArray *stockModelArray = [NSMutableArray array];
    while ([resultSet next])
    {
        NSString *code = [resultSet objectForColumnIndex:0];
        NSString *name = [resultSet objectForColumnIndex:1];
        UUMarketDataType market = [[resultSet objectForColumnIndex:2] integerValue];
        BOOL isFav = [[resultSet objectForColumnIndex:3] boolValue];
        UUStockModel *stockModel = [[UUStockModel alloc] initWithName:name code:code pinyin:@"" market:market isFav:isFav isRecord:@""];
        [stockModelArray addObject:stockModel];
    }
    return [stockModelArray copy];
}

//添加搜索记录
- (void)addStockSearchRecord:(UUStockModel *)stockModel
{
    NSString *sql = @"INSERT INTO SearchRecordStock(code,name,market,isFav) values(?,?,?,?)";
    
    NSArray *stockInfo = [NSArray arrayWithObjects:stockModel.code,stockModel.name,@(stockModel.market),@(stockModel.isFav), nil];
    [_fmdb executeUpdate:sql withArgumentsInArray:stockInfo];
}

//是否已经在搜索记录中
- (BOOL)isSearchRecord:(NSString *)code
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SearchRecordStock WHERE code='%@'",code];
    
    FMResultSet * resultSet = [_fmdb executeQuery:sql];
    
    return [resultSet next];
}

//清空搜索记录
- (void)removeAllSearchRecord
{
    NSString *sql = @"delete from SearchRecordStock";
    [_fmdb executeUpdate:sql];
}

@end

