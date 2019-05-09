//
//  UUMarketQuationHandler.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUMarketQuationHandler.h"
#import "UUNetworkClient.h"
#import "UUStockTimeEntity.h"
#import "UUFavourisStockModel.h"
#import "UUKLineModel.h"
#import "UUStockModel.h"
#import "UUStockDetailModel.h"
#import "UUStockCurrentPriceModel.h"
#import "UUStockDetailNoticeModel.h"
#import "UUCommStruct.h.h"
#import "UUIndexDetailModel.h"
#import "UUReportSortStockModel.h"
#import "UUStockFinancialModel.h"
#import "UUStockExRightsModel.h"
#import "UUStockBlockModel.h"
char cIndentifier = 0x0;


@implementation UUMarketQuationHandler

static UUMarketQuationHandler *shared = nil;
+ (UUMarketQuationHandler *)sharedMarkeQuationHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init
{
    if (self = [super init]) {
        _socketManager = [UUSocketManager manager];
    }
    return self;
}


//沪深股票列表
- (id/*NSObserver*/)getStockListSuccess:(SuccessBlock)successBlock failure:(FailueBlock)failureBlock
{
    UUCommRequest *request = UUMarket_StockListRequest();
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];

    [_socketManager.socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];

    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *respose) {
        
        UUCommAttribute *attribute = (UUCommAttribute *)respose->cAttributes;
        NSArray *dataArray = [UUStockModel stockModelArrayWithAtributes:attribute];
        successBlock(dataArray);
        
    } failure:^(NSError *error) {
        failureBlock(error.domain);
    }];
    
}

/*
 *自选列表股票详情
 */
- (id /*NSObserver*/)getStockDetailWithFavStockModelArray:(NSArray *)codes success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
 
    UUCommRequest *request = UUMarket_FavouriteStockListRequest(codes);
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];

    [_socketManager.socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];

    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *response) {
        
        //数据填充
        UUCommAttribute *m_attribute = (UUCommAttribute*)response->cAttributes;
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (int offset = 0; offset < m_attribute->length; ) {
            CommRealTimeData *timeData = (CommRealTimeData *)(m_attribute->cAttribute + offset);
            
            UUStockModel *stockModel = [UUStockModel stockModelWithRealData:timeData];
            [dataArray addObject:stockModel];
            
            if ([stockModel isMemberOfClass:[UUIndexDetailModel class]]) {
                
                offset += sizeof(CommRealTimeData) - 1 + sizeof(UUIndexRealTime);
                
            }else if ([stockModel isMemberOfClass:[UUStockDetailModel class]]){
                
                offset += sizeof(CommRealTimeData) - 1 + sizeof(UUStockRealTime);
            }
        }
        successBlock(dataArray);
    } failure:^(NSError *error) {
        
        failueBlock(error.domain);
    }];
}

/*
 *  五档信息
 */
- (id /*NSObserver*/)getStockDetailWithCode:(NSString *)code type:(UUMarketDataType)type  success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;
{
    UUCommRequest *request = UUMarket_StockDetailRequest(code, type);

    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];
    
    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];
    //收到数据
      return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *respose) {
          //数据填充
          UUCommAttribute *m_attribute = (UUCommAttribute*)respose->cAttributes;
          CommRealTimeData *timeData = (CommRealTimeData *)m_attribute->cAttribute;
          UUStockModel *stockModel = [UUStockModel stockModelWithRealData:timeData];
          successBlock(stockModel);
          
      } failure:^(NSError *error) {
          failueBlock(error.domain);
      }];
}

/**
 *  分时行情
 */
- (id /*NSObserver*/)getStockShareInfoWithCode:(NSString *)code type:(UUMarketDataType)type success:(SuccessBlock)successBlock failure:(FailueBlock)failureBlock
{
    UUCommRequest *request = UUMarket_ShareTimeRequest(code, type);

    
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];

    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];
    
    
    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *response) {
    
        UUCommAttribute *attribute = (UUCommAttribute *)response->cAttributes;
        UUComTrendData *trendData = (UUComTrendData *)attribute->cAttribute;
        
        //
        double preClose =trendData->m_othData.m_lPreClose / 1000.0f;
        
        NSArray *timeEntityArray = [UUStockTimeEntity stockTimeArrayWithTrendData:trendData];
        
        UUStockQuoteEntity *quoteEntity = [UUStockQuoteEntity stockQuoteEntityWithTimeArray:timeEntityArray preClose:preClose date:nil];
        
        successBlock(quoteEntity);
        
    } failure:^(NSError *error) {
        
        successBlock(error.domain);
    
    }];
}

