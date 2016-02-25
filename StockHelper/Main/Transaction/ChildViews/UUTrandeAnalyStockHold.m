//
//  UUTrandeAnalyStockHold.m
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTrandeAnalyStockHold.h"
#import "UUVirtualTansactionHoldStockViewCell.h"
#import "UUTransactionHandler.h"
@implementation UUTrandeAnalyStockHoldDataSource

- (instancetype)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {
        self.userId = userId;
    }
    
    return self;
}

- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailueBlock)failure
{
    [[UUTransactionHandler sharedTransactionHandler] getHoldWithUserId:self.userId success:^(NSArray *dataArray) {
        self.dataArray = dataArray;
        if (success) {
            success(dataArray);
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
    static NSString *cellId = @"UUVirtualTansactionHoldStockViewCell";
    
    UUVirtualTansactionHoldStockViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUVirtualTansactionHoldStockViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        cell.delegate = self;
    }
    cell.holdModel = [self.dataArray objectAtIndex:indexPath.row];

    return cell;
}

@end

@implementation UUTrandeAnalyStockHold
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = UUVirtualTansactionHoldStockViewCellHeight;
    
    if (_selectedIndexPath != nil && _selectedIndexPath.row == indexPath.row) {
        
        
        return height + 50.0f;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndexPath = indexPath;
    UUVirtualTansactionHoldStockViewCell *cell = (UUVirtualTansactionHoldStockViewCell *)[tableView cellForRowAtIndexPath:_selectedIndexPath];
    NSArray *cells = [tableView visibleCells];
    for (UUVirtualTansactionHoldStockViewCell *tempCell in cells) {
        tempCell.hiddenButtonView = YES;
    }
    cell.hiddenButtonView = NO;
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

@end
