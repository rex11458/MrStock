//
//  UUStockDetailStockHolder.m
//  StockHelper
//
//  Created by LiuRex on 15/11/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailStockHolder.h"
#import "UUStockDetailFinanceViewCell.h"
#import "UUStockDetailStockholderViewCell.h"
#import "UUMarketQuationHandler.h"
#define k_STOCK_COUNT @"stockCount"

static NSString *dateString = nil;

@implementation UUStockDetailStockHolderDataSource

- (instancetype)initWithStockCode:(NSString *)stockCode
{
    if (self = [super init]) {
        self.stockCode = stockCode;
    }
    return self;
}

- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailueBlock)failure
{
    //总股本
    [[UUMarketQuationHandler sharedMarkeQuationHandler] getTotalStockWithStockCode:self.stockCode success:^(NSDictionary *jsonDictionary) {
        
        double totalCount = [jsonDictionary[@"totalShare"] doubleValue];
        double flowerCount = [jsonDictionary[@"listSharout"] doubleValue];
        NSArray *dataArray = @[
                               [[NSString amountTransformToPrice:totalCount] stringByAppendingString:@"股"],
                               [[NSString amountTransformToPrice:flowerCount] stringByAppendingString:@"股"]
                                      ];
        self.stockTotalArray = dataArray;
        if (success) {
            success(self.stockTotalArray);
        }
        
    } failure:^(NSString *errorMessage) {
        
    }];
    //十大流通股
    [[UUMarketQuationHandler sharedMarkeQuationHandler] getStockholderWithStockCode:self.stockCode success:^(NSArray *jsonArray) {
        self.stockholderArray = jsonArray;
        dateString = jsonArray[0][@"noticeDate"];

        if (success) {
            success(self.stockholderArray);
        }
        
        
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"UUStockDetailFinanceViewCellId";
        UUStockDetailFinanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UUStockDetailFinanceViewCell" owner:self options:nil] firstObject];
            [cell setValue:cellId forKey:@"reuseIdentifier"];
        }
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"总股本";
        }else if (indexPath.row == 1){
            cell.titleLabel.text = @"流通A股";
        }
        
        if (_stockTotalArray.count == 2) {
            cell.contentLabel.text = [_stockTotalArray objectAtIndex:indexPath.row];
        }
        return cell;
    }else
    {
        static NSString *cellId = @"UUStockDetailStockholderViewCell2Id";
        UUStockDetailStockholderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUStockDetailStockholderViewCell class]) owner:self options:nil] firstObject];
            [cell setValue:cellId forKey:@"reuseIdentifier"];
        }
        if (_stockholderArray.count == 10) {
            NSString *name = [self.stockholderArray objectAtIndex:indexPath.row][@"sharehdName"];
            double count = [[self.stockholderArray objectAtIndex:indexPath.row][@"sharehdNum"] doubleValue];
            double rate = [[self.stockholderArray objectAtIndex:indexPath.row][@"sharehdRatio"] doubleValue];
            cell.holderNameLabel.text = name;
            cell.holdCountLabel.text = [NSString amountTransformToPrice:count];
            cell.holdRateLabel.text = [NSString stringWithFormat:@"%.2f%%",rate];
        }
        return cell;
    }
    return nil;
}

@end

@implementation UUStockDetailStockHolder

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *viewId = @"UUStockDetailFinanceHeaderViewId";
    
    UUStockDetailFinanceHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (headerView == nil) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"UUStockDetailFinanceViewCell" owner:self options:nil] lastObject];
        [headerView setValue:viewId forKey:@"reuseIdentifier"];
    }
    if (section == 0) {
        headerView.titleLabel.text = @"股本结构";
        headerView.subTitleLabel.text =@"";

    }else if (section == 1){
        headerView.titleLabel.text = @"十大流通股东";
        if (dateString.length > 11) {
            headerView.subTitleLabel.text =[dateString substringToIndex:11];
        }
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
