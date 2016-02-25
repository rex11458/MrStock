//
//  UUMarketStruts.m
//  StockHelper
//
//  Created by LiuRex on 15/9/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#include "UUMarketStructs.h"
#import "UUStockModel.h"
UUCommHead* UUMarket_CreateHead(char cIdentifier,unsigned short code)
{
    //默认请求行情
    int nLen            = 0;
    UUCommHead *head = malloc(sizeof(unsigned short) + sizeof(char) + sizeof(char[64]));
    head->code = code;
    head->nLength = nLen;
    return head;
}

UUCommHead* UUMarket__CreateHead(unsigned short code)
{
    //默认请求行情
    int nLen            = 0;
    UUCommHead *head = malloc(sizeof(unsigned short) + sizeof(char) + sizeof(char[64]));
    head->code = code;
    head->nLength = nLen;
    UUCommHead_setIdentifier(head);
    return head;
}


UUMarketCodeInfo* UUMarket_CreateCodeInfo(UUMarketDataType type,const char *stockCode)
{
    if (stockCode == NULL) {
        return NULL;
    }
    
    UUMarketCodeInfo *code_info = malloc(sizeof(UUMarketCodeInfo));
    code_info->m_cCodeType = type;
    memcpy(code_info->m_cCode, stockCode, 6);
    
    return code_info;
}

UUCommAttribute* UUMarket_CreateAttribute(UUMarketCodeInfo *codeInfo)
{
    UUCommAttribute *m_attribute = malloc(sizeof(UUCommAttribute) - 1 + sizeof(UUMarketCodeInfo));
    m_attribute->type = 0x10;
    m_attribute->length = sizeof(UUMarketCodeInfo);
    memcpy(m_attribute->cAttribute, codeInfo, sizeof(UUMarketCodeInfo));

    return m_attribute;
}


UUCommRequest* UUMarket__CreateRequest(UUCommAttribute *attribute, UUCommHead *head)
{
    int n_len = sizeof(UUCommHead) + UUCommAttribute_getTotalLength(attribute);
    UUCommRequest *m_request = malloc(n_len);
    head->nLength = n_len;
    
    memcpy(&m_request->head, head, sizeof(UUCommHead));
    
    memcpy(m_request->cAttributes, attribute, UUCommAttribute_getTotalLength(attribute));
    UUCommHead_CreateAuthenticator(&m_request->head);
    //--整包 MD5
    UUCommRequest_CreateAuthenticator(m_request);
    return m_request;
}

//验证接收到的包是否有效
BOOL UUMarket_VaildRespose(UUCommResponse *response,char cIdentifier)
{
    if (response == NULL) {
        return NO;
    }
    
    if (response->head.cIdentifier != cIdentifier) return NO;
    
    //如果包头验证不通过 return
    if (!UUCommHead_ValidHead(&response->head)) return NO;
    
    //验证整包有效性
    if (!UUCommRequest_Valid(response)) return NO;
  
    return YES;
}

BOOL UUMarket__VaildRespose(UUCommResponse *response)
{
    if (response == NULL) {
        return NO;
    }
    
    //如果包头验证不通过 return
    if (!UUCommHead_ValidHead(&response->head)) return NO;
    
    //验证整包有效性
    if (!UUCommRequest_Valid(response)) return NO;
    
    return YES;

}



void UUMarket_Free(void * obj)
{
    free(obj);
}

//--------------------请求体-----------------------------
/*
 *  沪深股票列表
 */

