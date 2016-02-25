//
//  UUStockDetailShortBrief.m
//  StockHelper
//
//  Created by LiuRex on 15/11/25.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailShortBrief.h"
#import "UUStockDetailShortBriefViewCell.h"
#import "UUMarketQuationHandler.h"
#import "UUStockDetailFinanceViewCell.h"
#import "UUStockDetailStockholderViewCell.h"
#define k_TITLE_  @"title"
#define k_CONTENT_ @"content"
@implementation UUStockDetailShortBriefDataSource

- (instancetype)initWithStockCode:(NSString *)stockCode
{
    if (self = [super init]) {
        
        self.stockCode = stockCode;
    
        self.dataArray = @[
                           @[
                               [@{
                                 k_TITLE_:@"公司名称",
                                 k_CONTENT_ : @""
                               } mutableCopy],
                               [@{
                                   k_TITLE_:@"上市日期",
                                   k_CONTENT_ : @""
                                   } mutableCopy],
                               [@{
                                   k_TITLE_:@"发行价格",
                                   k_CONTENT_ : @""
                                   } mutableCopy],
                               [@{
                                   k_TITLE_:@"发行数量",
                                   k_CONTENT_ : @""
                                   } mutableCopy],
                               [@{
                                   k_TITLE_:@"所属行业",
                                   k_CONTENT_ : @""
                                   } mutableCopy],
                               [@{
                                   k_TITLE_:@"主营业务",
                                   k_CONTENT_ : @""
                                   } mutableCopy]
                             ],
                           [@[] mutableCopy]
                           ];
    }
    return self;
}

- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailueBlock)failure
{
    [[UUMarketQuationHandler sharedMarkeQuationHandler] getCompanyBriefwithStockCode:self.stockCode success:^(NSDictionary *jsonDictionary) {
        self.dataArray = [self dataArrayWithJsonDictionary:jsonDictionary];
        
        if (success) {
            success(self.dataArray);
        }
        
    } failure:^(NSString *errorMessage) {
        
    }];
    
    [[UUMarketQuationHandler sharedMarkeQuationHandler] getCompanyCashbtaxrmbWithStockCode:self.stockCode success:^(NSArray *jsonArray) {
        NSMutableArray *arr = [self.dataArray objectAtIndex:1];
    
        [arr addObjectsFromArray:jsonArray];
        
        if (success) {
            success(self.dataArray);
        }
        
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (NSArray *)dataArrayWithJsonDictionary:(NSDictionary *)jsonDictionary
{
    if (jsonDictionary == nil ) {
        return nil;
    }
    NSMutableArray *dataArray = [self.dataArray mutableCopy];
    //公司名称
    NSString *companyName = jsonDictionary[@"companyName"];
    [dataArray[0][0] setObject:companyName forKey:k_CONTENT_];
    //上市日期
    NSString *listDate = jsonDictionary[@"listDate"];
    [dataArray[0][1] setObject:[listDate substringToIndex:10] forKey:k_CONTENT_];

    //发行价格
    double issuePrice = [jsonDictionary[@"issuePrice"] doubleValue];
    [dataArray[0][2] setObject:[[NSString amountValueWithDouble:issuePrice] stringByAppendingString:@"元"] forKey:k_CONTENT_];

    //发行数量
    double shareIssued = [jsonDictionary[@"shareIssued"] doubleValue];
    [dataArray[0][3] setObject:[[NSString amountTransformToPrice:shareIssued] stringByAppendingString:@"股"] forKey:k_CONTENT_];

   //所属行业
    NSString *regAddress = jsonDictionary[@"regAddress"];
    [dataArray[0][4] setObject:regAddress forKey:k_CONTENT_];

    //主营业务
    NSString *mainBusin = jsonDictionary[@"mainBusin"];
    [dataArray[0][5] setObject:mainBusin forKey:k_CONTENT_];

    return dataArray;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"UUStockDetailShortBriefViewCellId";
        UUStockDetailShortBriefViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UUStockDetailShortBriefViewCell" owner:self options:nil] firstObject];
            [cell setValue:cellId forKey:@"reuseIdentifier"];
        }
        
        cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row][k_TITLE_];
        cell.contentLabel.text = self.dataArray[indexPath.section][indexPath.row][k_CONTENT_];
        
        return cell;
    }else
    {
        static NSString *cellId = @"UUStockDetailStockholderViewCellId";
        UUStockDetailStockholderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UUStockDetailShortBriefViewCell" owner:self options:nil] lastObject];
            [cell setValue:cellId forKey:@"reuseIdentifier"];

        }
//
        cell.holderNameLabel.text = self.dataArray[indexPath.section][indexPath.row][@"payYear"];
        cell.holdCountLabel.text = [@"10派" stringByAppendingString:[NSString stringWithFormat:@"%.2f",[self.dataArray[indexPath.section][indexPath.row][@"cashBtaxRmb"] doubleValue]]];
        cell.holdRateLabel.text = [self.dataArray[indexPath.section][indexPath.row][@"exdDividDndDate"] substringToIndex:10];
//
        return cell;
    }
}

@end

@implementation UUStockDetailShortBrief

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *viewId = @"UUStockDetailFinanceHeaderViewId";
    
    UUStockDetailFinanceHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (headerView == nil) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"UUStockDetailFinanceViewCell" owner:self options:nil] lastObject];
        [headerView setValue:viewId forKey:@"reuseIdentifier"];
    }
    
    if (section == 0) {
        headerView.titleLabel.text = @"公司简介";
    }else if (section == 1){
        headerView.titleLabel.text = @"分红配送";
    }
    
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