/**
 *  k线
 * lineType
 0-5分钟线
 1--5分钟线
 2-55分钟线
 3--30分钟线
 4--60分钟线
 5-520分钟线
 6--日线
 7--周线
 8--月线
 9--季线
 */
- (id /*NSObserver*/)getKLineWithCode:(NSString *)code type:(UUMarketDataType)type lineType:(NSInteger)lineType success:(SuccessBlock)successBlock failure:(FailueBlock)failureBolck
{

    UUCommRequest *request = UUMarket_KLineRequest(code, type, lineType);
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];

    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];
    
    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *response) {
        UUCommAttribute *attribute = (UUCommAttribute *)response->cAttributes;
        
        NSArray *lineModelArray = [UUKLineModel kLineModelArrayWithAtribute:attribute];
        
        successBlock(lineModelArray);

    } failure:^(NSError *error) {
        failureBolck(error.domain);
    }];
}

/*
 *  分价成交
 */
- (id /*NSObserver*/)getCurrentPriceWithCode:(NSString *)code type:(UUMarketDataType)type success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock;
{
    UUCommRequest *request = UUMarket_ShareTimeRequest(code, type);
  
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];

    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];

    
    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *response) {
     
        UUCommAttribute *attribute = (UUCommAttribute *)response->cAttributes;
        
        NSArray *dataArray = [UUStockTimeEntity stockTimeArrayWithAttribute:attribute];
        
        successBlock(dataArray);

    } failure:^(NSError *error) {
        failueBlock(error.domain);
    }];
}


/*
 *  财务数据
 */
- (id /*NSObserver*/)getFinancialInfoWithCode:(NSString *)code type:(UUMarketDataType)type success:(SuccessBlock)success failure:(FailueBlock)failure
{
    UUCommRequest *request = UUMarket_FinancialInfoRequest(code, type);
    
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];
    
    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];
    
    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *response) {
       
        UUCommAttribute *attribute = (UUCommAttribute *)response->cAttributes;
        
        UUCommCaiwuData *caiwu = (UUCommCaiwuData *)attribute->cAttribute;
        
        StructCaiwuData *s_caiwu = &caiwu->data;
        
        UUStockFinancialModel *financialModel = [[UUStockFinancialModel alloc] initWithFinancailData:s_caiwu];
        
        success(financialModel);
        
    } failure:^(NSError *error) {
        failure(error.domain);
    }];
}

/*
 *  除权
 */
- (id /*NSObserver*/)exRightsWithCode:(NSString *)code type:(UUMarketDataType)type success:(SuccessBlock)successBlock failure:(FailueBlock)failureBolck
{
    
    UUCommRequest *request = UUMarket_StockExRightsRequest(code, type);
    
    //----
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];

    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];
    
    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *response) {
        UUCommAttribute *attribute = (UUCommAttribute *)response->cAttributes;
        
        NSArray *dataArray = [UUStockExRightsModel exRightsModelArrayWithAttribute:attribute];
        
        successBlock(dataArray);

    } failure:^(NSError *error) {
        failureBolck(error.domain);
    }];
}

/*
 *  数据排名
 */
- (id/*<NSObserver>*/)getReportSortSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    return [self getReportSortWithType:(UUIncreaseRateType | UUDecreaseRateType | UUAmplitudeRateType | UUExchangeRateType) count:5 success:success failure:failure];
}

/*
 *  单个排名
 */