UUCommRequest* UUMarket_StockListRequest(void)
{
    //沪市
    unsigned short marketType_SS = UUSecuritiesAStockType | UUStockSSType;
    unsigned int CRC_SS = [[[NSUserDefaults standardUserDefaults] objectForKey:SS_CRC_CODE_KEY] unsignedIntValue];
    ReqMarketInitData *marketData_SS = malloc(sizeof(ReqMarketInitData));
    marketData_SS->m_dwCRC = CRC_SS;
    marketData_SS->m_cBourse = marketType_SS;
    
    //深市
    unsigned short marketType_SZ = UUSecuritiesAStockType | UUStockSZType;
    unsigned int CRC_SZ = [[[NSUserDefaults standardUserDefaults] objectForKey:SZ_CRC_CODE_KEY] unsignedIntValue];
    ReqMarketInitData *marketData_SZ = malloc(sizeof(ReqMarketInitData));
    
    marketData_SZ->m_dwCRC = CRC_SZ;
    
    marketData_SZ->m_cBourse = marketType_SZ;
    
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionInitDataType);
    
    int buff_len = (sizeof(UUCommAttribute) - 1 + sizeof(ReqMarketInitData)) * 2;
    char *buff = malloc(buff_len);
    memset(buff, 0, buff_len);
    //属性1 股票代码
    UUCommAttribute *m_attribute1 =  malloc(sizeof(UUCommAttribute) - 1 + sizeof(UUMarketCodeInfo));
    m_attribute1->type = 0xF0;
    memcpy(m_attribute1->cAttribute, marketData_SS, sizeof(ReqMarketInitData));
    m_attribute1->length = sizeof(ReqMarketInitData);
    memcpy(buff, m_attribute1, UUCommAttribute_getTotalLength(m_attribute1));
    
    //属性2
    UUCommAttribute *m_attribute2 =  malloc(sizeof(UUCommAttribute) - 1 + sizeof(UUMarketCodeInfo));
    m_attribute2->type = 0xF0;
    memcpy(m_attribute2->cAttribute, marketData_SZ, sizeof(ReqMarketInitData));
    m_attribute2->length = sizeof(ReqMarketInitData);
    memcpy(buff + UUCommAttribute_getTotalLength(m_attribute1), m_attribute2, UUCommAttribute_getTotalLength(m_attribute2));
    
    int n_len = sizeof(UUCommHead) + buff_len;
    UUCommRequest *request = malloc(n_len);
    head->nLength = n_len;
    //-----
    memcpy(&request->head, head, sizeof(UUCommHead));
    
    memcpy(request->cAttributes, buff,buff_len);
    
    UUCommHead_CreateAuthenticator(&request->head);
    //--整包 MD5
    UUCommRequest_CreateAuthenticator(request);
    
        free(marketData_SS);
        free(marketData_SZ);
        free(m_attribute1);
        free(m_attribute2);
        UUMarket_Free(head);
        free(buff);
    
    return request;
}


/*
 * 获取多只股票信息
 */
UUCommRequest* UUMarket_FavouriteStockListRequest(NSArray *stockModelArray)
{
    unsigned int attribute_len = (unsigned int)(sizeof(UUMarketCodeInfo) * stockModelArray.count);
    
    UUCommAttribute *m_attribute = malloc(sizeof(UUCommAttribute) - 1 + attribute_len);
    //--
    m_attribute->type = 0x10;
    
    m_attribute->length = attribute_len;
    
    char *buff = malloc(attribute_len);
    memset(buff, 0, attribute_len);
    
    [stockModelArray enumerateObjectsUsingBlock:^(UUStockModel *stockModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UUMarketDataType data_type = stockModel.market;
        NSString *stockCode = stockModel.code;
        
        UUMarketCodeInfo*codeInfo = UUMarket_CreateCodeInfo(data_type, [stockCode UTF8String]);
        
        memcpy(buff+sizeof(UUMarketCodeInfo) * idx, codeInfo, sizeof(UUMarketCodeInfo));
        free(codeInfo);
    }];
    
    memcpy(m_attribute->cAttribute, buff, attribute_len);
    
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionRealTimeType);
    
    UUCommRequest *request = UUMarket__CreateRequest(m_attribute, head);
    
    //--
    free(m_attribute);
    UUMarket_Free(head);
    
    return request;
}

/*
 * 五档信息
 */
UUCommRequest* UUMarket_StockDetailRequest(NSString *code,UUMarketDataType market)
{
    if (code.length == 0) return NULL;
    //股票类型和代码
    UUMarketCodeInfo *m_codeInfo = malloc(sizeof(UUMarketCodeInfo));
    m_codeInfo->m_cCodeType = market;
    memcpy(m_codeInfo->m_cCode,[code UTF8String], 6);
    
    //属性
    UUCommAttribute *m_attribute = malloc(sizeof(UUCommAttribute) - 1 + sizeof(UUMarketCodeInfo));
    m_attribute->type = 0x10;
    memcpy(m_attribute->cAttribute, m_codeInfo, sizeof(UUMarketCodeInfo));
    m_attribute->length = sizeof(UUMarketCodeInfo);
    free(m_codeInfo);
    
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionRealTimeType);
    
    UUCommRequest *request = UUMarket__CreateRequest(m_attribute, head);
    return request;
}

