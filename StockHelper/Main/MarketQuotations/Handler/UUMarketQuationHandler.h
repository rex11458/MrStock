//
//  UUMarketQuationHandler.h
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseHandler.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UUMarketStructs.h"
#import "UUSocketManager.h"

#define removeObserver(obj) if(obj) {\
[[NSNotificationCenter defaultCenter] removeObserver:obj];\
}

@interface UUMarketQuationHandler : BaseHandler
{
    UUSocketManager *_socketManager;
}
+ (UUMarketQuationHandler *)sharedMarkeQuationHandler;

//---------------- TCP ----------------------------

//沪深股票列表
- (id/*NSObserver*/)getStockListSuccess:(SuccessBlock)successBlock failure:(FailueBlock)failureBlock;

/*
 *  股票详情 －－ 自选列表
 */
- (id /*NSObserver*/)getStockDetailWithFavStockModelArray:(NSArray *)codes success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;

/*
 *  五档信息 －－ 个股实时详情
 */
- (id /*NSObserver*/)getStockDetailWithCode:(NSString *)code type:(UUMarketDataType)type  success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;

/**
 *  分时行情
 */
- (id /*NSObserver*/)getStockShareInfoWithCode:(NSString *)code type:(UUMarketDataType)type success:(SuccessBlock)successBlock failure:(FailueBlock)failureBlock;
/**
 *  k线
 * lineType 
    0--1分钟线
    1--5分钟线
    2--15分钟线
    3--30分钟线
    4--60分钟线
    5--120分钟线
    6--日线
    7--周线
    8--月线
    9--季线
 */
- (id /*NSObserver*/)getKLineWithCode:(NSString *)code type:(UUMarketDataType)type lineType:(NSInteger)lineType success:(SuccessBlock)successBlock failure:(FailueBlock)failureBolck;

/*
 *  分价成交
 */
- (id /*NSObserver*/)getCurrentPriceWithCode:(NSString *)code type:(UUMarketDataType)type success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;

/*
 *  财务数据
 */
- (id /*NSObserver*/)getFinancialInfoWithCode:(NSString *)code type:(UUMarketDataType)type success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 *  除权
 */
- (id /*NSObserver*/)exRightsWithCode:(NSString *)code type:(UUMarketDataType)type success:(SuccessBlock)successBlock failure:(FailueBlock)failureBolck;


/*
 *  数据排名
 */
- (id/*<NSObserver>*/)getReportSortSuccess:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *  单个排名
 */
- (id/*<NSObserver>*/)getReportSortWithType:(UUMarketRankType)type count:(NSInteger)count success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 * 根据市场和类型获取排名
 */
- (id/*<NSObjserver>*/)getReportSortWithType:(UUMarketRankType)type marketType:(UUMarketDataType)market count:(NSInteger)count success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 * 板块排名        
 * blockType //板块类型，0--热门行业，1--概念板块
 * count	 //返回数据条数，
 * sortType  //排序类型，0--升序，1--降序
 */
- (id/*<NSObserver>*/)getReportBlockWithType:(short)blockType count:(short)count sortType:(unsigned short)sortType  Success:(SuccessBlock)success failure:(FailueBlock)failure;


//--------------------- HTTP --------------------------------------


//- (void)getStockShareInfoWithUrl:(NSString *)url  success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;
//
/**
 *  K线
 */
- (void)getKLineWithUrl:(NSString *)url  success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;



/*
 *  行情
 */
- (void)getStockQuoteWithUrl:(NSString *)url  success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;


/*
 *  自选列表
 */
- (void)getFavourisStockListSuccess:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;
/*
 *  添加自选股
 */
- (void)addFavourisStockWithCode:(NSString *)code pos:(NSInteger)pos success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;

/*
 *  添加多个自选股
 * codes 股票代码(以逗号分隔，例如：600000,600001,600002)
 */
- (void)addFavourisStockWithCodes:(NSString *)codes pos:(NSInteger)pos success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;

/*
 *  自选股修改顺序
 */
- (void)updatePositionWithListIDA:(NSString *)listIDA listIDB:(NSString *)listIDB success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;

/*
 *  自选股删除
 */
- (void)deleteFavourisStockWithListID:(NSString *)listID success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;
/*
 *  自选股批量删除
 */
- (void)deleteFavourisStockWithListIDArray:(NSArray *)listIDArray success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;

/*
 *  获取公告列表
 */
- (void)getNoticeListWithStockCode:(NSString *)stockCode pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(SuccessBlock)success failure:(FailueBlock)failure;
/*
 *  获取公告详情
 */
- (void)getNoticeDetailWithStockCode:(NSString *)stockCode noticeId:(NSString *)noticeId success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *收到通知数据后统一处理
 */
- (id)dealNotificationDataWithRequest:(const UUCommRequest *)request success:(void(^)(UUCommResponse *))success failure:(void(^)(NSError *))failure;


/*
 *  公司简介
 */
- (void)getCompanyBriefwithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *  分红
 */
- (void)getCompanyCashbtaxrmbWithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *  财务
 */
- (void)getCompanyFinanceWithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 *  股东
 */
- (void)getStockholderWithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 *  总股本
 */
- (void)getTotalStockWithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure;


@end