- (id/*<NSObserver>*/)getReportSortWithType:(UUMarketRankType)type count:(NSInteger)count success:(SuccessBlock)success failure:(FailueBlock)failure;
{
    UUCommRequest *request = UUMarket_ReportSortRequest(type, count);
    //----
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];
    
    
    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];
    
    NSMutableData *totalData = [NSMutableData data];
    return [[NSNotificationCenter defaultCenter] addObserverForName:SocketdidReceivedDataNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSData *data = (NSData *)note.object;
        [totalData appendData:data];
        UUCommResponse *temp_response = (UUCommResponse *)totalData.bytes;
        
        if (temp_response->head.cIdentifier != request->head.cIdentifier) {
            [totalData setLength:0];
            failure(nil);
            return ;
        }
        
        int len = temp_response->head.nLength;

        
        if (type != (UUIncreaseRateType | UUDecreaseRateType | UUAmplitudeRateType | UUExchangeRateType))
        {
            if (totalData.length < len) return ;
            
            UUCommResponse *m_response = (UUCommResponse *)[totalData subdataWithRange:NSMakeRange(0, len)].bytes;
            
            if (UUMarket_VaildRespose(m_response, request->head.cIdentifier)) {
                NSArray *dataArray = [UUReportSortStockModel reportSortStockModelArrayWithAttribute:(UUCommAttribute *)m_response->cAttributes];
                
                success(dataArray);
                [totalData setLength:0];
            }else{
                failure(nil);
            }
        }
        else
        {
            UUCommResponse *temp_response = (UUCommResponse *)totalData.bytes;
            
            int len = temp_response->head.nLength;
            if (totalData.length < (len * 4)) return ;
            
            NSMutableArray *totalDataArray = [NSMutableArray array];
            NSData *tempData = [totalData subdataWithRange:NSMakeRange(0, len * 4)];
            
            for (int i = 0; i < 4; i++) {
                NSData *subData = [tempData subdataWithRange:NSMakeRange(len * i, len)];
                
                UUCommResponse *m_response = (UUCommResponse *)subData.bytes;
                
                NSArray *dataArray = [UUReportSortStockModel reportSortStockModelArrayWithAttribute:(UUCommAttribute *)m_response->cAttributes];
                [totalDataArray addObject:dataArray];
            }
            success(totalDataArray);
        }
    }];
}

/*
 * 根据市场和类型获取排名
 */
- (id/*<NSObjserver>*/)getReportSortWithType:(UUMarketRankType)type marketType:(UUMarketDataType)market count:(NSInteger)count success:(SuccessBlock)success failure:(FailueBlock)failure
{
    UUCommRequest *request = UUMarket_ReportSortRequest_2(type, market, count);
    //----
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];
    
    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];

    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *response) {
    
        NSArray *dataArray = [UUReportSortStockModel reportSortStockModelArrayWithAttribute:(UUCommAttribute *)response->cAttributes];
        success(dataArray);
    
    } failure:^(NSError *error) {
        failure(error.domain);
    }];
}


/*
 * 板块排名
 */
- (id/*<NSObserver>*/)getReportBlockWithType:(short)blockType count:(short)count sortType:(unsigned short)sortType  Success:(SuccessBlock)success failure:(FailueBlock)failure
{
 
   UUCommRequest *request = UUMarket_ReportBlockRequest(blockType, sortType, count);
    
    NSMutableData *m_data = [NSMutableData dataWithBytes:request length:request->head.nLength];
    
    [[UUSocketManager manager].socket writeData:m_data withTimeout:5 tag:request->head.cIdentifier];
    
    return [self dealNotificationDataWithRequest:request success:^(UUCommResponse *response) {
        
        UUCommAttribute *attribute = (UUCommAttribute *)response->cAttributes;
        
        UUResReportBlock *blockSort = (UUResReportBlock *)attribute->cAttribute;

        NSArray *dataArray = [UUStockBlockModel blockModelArrayWithReportBlock:blockSort];
        success(dataArray);
    } failure:^(NSError *error) {
        failure(error.domain);
    }];
}

//*-----------------------------*/
- (void)getKLineWithUrl:(NSString *)url success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestGETMethod url:url parameters:nil isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }
        else if (![results isNull])
        {
            NSArray *kLineModels =  [UUKLineModel kLineModelArrayWithData:results];

            successBlock (kLineModels);
        }
    }];
}

- (void)getStockShareInfoWithUrl:(NSString *)url  success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:nil isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }
        if (![results isNull])
        {
           
            NSArray *timeArray = [UUStockTimeEntity stockTimeArrayWithData:results];
            successBlock (timeArray);
            //            UUStockShareModelArray *stockModelArray = [[UUStockShareModelArray alloc] initWithData:results error:nil];
//            successBlock(stockModelArray);
        }
    }];
}

/*
 *股票行情
 */
- (void)getStockQuoteWithUrl:(NSString *)url  success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:nil isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }else if (![results isNull])
        {
//            UUStockQuoteEntity *quoteEntity = [UUStockQuoteEntity stockQuoteEntityWithData:results];
//            successBlock(quoteEntity);
        }
    }];
}