/*
 * 分时走势
 */
UUCommRequest* UUMarket_ShareTimeRequest(NSString *code,UUMarketDataType market)
{
    if (code.length == 0) return NULL;
    //股票类型和代码
    UUMarketCodeInfo *m_codeInfo = malloc(sizeof(UUMarketCodeInfo));
    m_codeInfo->m_cCodeType = market;
    memcpy(m_codeInfo->m_cCode,[code UTF8String], 6);
    
    //属性
    UUCommAttribute *m_attribute = malloc(sizeof(UUCommAttribute) - 1 + sizeof(UUMarketCodeInfo));
    m_attribute->type = 0x10;
    memcpy(m_attribute->cAttribute, m_codeInfo, sizeof(UUMarketCodeInfo));
    m_attribute->length = sizeof(UUMarketCodeInfo);
    free(m_codeInfo);
    
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionTrendType);
    
    UUCommRequest *request = UUMarket__CreateRequest(m_attribute, head);
    return request;
}


/*
 * K线走势
 */
UUCommRequest* UUMarket_KLineRequest(NSString *code,UUMarketDataType market,NSInteger lineType)
{
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionKLineType);
    
    
    int buff_len = sizeof(UUCommAttribute)*4 - 4 + sizeof(UUMarketCodeInfo) + sizeof(int) * 3;
    char *buff = malloc(buff_len);
    
    //属性1 股票代码
    UUMarketDataType data_type = UUSecuritiesAStockType | UUStockSZType | market;
    UUMarketCodeInfo *m_codeInfo = malloc(sizeof(UUMarketCodeInfo));
    m_codeInfo->m_cCodeType = data_type;
    memcpy(m_codeInfo->m_cCode,[code UTF8String], 6);
    
    UUCommAttribute *m_attribute1 =  malloc(sizeof(UUCommAttribute) - 1 + sizeof(UUMarketCodeInfo));
    m_attribute1->type = 0x10;
    memcpy(m_attribute1->cAttribute, m_codeInfo, sizeof(UUMarketCodeInfo));
    
    m_attribute1->length = sizeof(UUMarketCodeInfo);
    memcpy(buff, m_attribute1, UUCommAttribute_getTotalLength(m_attribute1));
    
    
    //属性2 偏移位置
    int m_offset = 0;
    UUCommAttribute *m_attribute2 = malloc(sizeof(UUCommAttribute) - 1 + sizeof(int));
    m_attribute2->type = 0x01;
    m_attribute2->length = sizeof(int);
    memcpy(m_attribute2->cAttribute, &m_offset, sizeof(int));
    memcpy(buff + UUCommAttribute_getTotalLength(m_attribute1), m_attribute2, UUCommAttribute_getTotalLength(m_attribute2));
    
    //属性3 数据条数
    int m_count = 300;
    UUCommAttribute *m_attribute3 = malloc(sizeof(UUCommAttribute) - 1 + sizeof(int));
    m_attribute3->type = 0x02;
    m_attribute3->length = sizeof(int);
    memcpy(m_attribute3->cAttribute, &m_count, sizeof(int));
    memcpy(buff + UUCommAttribute_getTotalLength(m_attribute1) + UUCommAttribute_getTotalLength(m_attribute2), m_attribute3, UUCommAttribute_getTotalLength(m_attribute3));
    
    //属性4 k线类型
    UUCommAttribute *m_attribute4 = malloc(sizeof(UUCommAttribute) - 1 + sizeof(int));
    m_attribute4->type = 0x03;
    m_attribute4->length = sizeof(int);
    memcpy(m_attribute4->cAttribute, &lineType, sizeof(int));
    memcpy(buff + UUCommAttribute_getTotalLength(m_attribute1) + UUCommAttribute_getTotalLength(m_attribute2)+UUCommAttribute_getTotalLength(m_attribute3), m_attribute4, UUCommAttribute_getTotalLength(m_attribute4));
    
    //-----
    int n_len = sizeof(UUCommHead) + buff_len;
    UUCommRequest *request = malloc(n_len);
    head->nLength = n_len;
    //-----
    memcpy(&request->head, head, sizeof(UUCommHead));
    
    memcpy(request->cAttributes, buff,buff_len);
    
    UUCommHead_CreateAuthenticator(&request->head);
    //--整包 MD5
    UUCommRequest_CreateAuthenticator(request);
    
    free(m_codeInfo);
    free(m_attribute1);
    free(m_attribute2);
    free(m_attribute3);
    free(m_attribute4);
    free(head);
    free(buff);
    return request;
}

