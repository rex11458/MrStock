//
//  UUMarketStruts.h
//  StockHelper
//
//  Created by LiuRex on 15/9/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUCommStruct.h.h"
typedef unsigned short UUMarketDataType;

#pragma	pack(1)
 //功能列表
typedef enum : NSUInteger {
    UUMarketFunctionRealTimeType    = 0x0010,   //行情推送
    UUMarketFunctionTrendType       = 0x0011,   //分时走势
    UUMarketFunctionStockTickType   = 0x0012,   //分笔成交
    UUMarketFunctionKLineType       = 0x0013,   //K线数据
    UUMarketFunctionInitDataType    = 0x00FF,   //初始股票数据
    UUMarketFunctionExRightsType    = 0x0021,   //除权信息
    UUMarketFunctionRankType        = 0x0030,   //数据排名
    UUMarketFunctionFinancialType   = 0x0020,    //财务数据
    UUMarketFunctionBlockType       = 0x0031    //板块排名
} UUMarketFunctionType;

//金融分类
typedef enum : NSUInteger {
    UUSecuritiesAStockType      = 0x1000,   //A股
    UUSecuritiesHStockType      = 0x2000,   //港股
    UUSecuritiesFuturesType     = 0x4000,   //期货
} UUSecuritiesType;

//股票市场分类
typedef enum : NSUInteger {
    UUStockSSType     = 0x0100, //沪市
    UUStockSZType     = 0x0200, //深市
    UUStockSYSType    = 0x0400, //系统板块
    UUStockUDType     = 0x0800  //自定义板块
} UUStockType;

//股票交易品种分类
typedef enum : NSUInteger {
    UUStockExchangeIDXType              = 0x0000,   //指数
    UUStockExchangeAShareType,                      //A股
    UUStockExchangeBShareType,                      //B股
    UUStockExchangeBondType,                        //债券
    UUStockExchangeTypeFundType,                    //基金
    UUStockExchangeNEEQType,                        //三板
    UUStockExchangePannikinType,                    //中小盘股
    UUStockExchangePlacingShareType,                //配售
    UUStockExchangeLOFType,                         //LOF
    UUStockExchangeETFType,                         //ETF
    UUStockExchangeWarrantType,                     //权证
    UUStockExchangeChiNextType,                     //深圳创业板
    UUStockExchangeThirdPartyType,                  //第三方行情分类
    UUStockExchangeUDIndexType,                     //自定义指数
    UUStockExchangeOtherType                        //其他
} UUStockExchangeType;

//证券代码信息
typedef struct _UUMarketCodeInfo{
    
    UUMarketDataType	m_cCodeType;				// 证券类型
    char				m_cCode[6];				// 证券代码
    
}UUMarketCodeInfo;


//个股实时数据
typedef struct __UUStockRealTime
{
    int				m_lOpen;         		// 今开盘
    int				m_lMaxPrice;     		// 最高价
    int				m_lMinPrice;     		// 最低价
    int				m_lNewPrice;     		// 最新价
    unsigned int	m_lTotal;			// 成交量(单位:股)
    float			m_fAvgPrice;			// 成交金额
    
    int				m_lBuyPrice1;			// 买一价
    unsigned int	m_lBuyCount1;			// 买一量
    int				m_lBuyPrice2;			// 买二价
    unsigned int	m_lBuyCount2;			// 买二量
    int				m_lBuyPrice3;			// 买三价
    unsigned int	m_lBuyCount3;			// 买三量
    int				m_lBuyPrice4;			// 买四价
    unsigned int	m_lBuyCount4;			// 买四量
    int				m_lBuyPrice5;			// 买五价
    unsigned int	m_lBuyCount5;			// 买五量
    
    int				m_lSellPrice1;		// 卖一价
    unsigned int	m_lSellCount1;		// 卖一量
    int				m_lSellPrice2;		// 卖二价
    unsigned int	m_lSellCount2;		// 卖二量
    int				m_lSellPrice3;		// 卖三价
    unsigned int	m_lSellCount3;		// 卖三量
    int				m_lSellPrice4;		// 卖四价
    unsigned int	m_lSellCount4;		// 卖四量
    int				m_lSellPrice5;		// 卖五价
    unsigned int	m_lSellCount5;		// 卖五量
    
    int				m_nHand;				// 每手股数
    int				m_lNationalDebtRatio;	// 国债利率,基金净值
}UUStockRealTime;