/*
 *自选列表
 */
- (void)getFavourisStockListSuccess:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    NSString *url = k_FAVOURIS_STOCK_LIST_URL;
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:[self baseParameters:@{}] isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }
        if (results != nil)
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            DLog(@"自选列表－－－%@",returnDic);
            
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                
                NSArray *dataArray = [UUFavourisStockModel favourisStockModelWithJsonArray:returnDic[@"data"]];
                
                successBlock(dataArray);
            }else{
                failueBlock(results[@"message"]);
            }
        }
    }];
}

/*
 *添加自选股
 */
- (void)addFavourisStockWithCode:(NSString *)code pos:(NSInteger)pos success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    NSString *url = k_ADD_FAVOURIS_URL;
    NSDictionary *params = [self baseParameters:k_ADD_FAVOURIS_BODY(code, @(pos))];
    NSLog(@"params = %@",params);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"添加自选－－－ %@",returnDic);
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                successBlock([returnDic[@"data"] stringValue]);
            }else{
                failueBlock(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  添加多个自选股
 * codes 股票代码(以逗号分隔，例如：600000,600001,600002)
 */
- (void)addFavourisStockWithCodes:(NSString *)codes pos:(NSInteger)pos success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    NSString *url = k_ADD_FAVOURISES_URL;
    NSDictionary *params = [self baseParameters:k_ADD_FAVOURISES_BODY(codes)];
    NSLog(@"params = %@",params);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"添加自选－－－ %@",returnDic);
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                successBlock(returnDic[@"data"]);
            }else{
                failueBlock(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  自选股修改顺序
 */
- (void)updatePositionWithListIDA:(NSString *)listIDA listIDB:(NSString *)listIDB success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    NSString *url = k_UPDATE_POSITION_URL;
    NSDictionary *params = [self baseParameters:k_UPDATE_POSITION_BODY(listIDA, listIDB)];
    NSLog(@"params = %@",params);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failueBlock(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failueBlock(NETWORK_ERROR_MESSAGE);
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"修改顺序－－－ %@",returnDic);
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                successBlock(returnDic[@"message"]);
            }else{
                failueBlock(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  自选股删除
 */
- (void)deleteFavourisStockWithListID:(NSString *)listID success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    NSString *url = k_DELETE_FAVOURIS_URL;
    NSDictionary *params = [self baseParameters:k_DELETE_FAVOURIS_BODY(listID)];
    NSLog(@"params = %@",params);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"自选股删除－－－ %@",returnDic);
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                successBlock(returnDic[@"message"]);
            }else{
                failueBlock(returnDic[@"message"]);
            }
        }
    }];
}

/*
 * 自选股批量删除
 */
- (void)deleteFavourisStockWithListIDArray:(NSArray *)listIDArray success:(SuccessBlock)successBlock failue:(FailueBlock)failueBlock
{
    NSString *url = k_DELETE_FAVOURIS_URL;
    NSMutableString *listID = [@"" mutableCopy];

    if (listIDArray.count > 0)
    {
        [listIDArray enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            [listID appendString:[n stringValue]];
            if (idx != listIDArray.count - 1) {
                [listID appendString:@","];
            }
        }];
    }

    NSDictionary *params = [self baseParameters:k_DELETE_FAVOURIS_BODY(listID)];
    NSLog(@"params = %@",params);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failueBlock(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failueBlock(NETWORK_ERROR_MESSAGE);

        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"批量删除－－－ %@",returnDic);
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                successBlock(returnDic[@"message"]);
            }else{

                failueBlock(returnDic[@"message"]);
            
            }
        }
    }];
}

/*
 *获取公告列表
 */
- (void)getNoticeListWithStockCode:(NSString *)stockCode pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *url = k_COMPANY_NOTICE_LIST_URL(stockCode, pageIndex, pageSize);

    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestGETMethod url:url parameters:nil isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
            
        }else if (![results isNull])
        {
            UUStockDetailNoticeListModel *listModel = [[UUStockDetailNoticeListModel alloc] initWithData:results error:nil];
            success(listModel.data);
        }
    }];
}

/*
 *获取公告详情
 */