/*
 *分价成交
 */
UUCommRequest* UUMarket_SharePriceRequest(NSString *code,UUMarketDataType market)
{
    
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionStockTickType);
    
    int buff_len = sizeof(UUCommAttribute)*3  - 3 + sizeof(UUMarketCodeInfo) + sizeof(int) * 2;
    char *buff = malloc(buff_len);
    memset(buff, 0, buff_len);
    //属性1 股票代码
    UUMarketDataType data_type = UUSecuritiesAStockType | UUStockSZType | market;
    UUMarketCodeInfo *m_codeInfo = malloc(sizeof(UUMarketCodeInfo));
    m_codeInfo->m_cCodeType = data_type;
    memcpy(m_codeInfo->m_cCode,[code UTF8String], 6);
    
    
    UUCommAttribute *m_attribute = malloc(sizeof(UUCommAttribute) - 1 + sizeof(UUMarketCodeInfo));
    m_attribute->type = 0x10;
    memcpy(m_attribute->cAttribute, m_codeInfo, sizeof(UUMarketCodeInfo));
    m_attribute->length = sizeof(UUMarketCodeInfo);
    memcpy(buff,m_attribute,UUCommAttribute_getTotalLength(m_attribute));
    
    //属性2 偏移位置
    int m_offset = 0;
    UUCommAttribute *m_attribute2 = malloc(sizeof(UUCommAttribute) - 1 + sizeof(int));
    m_attribute2->type = 0x01;
    m_attribute2->length = sizeof(int);
    memcpy(m_attribute2->cAttribute, &m_offset, sizeof(int));
    memcpy(buff + UUCommAttribute_getTotalLength(m_attribute), m_attribute2, UUCommAttribute_getTotalLength(m_attribute2));
    
    
    //属性3 数据条数
    int m_count = 20;
    UUCommAttribute *m_attribute3 = malloc(sizeof(UUCommAttribute) - 1 + sizeof(int));
    m_attribute3->type = 0x02;
    m_attribute3->length = sizeof(int);
    memcpy(m_attribute3->cAttribute, &m_count, sizeof(int));
    memcpy(buff + UUCommAttribute_getTotalLength(m_attribute) + UUCommAttribute_getTotalLength(m_attribute2), m_attribute3, UUCommAttribute_getTotalLength(m_attribute3));
    
    int n_len = sizeof(UUCommHead) + buff_len;
    UUCommRequest *request = malloc(n_len);
    head->nLength = n_len;
    //-----
    memcpy(&request->head, head, sizeof(UUCommHead));
    

    memcpy(request->cAttributes, buff,buff_len);
    UUCommHead_CreateAuthenticator(&request->head);
    //--整包 MD5
    UUCommRequest_CreateAuthenticator(request);
    
    
    free(m_codeInfo);
    free(m_attribute);
    free(m_attribute2);
    free(m_attribute3);
    free(buff);
    
    return request;
    
}

/*
 *  财务数据
 */
UUCommRequest* UUMarket_FinancialInfoRequest(NSString *code,UUMarketDataType market)
{
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionFinancialType);
    
    UUMarketCodeInfo*codeInfo = UUMarket_CreateCodeInfo(market, [code UTF8String]);
    
    UUCommAttribute *attribute = malloc(sizeof(UUMarketCodeInfo) + sizeof(UUCommAttribute) - 1);
    attribute->type = 0x10;
    attribute->length = sizeof(UUMarketCodeInfo);
    memcpy(attribute->cAttribute, codeInfo, sizeof(UUMarketCodeInfo));
    UUMarket_Free(codeInfo);
    
    UUCommRequest *request = UUMarket__CreateRequest(attribute, head);
    
    return request;
}

/*
 *  除权
 */