//指数实时数据
typedef struct __UUIndexRealTime
{
    int				m_lOpen;				// 今开盘
    int				m_lMaxPrice;			// 最高价
    int				m_lMinPrice;			// 最低价
    int				m_lNewPrice;			// 最新价
    unsigned int	m_lTotal;			// 成交量
    float			m_fAvgPrice;			// 成交金额，使用时需乘以100
    short			m_nRiseCount;			// 上涨家数
    short			m_nFallCount;			// 下跌家数
    int				m_nTotalStock1;		/* 对于综合指数：所有股票 - 指数
                                         对于分类指数：本类股票总数 */
    unsigned int	m_lBuyCount;			// 委买数
    unsigned int	m_lSellCount;			// 委卖数
    short			m_nType;				// 指数种类：0-综合指数 1-A股 2-B股
    short			m_nLead;            	// 领先指标
    short			m_nRiseTrend;       	// 上涨趋势
    short			m_nFallTrend;       	// 下跌趋势
    
    short		    m_nNo2[5];			// 保留
    
    short			m_nTotalStock2;		/* 对于综合指数：A股 + B股
                                         对于分类指数：0 */
    int				m_lADL;				// ADL 指标
    int				m_lNo3[3];			// 保留
    int				m_nHand;				// 每手股数
}UUIndexRealTime;

//3.8	行情时间
typedef struct _StockOtherDataDetailTime
{
    unsigned short m_nTime;
    unsigned short m_nSecond;
}TimeDate;

//3.9	证券附加数据
typedef struct _StockOtherData
{
    TimeDate                m_sDetailTime;		// 现在时间
    
    unsigned int  			m_lCurrent;    		// 现在总手
    unsigned int  			m_lOutside;    		// 外盘，个股需除以100再使用
    unsigned int  			m_lInside;     		// 内盘，个股需除以100再使用
    
    unsigned int  			m_lPreClose;    		// 前收盘价
    int                     m_lTickCount;  		// 分笔笔数,主推时使用,只限于股票
}StockOtherData;

//实时行情
typedef struct _CommRealTimeData{
    UUMarketCodeInfo        m_ciStockCode;	// 证券代码
    StockOtherData          m_othData;		// 实时其它数据
    char                    m_cNowData[1];	/* 指向个股或指数实时数据，请根据证券代码来
                                             决定是使用个股实时数据结构体（UUStockRealTime），
                                             还是使用指数实时数据结构体（UUIndexRealTime  ）。
                                             */
}CommRealTimeData;

//----分时数据------
typedef struct __PriceVolItem
{
    int                 m_lNewPrice;		// 最新价
    unsigned int		m_lTotal;		// 总成交量
}PriceVolItem;

typedef struct __UUComTrendData
{
    UUMarketCodeInfo	m_codeInfo;		// 证券代码
    short				m_nHisLen;		// 分时数据个数
    short 			    m_nAlignment;		// 为了4字节对齐而添加的字段
    StockOtherData		m_othData;		// 实时其它数据
    union
    {
        UUStockRealTime		m_stockData;		// 个股实时基本数据，112字节
        UUIndexRealTime		m_indData;		// 指数实时基本数据，80字节
    };// 占位112个字节
    PriceVolItem		m_pHisData[1];	// 历史分时数据
}UUComTrendData;