- (void)getNoticeDetailWithStockCode:(NSString *)stockCode noticeId:(NSString *)noticeId success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *url = k_COMPANY_NOTICE_DETAIL_URL(stockCode, noticeId);

    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestGETMethod url:url parameters:nil isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
            
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"公告详情－－－ %@",returnDic);
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                success(returnDic[@"message"]);
            }else{
                failure(returnDic[@"message"]);
            }
        }
    }];
}


/*
 *  公司简介
 */
- (void)getCompanyBriefwithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *url = k_COMPANY_INFOR_URL;
    
    if (stockCode == nil) {
        failure(@"股票代码不能为空");
        return;
    }
    NSDictionary *params = k_COMPANY_INFOR_BODY(stockCode);
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
            
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            
            
            if ([returnDic[@"data"] isKindOfClass:[NSArray class]]) {
                
                NSArray *arr = returnDic[@"data"];
                if (arr.count > 0) {
                    success(returnDic[@"data"][0]);
                }
            }
        }
    }];
}


/*
 *  分红
 */
- (void)getCompanyCashbtaxrmbWithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *url = k_Cashbtaxrmb_URL;
    
    if (stockCode == nil) {
        failure(@"股票代码不能为空");
        return;
    }
    NSDictionary *params = k_Cashbtaxrmb_BODY(stockCode);
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
            
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            
            success(returnDic[@"data"]);
        }
    }];
}

/*
 *  财务
 */
- (void)getCompanyFinanceWithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *url = k_COMMANY_FINANCE_RUL;
    
    if (stockCode == nil) {
        failure(@"股票代码不能为空");
        return;
    }
    NSDictionary *params = k_COMMANY_FINANCE_BODY(stockCode);
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
            
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            
            if ([returnDic[@"data"] isKindOfClass:[NSArray class]]) {
             
                NSArray *arr = returnDic[@"data"];
                if (arr.count > 0) {
                    success(returnDic[@"data"][0]);
                }
                
            }
            
            failure(nil);
        }
    }];
}

/*
 *  股东
 */

- (void)getStockholderWithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *url = k_STOCKHOLDER_URL;
    
    if (stockCode == nil) {
        failure(@"股票代码不能为空");
        return;
    }
    
    NSDictionary *params = k_STOCKHOLDER_BODY(stockCode);
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
            
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            
            success(returnDic[@"data"]);
        }
    }];
}

;
/*
 *  总股本
 */
- (void)getTotalStockWithStockCode:(NSString *)stockCode success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *url = k_TOTAL_STOCK_URL;
    
    if (stockCode == nil) {
        failure(@"股票代码不能为空");
        return;
    }
    NSDictionary *params = k_TOTAL_STOCK_BODY(stockCode);
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
            
        }else if (![results isNull])
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
        
            if ([returnDic[@"data"] isKindOfClass:[NSArray class]]) {
                
                NSArray *arr = returnDic[@"data"];
                if (arr.count > 0) {
                    success(returnDic[@"data"][0]);
                }
                
            }
            
            failure(nil);
        }
    }];
}



/*
 *收到通知数据后统一处理
 */
- (id)dealNotificationDataWithRequest:(const UUCommRequest *)request success:(void(^)(UUCommResponse *))success failure:(void(^)(NSError *))failure
{
    char s_identifier = request->head.cIdentifier;
    
    __block NSMutableData *m_data = [NSMutableData data];
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:SocketdidReceivedDataNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSData *temp_data = note.object;
        [m_data appendData:temp_data];
        UUCommResponse *respose = (UUCommResponse *)m_data.bytes;
        
        if (respose->head.cIdentifier != s_identifier)
        {
            [m_data setLength:0];
        }
        else if (m_data.length == respose->head.nLength)
        {
            if (UUMarket__VaildRespose(respose)) {
                //完整包返回
                success(respose);
                //m_data 清空
                [m_data setLength:0];
            }else{
            }
        }else if (m_data.length > respose->head.nLength){
            
            NSData *temp_data = [m_data subdataWithRange:NSMakeRange(0, respose->head.nLength)];
            UUCommResponse *temp_response = (UUCommResponse *)temp_data.bytes;
            if (UUMarket__VaildRespose(temp_response)) {
                //完整包返回
                success(temp_response);
                //m_data 清空
                [m_data setLength:0];
                m_data = [[m_data subdataWithRange:NSMakeRange(respose->head.nLength - 1, temp_data.length - respose->head.nLength)] mutableCopy];
            }else{
            }
        }
    }];
    
    return observer;
}



@end