UUCommRequest* UUMarket_StockExRightsRequest(NSString *code,UUMarketDataType market)
{
    UUMarketCodeInfo *codeInfo = UUMarket_CreateCodeInfo(market, [code UTF8String]);
    
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionExRightsType);
    
    //属性1 股票代码
    UUCommAttribute *m_attribute =  malloc(sizeof(UUCommAttribute) - 1 + sizeof(UUMarketCodeInfo));
    m_attribute->type = 0x10;
    m_attribute->length = sizeof(UUMarketCodeInfo);
    memcpy(m_attribute->cAttribute, codeInfo, sizeof(UUMarketCodeInfo));
    UUMarket_Free(codeInfo);

    UUCommRequest *request = UUMarket__CreateRequest(m_attribute, head);
    
    return request;
}

/*
 *  单个排名
 */
UUCommRequest* UUMarket_ReportSortRequest(UUMarketRankType rankType,NSInteger count)
{
    //沪市
    unsigned short marketType_SS = UUSecuritiesAStockType | UUStockSSType | UUStockExchangeAShareType;
    //深市
    unsigned short marketType_SZ = UUSecuritiesAStockType | UUStockSZType | UUStockExchangeAShareType;
    
    unsigned short marketType = marketType_SS | marketType_SZ;
    
    ReqUUReportSort *reqSort = malloc(sizeof(ReqUUReportSort));
    reqSort->m_cCodeType= marketType;
    reqSort->m_nRetCount = (short)count;
    reqSort->m_nSortType = rankType;
    
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionRankType);
    
    //属性1 股票代码
    UUCommAttribute *m_attribute =  malloc(sizeof(UUCommAttribute) - 1 + sizeof(ReqUUReportSort));
    m_attribute->type = 0x30;
    m_attribute->length = sizeof(ReqUUReportSort);
    memcpy(m_attribute->cAttribute, reqSort, sizeof(ReqUUReportSort));
    free(reqSort);

    UUCommRequest *request = UUMarket__CreateRequest(m_attribute, head);

    return request;
}

/*
 * 根据市场和类别获取个股排名
 */
UUCommRequest* UUMarket_ReportSortRequest_2(UUMarketRankType rankType,UUMarketDataType market,NSInteger count)
{
    unsigned short marketType = (market & 0xffff) | UUStockExchangeAShareType;
    
    ReqUUReportSort *reqSort = malloc(sizeof(ReqUUReportSort));
    reqSort->m_cCodeType= marketType;
    reqSort->m_nRetCount = (short)count;
    reqSort->m_nSortType = rankType;
    
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionRankType);
    
    //属性1 股票代码
    UUCommAttribute *m_attribute =  malloc(sizeof(UUCommAttribute) - 1 + sizeof(ReqUUReportSort));
    m_attribute->type = 0x30;
    m_attribute->length = sizeof(ReqUUReportSort);
    memcpy(m_attribute->cAttribute, reqSort, sizeof(ReqUUReportSort));
    free(reqSort);
    
    UUCommRequest *request = UUMarket__CreateRequest(m_attribute, head);
    
    return request;
}


/*
 *板块排名
 */
UUCommRequest*UUMarket_ReportBlockRequest(short blockType,unsigned short sortType,short count)
{
    UUCommHead *head = UUMarket__CreateHead(UUMarketFunctionBlockType);
    
    ReqUUReportBlock *blockInfo = malloc(sizeof(ReqUUReportBlock));
    blockInfo->nBlockType = blockType;
    blockInfo->nDescSort = sortType;
    blockInfo->nCount = count;
    
    UUCommAttribute *attribute = malloc(sizeof(ReqUUReportBlock) + sizeof(UUCommAttribute) - 1);
    attribute->type = 0x31;
    attribute->length = sizeof(UUMarketCodeInfo);
    memcpy(attribute->cAttribute, blockInfo, sizeof(ReqUUReportBlock));
    free(blockInfo);
    
    int n_len = sizeof(UUCommHead) + sizeof(UUCommAttribute) + sizeof(ReqUUReportBlock) - 1;
    head->nLength = n_len;
    UUCommRequest *request = malloc(n_len);
    memcpy(&request->head, head, sizeof(UUCommHead));
    UUMarket_Free(head);
    memcpy(request->cAttributes, attribute, UUCommAttribute_getTotalLength(attribute));
    free(attribute);
    UUCommHead_CreateAuthenticator(&request->head);
    UUCommRequest_CreateAuthenticator(request);
  
    return request;
}