/*--------分笔数据----------*/
typedef struct __StockTick
{
    short		   	m_nTime;			   	// 当前时间（距开盘分钟数）
    char 			m_nBuyOrSell; 		// 1 按买价 0 按卖价
    char 			m_nSecond; 			//秒数
    int		   		m_lNewPrice;        	// 成交价
    unsigned int  	m_lCurrent;		   	/* 总成交量，需除以100转为手数，单笔成交量需
                                         与前一笔数据进行相减，如相减后结果为0，
                                         则自行抛弃掉该条数据
                                         */
    int		   		m_lBuyPrice;        	// 委买价
    int		   		m_lSellPrice;       	// 委卖价
    unsigned int  	m_nChiCangLiang;	   	// 持仓量,深交所股票单笔成交数,港股成交盘分类(Y,M,X等，根据数据源再确定）
}StockTick;

typedef struct __UUCommStockTickData
{
    int			m_nSize;			// 数据个数
    StockTick	m_traData[1];		// 分笔数据
}UUCommStockTickData;


/*－－－－－－－K线－－－－－－－－－－*/
typedef struct __UUKData
{
    int             m_lDate;				// 日期
    int             m_lOpenPrice;			// 开
    int             m_lMaxPrice;			// 高
    int             m_lMinPrice;			// 低
    int             m_lClosePrice;		// 收
    int             m_lMoney;			// 成交金额，需要乘以1000后再使用
    unsigned int	m_lTotal;	// 成交量
    int             m_lNationalDebtRatio; // 0,无意义
}UUKData;

/*------------初始数据------------------*/
//请求包
typedef struct __ReqMarketInitData
{
    unsigned short          m_cBourse;		// 证券分类类型
    unsigned int            m_dwCRC;        // CRC校验码
}ReqMarketInitData;

typedef struct __UUTypeTime
{
    short	m_nOpenTime;	// 前开市时间
    short	m_nCloseTime;	// 前闭市时间
}UUTypeTime;

//3.15.2	市场分类信息
typedef struct __StockType
{
    char 	m_stTypeName[20];	// 市场分类名称
    short   m_nStockType;		// 证券类型
    short   m_nTotal;			// 证券总数
    short   m_nOffset;		// 偏移量
    short   m_nPriceUnit;		// 价格单位
    short   m_nTotalTime;		// 总开市时间（分钟）
    short   m_nCurTime;		// 现在时间（分钟）
    
    UUTypeTime 	m_nNewTimes[11];	/* 时间区段边界,两边界为-1时，为无效区段,
                                     第一个无效区段后所有区段全为无效。
                                     */
    UUTypeTime	m_nPriceDecimal;   // 小数位, < 0
}StockType;

//	证券市场属性数据结构
typedef struct __CommBourseInfo
{
    char			m_stTypeName[20];	// 市场名称(对应市场类别)
    short           m_nMarketType;	// 市场类别(最高俩位)
    short           m_cCount;		// 有效的市场分类个数
    int             m_lDate;			// 今日日期（19971230）
    unsigned int	m_dwCRC;			// CRC校验码（分类）
    StockType	m_stNewType[1];	// 市场分类信息
}CommBourseInfo;

//单个股票信息
typedef struct __StockInitInfo
{
    char                m_cStockName[16];		// 股票名称
    UUMarketCodeInfo	m_ciStockCode;		// 股票代码结构
    int                 m_lPrevClose;			// 昨收
    int                 m_l5DayVol;			// 5日量(预留)
}StockInitInfo;

//3.15.5	证券市场数据
typedef struct __OneMarketData
{
    CommBourseInfo  	m_biInfo;		// 证券市场属性数据
    short           	m_nSize;			// 股票个数据
    short               m_nAlignment;		// 为了4字节对齐而添加的字段
    StockInitInfo       m_pstInfo[1];   	// 股票信息列表
}OneMarketData;

//响应包
typedef struct __ResMarketInitData
{
    short			m_nMarketSize;		// 市场数量
    short			m_nAutoPushStatus;	// 是否后端主推（0—前端请求，非0—主推）
    OneMarketData	m_oneMakretData[1];	// 市场数据
}ResMarketInitData;



