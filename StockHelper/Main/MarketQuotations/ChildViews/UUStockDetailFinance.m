//
//  UUStockDetailFinance.m
//  StockHelper
//
//  Created by LiuRex on 15/11/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailFinance.h"
#import "UUStockDetailFinanceViewCell.h"
#import "UUMarketQuationHandler.h"
#define k_TITLE @"title"
#define k_SUB_TITLE @"subTitle"
#define k_CELL_TITLE_ARRAY @"cellTitleArray"
#define k_CELL_CONTENT_ARRAY @"cellContentArray"
static NSArray *g_titleArray = nil;
@implementation UUStockDetailFinanceDataSource

- (instancetype)init
{
    if (self = [super init]) {
        _titleArray = @[
                        @{
                            k_TITLE     : @"利润表",
                            k_SUB_TITLE : @"",
                            k_CELL_TITLE_ARRAY :@[@"每股收益",@"营业收入",@"营业利润",@"净利润"]
                            },
                        @{
                            k_TITLE     : @"资产负债表",
                            k_SUB_TITLE : @"",
                            k_CELL_TITLE_ARRAY :@[@"每股净资产",@"资产总计",@"负债总计",@"股东权益"]
                            },
                        @{
                            k_TITLE     : @"现金流量表",
                            k_SUB_TITLE : @"",
                            k_CELL_TITLE_ARRAY :@[@"经营现金流量净额",@"投资现金净额",@"筹资现金净额"]
                            }
                         ];
       g_titleArray = _titleArray;
    }
    return self;
}

- (instancetype)initWithStockCode:(NSString *)stockCode
{
    if (self = [self init]) {
        self.stockCode = stockCode;
    }
    return self;
}

- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailueBlock)failure
{
    [[UUMarketQuationHandler sharedMarkeQuationHandler] getCompanyFinanceWithStockCode:self.stockCode success:^(NSDictionary *jsonDictionary) {
        _titleArray = [[self dataArrayWithDictionary:jsonDictionary] copy];
        g_titleArray = _titleArray;
        if(success){
            success(_titleArray);
        }
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (NSArray *)dataArrayWithDictionary:(NSDictionary *)jsonDictionary
{
    //基本每股收益
    double basicEps = [jsonDictionary[@"basicEps"] doubleValue];
    // 营业收入
    double operateProfit = [jsonDictionary[@"operateProfit"] doubleValue];
    
    //营业利润
    double operateProfit2 =  [jsonDictionary[@"operateReve"] doubleValue];
    //净利润
    double NETPROFIT = [jsonDictionary[@"netProfit"] doubleValue];
    
    //每股净资产
    double PARENTBVPS = [jsonDictionary[@"parentbvps"] doubleValue];
     //资产总计
    double SUMASSET = [jsonDictionary[@"sumasSet"] doubleValue];
    //负债资产
    double SUMLIAB = [jsonDictionary[@"sumLiab"] doubleValue];
    //股东权益
    double SUMSHEQUITY = [jsonDictionary[@"sumSheQuity"] doubleValue];
    
    //经营现金流量净额
    double NETOPERATECASHFLOW = [jsonDictionary[@"netOperateCashflow"] doubleValue];
    //投资现金净额
    double NETINVCASHFLOW =  [jsonDictionary[@"netInvCashflow"] doubleValue];
    //筹资现金净额
    double NETFINACASHFLOW =  [jsonDictionary[@"netFinaCashflow"] doubleValue];
    
    NSString *sesion = jsonDictionary[@"reportTimeType"];

    NSArray *array1 = @[[NSString stringWithFormat:@"%.3f",basicEps],[self price:operateProfit],[self price:operateProfit2],[self price:NETPROFIT]];
    NSArray *array2 = @[[NSString stringWithFormat:@"%.3f",PARENTBVPS],[self price:SUMASSET],[self price:SUMLIAB],[self price:SUMSHEQUITY]];
    NSArray *array3 = @[[self price:NETOPERATECASHFLOW],[self price:NETINVCASHFLOW],[self price:NETFINACASHFLOW]];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableDictionary *dic1 = [_titleArray[0] mutableCopy];
    [dic1 setValue:array1 forKey:k_CELL_CONTENT_ARRAY];
    [dic1 setValue:sesion forKey:k_SUB_TITLE];
    [dataArray addObject:dic1];
    
    NSMutableDictionary *dic2 = [_titleArray[1] mutableCopy];
    [dic2 setValue:array2 forKey:k_CELL_CONTENT_ARRAY];
    [dic2 setValue:sesion forKey:k_SUB_TITLE];

    [dataArray addObject:dic2];

    NSMutableDictionary *dic3 = [_titleArray[2] mutableCopy];
    [dic3 setValue:array3 forKey:k_CELL_CONTENT_ARRAY];
    [dic3 setValue:sesion forKey:k_SUB_TITLE];
    [dataArray addObject:dic3];
    
    return dataArray;
}

- (NSString *)price:(double)value
{
    double fabsPrice = fabs(value);
    NSMutableString *amount = [NSMutableString stringWithFormat:@"%.2f",value];
    

    if(fabsPrice > 10000 * 10000)
    {
        NSRange range = [amount rangeOfString:@"."];
        if (range.location != NSNotFound) {
            [amount deleteCharactersInRange:range];
            [amount insertString:@"." atIndex:amount.length - 10];
            CGFloat price = [amount floatValue];
            amount = [NSMutableString stringWithFormat:@"%.2f亿",price];
        }
    }
    else if (fabsPrice > 10000)
    {
        NSRange range = [amount rangeOfString:@"."];
        if (range.location != NSNotFound) {
            [amount deleteCharactersInRange:range];
            [amount insertString:@"." atIndex:amount.length - 6];
            CGFloat price = [amount floatValue];
            amount = [NSMutableString stringWithFormat:@"%.2f万",price];
        }
    }
    
    return [amount stringByAppendingString:@"元"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray[section][k_CELL_TITLE_ARRAY] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UUStockDetailFinanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UUStockDetailFinanceViewCell" owner:self options:nil] firstObject];
        [cell setValue:cellId forKey:@"reuseIdentifier"];
    }
    cell.titleLabel.text = _titleArray[indexPath.section][k_CELL_TITLE_ARRAY][indexPath.row];
    cell.contentLabel.text = _titleArray[indexPath.section][k_CELL_CONTENT_ARRAY][indexPath.row];
    return cell;
}

@end

@implementation UUStockDetailFinance

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *viewId = @"UUStockDetailFinanceHeaderViewId";
    
    UUStockDetailFinanceHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (headerView == nil) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"UUStockDetailFinanceViewCell" owner:self options:nil] lastObject];
        [headerView setValue:viewId forKey:@"reuseIdentifier"];
    }
    headerView.titleLabel.text = g_titleArray[section][k_TITLE];
    headerView.subTitleLabel.text = g_titleArray[section][k_SUB_TITLE];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
