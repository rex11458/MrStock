//
//  UUStockFinancialModel.m
//  StockHelper
//
//  Created by LiuRex on 15/11/2.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockFinancialModel.h"

@implementation UUStockFinancialModel

- (id)initWithFinancailData:(StructCaiwuData *)financailData
{
    if (self = [super init]) {
        
        self.ZGB = 10000 * (financailData->ZGB);

        self.GJG = financailData->GJG;
        self.FQFRG = financailData->FQFRG;
        self.FRG = financailData->FRG;
        self.BGS = financailData->BGS;
        self.HGS = financailData->HGS;
        self.MQLT = (financailData->MQLT) * 10000;

        self.A2ZPG = financailData->A2ZPG;
        self.ZZC = (financailData->ZZC)  * 1000;
        self.LDZC = financailData->LDZC;
        self.GDZC = financailData->GDZC;
        self.WXZC = financailData->WXZC;
        self.CQTZ = financailData->CQTZ;
        self.LDFZ = financailData->LDFZ;
        self.CQFZ = financailData->CQFZ;
        self.ZBGJJ = financailData->ZBGJJ;
        self.MGGJJ = financailData->MGGJJ;
        self.GDQY = financailData->GDQY;
        self.ZYSR = financailData->ZYSR;
        self.QTLR = financailData->QTLR;
        self.YYLR = financailData->YYLR;
        self.TZSY = financailData->TZSY;
        self.BTSR = financailData->BTSR;
        self.YYWSZ = financailData->YYWSZ;
        self.SNSYTZ = financailData->SNSYTZ;
        self.LRZE = financailData->LRZE;
        self.SHLR = financailData->SHLR;
        self.JLR = financailData->JLR;
        self.WFPLR = financailData->WFPLR;
        self.MGWFP = financailData->MGWFP;
        self.MGSY = financailData->MGSY;
        self.MGJZC = financailData->MGJZC;
        self.TZMGJZC = financailData->TZMGJZC;
        self.GDQYB = financailData->GDQYB;
        self.JZCSYL = financailData->JZCSYL;
  
    }
    
    return self;
}

@end