//3.15.9	除权数据
//除权数据
/*
 *  前复权
 */
typedef struct __StructChuquanData
{
    unsigned int	m_time;	     // UCT
    float			m_fGive;	    // 每股送
    float			m_fPei;	       	// 每股配
    float			m_fPeiPrice;	// 配股价,仅当 m_fPei!=0.0f 时有效
    float			m_fProfit;	    // 每股红利
}StructChuquanData;

//除权数据，用于返回
typedef struct __UUCommChuquanData
{
    UUMarketCodeInfo	code;		//代码
    int                 count;		//除权数据个数
    StructChuquanData   data[1];	//除权数据起始位置，数量由count决定
}UUCommChuquanData;

//--排名数据--
//类型
typedef enum : NSUInteger {
    UUIncreaseRateType          = 0x0001, //涨幅排名
    UUDecreaseRateType          = 0x0002, //跌幅排名
    UUAmplitudeRateType         = 0x0040, //振幅排名
    UUExchangeRateType          = 0x0200, //换手率排名
    UUHotProfessionType         = 0x1000, //热门行业列表
    UUConceptType               = 0x2000, //概念板块列表
    
} UUMarketRankType;


//股票排名
typedef struct __ReqUUReportSort
{
    unsigned short      m_cCodeType;  // 市场类别
    short           	m_nRetCount;  // 返回总数
    unsigned short  	m_nSortType;  // 排名类型
}ReqUUReportSort;

typedef struct __GeneralSortData
{
    UUMarketCodeInfo    m_ciStockCode;		// 股票代码
    int                 m_lNewPrice;			// 最新价
    int                 m_lValue;			// 计算值,涨、跌幅需要除以1000，振幅除以100
}GeneralSortData;

typedef struct __ResUUReportSort
{
    unsigned short		m_nSortType;	// 多种排序类型位与值，见请求包的类型
    short				m_nSize;		// 单个排序类型所含数据GeneralSortData个数
    int					m_nReserved;   // 保留
    GeneralSortData		m_prptData[1];	/* 排序数据，实际个数为m_nSize*N,
                                         其中N为m_nSortType值中为1的位(bit)个数
                                         例：m_nSortType = 67, m_nSize = 10，
                                         则排序数据个数为30个。
                                         1-10为第1位（涨幅排名）的数据
                                         11-20为第2位（跌幅排名）的数据
                                         21-30为第7位（振幅排名）的数据
                                         */
}ResUUReportSort;

//板块排名
typedef struct __ReqUUReportBlock
{
    short			nBlockType;			//板块类型，0--热门行业，1--概念板块
    unsigned short	nCount;				//返回数据条数，
    short			nDescSort;			//排序类型，0--升序，1--降序
}ReqUUReportBlock;


typedef struct __UUCommReportBlockData
{
    UUMarketCodeInfo    codeInfo;			//代码
    int                 lNewPrice;		//最新价
    int                 lRiseRate;		//涨跌幅
    char                szStockCode[8];	//领涨股代码
    int                 lStockRiseRate;	//领涨股涨跌幅
    int                 lStockNewPrice;  //领涨股最新价
}UUCommReportBlockData;

//板块指数报表返回结构
typedef struct __UUResReportBlock
{
    short                        nBlockType;		//板块类型，0--热门行业，1--概念板块
    unsigned short                    count;			//记录数
    UUCommReportBlockData		blockData[1];		//板块报表数据
}UUResReportBlock;

