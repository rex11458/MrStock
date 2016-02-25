//
//  UUTrandeAnalyHistory.m
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTrandeAnalyHistory.h"
#import "UUTradeHistoryViewCell.h"
#import "UUTransactionHandler.h"
#import <MTDates/NSDate+MTDates.h>
@implementation UUTrandeAnalyHistoryDataSource


- (instancetype)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {
        self.userId = userId;
    }
    
    return self;
}

- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSDate *nowDate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:nowDate];
    
    nowDate = [nowDate dateByAddingTimeInterval:interval];
    
    //默认三个月间隔
    NSDate *startDate = [nowDate mt_dateMonthsBefore:3];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = MTDatesFormatISODate;
    
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];

    [[UUTransactionHandler sharedTransactionHandler] getPositionHistoryWithUserId:self.userId startDate:startDateString endDate:nowDateString success:^(id obj) {
        
        self.dataArray = obj;
        if (success) {
            success(obj);
        }
        
    } failure:^(NSString *errorMessage) {
        if (failure) {
            failure(errorMessage);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUTradeHistoryViewCell";
    
    UUTradeHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUTradeHistoryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        //        cell.delegate = self;
    }

    cell.dealModel = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end

@implementation UUTrandeAnalyHistory

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUTradeHistoryViewCellHeight;
}
@end
