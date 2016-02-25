//
//  UUStockFinancialModel.h
//  StockHelper
//
//  Created by LiuRex on 15/11/2.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUMarketStructs.h"
/*
 unsigned long BGRQ;   // 财务数据的日期, UIC格式
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
 */
@interface UUStockFinancialModel : NSObject


@property (nonatomic,assign) double ZGB;     //单位万元
@property (nonatomic,assign) double GJG;
@property (nonatomic,assign) double FQFRG;
@property (nonatomic,assign) double FRG;
@property (nonatomic,assign) double BGS;
@property (nonatomic,assign) double HGS;
@property (nonatomic,assign) double MQLT;    //单位：万
@property (nonatomic,assign) double ZGG;
@property (nonatomic,assign) double A2ZPG;
@property (nonatomic,assign) double ZZC;     //单位(千元)
@property (nonatomic,assign) double LDZC;
@property (nonatomic,assign) double GDZC;
@property (nonatomic,assign) double WXZC;
@property (nonatomic,assign) double CQTZ;
@property (nonatomic,assign) double LDFZ;
@property (nonatomic,assign) double CQFZ;
@property (nonatomic,assign) double ZBGJJ;
@property (nonatomic,assign) double MGGJJ;
@property (nonatomic,assign) double GDQY;
@property (nonatomic,assign) double ZYSR;
@property (nonatomic,assign) double ZYLR;
@property (nonatomic,assign) double QTLR;
@property (nonatomic,assign) double YYLR;
@property (nonatomic,assign) double TZSY;
@property (nonatomic,assign) double BTSR;
@property (nonatomic,assign) double YYWSZ;
@property (nonatomic,assign) double SNSYTZ;
@property (nonatomic,assign) double LRZE;
@property (nonatomic,assign) double SHLR;
@property (nonatomic,assign) double JLR;
@property (nonatomic,assign) double WFPLR;
@property (nonatomic,assign) double MGWFP;
@property (nonatomic,assign) double MGSY;
@property (nonatomic,assign) double MGJZC;
@property (nonatomic,assign) double TZMGJZC;
@property (nonatomic,assign) double GDQYB;
@property (nonatomic,assign) double JZCSYL;

- (id)initWithFinancailData:(StructCaiwuData *)financailData;


@end