/*财务数据*/
typedef struct __StructCaiwuData
{
    unsigned int BGRQ;   // 财务数据的日期, UIC格式
    // 如半年报 季报等 如 20090630 表示2009年半年报
    float ZGB;             // 总股本，单位万元
    float GJG;             // 国家股
    float FQFRG;           // 发起人法人股
    float FRG;             // 法人股
    float BGS;             // B股
    float HGS;             // H股
    float MQLT;            // 目前流通,单位（万股）
    float ZGG;             // 职工股
    float A2ZPG;           // A2转配股
    float ZZC;             // 总资产，单位(千元)
    float LDZC;            // 流动资产
    float GDZC;            // 固定资产
    float WXZC;            // 无形资产
    float CQTZ;            // 长期投资
    float LDFZ;            // 流动负债
    float CQFZ;            // 长期负债
    float ZBGJJ;           // 资本公积金
    float MGGJJ;           // 每股公积金
    float GDQY;            // 股东权益
    float ZYSR;            // 主营收入
    float ZYLR;            // 主营利润
    float QTLR;            // 其他利润
    float YYLR;            // 营业利润
    float TZSY;            // 投资收益
    float BTSR;            // 补贴收入
    float YYWSZ;           // 营业外收支
    float SNSYTZ;          // 上年损益调整
    float LRZE;            // 利润总额
    float SHLR;            // 税后利润
    float JLR;             // 净利润
    float WFPLR;           // 未分配利润
    float MGWFP;           // 每股未分配
    float MGSY;            // 每股收益
    float MGJZC;           // 每股净资产
    float TZMGJZC;         // 调整每股净资产
    float GDQYB;           // 股东权益比
    float JZCSYL;          // 净资收益率
}StructCaiwuData;

//财务数据，用于返回
typedef struct __UUCommCaiwuData
{
    UUMarketCodeInfo			codeInfo; //代码
    StructCaiwuData 	data; //财务数据
}UUCommCaiwuData;

//创建Head
UUCommHead* UUMarket_CreateHead(char cIdentifier,unsigned short code);

UUCommHead* UUMarket__CreateHead(unsigned short code);

//创建codeInfo
UUMarketCodeInfo* UUMarket_CreateCodeInfo(UUMarketDataType type,const char *stockCode);

//通过属性和包头创建Request
UUCommRequest* UUMarket__CreateRequest(UUCommAttribute *attribute, UUCommHead *head);

//验证接收到的包是否有效
BOOL UUMarket_VaildRespose(UUCommResponse *response,char cIdentifier);
BOOL UUMarket__VaildRespose(UUCommResponse *response);


void UUMarket_Free(void *);

//--------------------请求体-----------------------------
/*
 *  沪深股票列表
 */
UUCommRequest* UUMarket_StockListRequest(void);

/*
 *  获取多只股票信息
 */
UUCommRequest* UUMarket_FavouriteStockListRequest(NSArray *stockModelArray);

/*
 *  五档信息
 */
UUCommRequest* UUMarket_StockDetailRequest(NSString *code,UUMarketDataType market);
/*
 *  分时走势
 */
UUCommRequest* UUMarket_ShareTimeRequest(NSString *code,UUMarketDataType market);

/*
 *  K线走势
 */
UUCommRequest* UUMarket_KLineRequest(NSString *code,UUMarketDataType market,NSInteger lineType);
/*
 *  分价成交
 */
UUCommRequest* UUMarket_SharePriceRequest(NSString *code,UUMarketDataType market);
/*
 *  财务数据
 */
UUCommRequest* UUMarket_FinancialInfoRequest(NSString *code,UUMarketDataType market);

/*
 *  除权
 */
UUCommRequest* UUMarket_StockExRightsRequest(NSString *code,UUMarketDataType market);

/*
 *  个股排名
 */
UUCommRequest* UUMarket_ReportSortRequest(UUMarketRankType rankType,NSInteger count);

/*
 * 根据市场和类别获取个股排名
 */
UUCommRequest* UUMarket_ReportSortRequest_2(UUMarketRankType rankType,UUMarketDataType market,NSInteger count);

/*
 *板块排名
 */
UUCommRequest*UUMarket_ReportBlockRequest(short blockType,unsigned short sortType,short count);



