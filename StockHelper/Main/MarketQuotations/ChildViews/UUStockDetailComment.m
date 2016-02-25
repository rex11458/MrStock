//
//  UUStockDetailComment.m
//  StockHelper
//
//  Created by LiuRex on 15/6/19.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailComment.h"
#import "UUCommunityHandler.h"
#import "UUCommunityTopicListModel.h"
@implementation UUStockDetailCommentDataSource

- (instancetype)initWithStockCode:(NSString *)stockCode
{
    if (self = [super init]) {
        self.dataSourceType = 0;
        self.stockCode = stockCode;
        self.type = 0;
        self.pageIndex = 1;
        self.pagesize = 10;
    }
    return self;
}


- (instancetype)initWithUserId:(NSString *)userId;
{
    if (self = [super init]) {
        self.dataSourceType = 1;
        self.userId = userId;
        self.type = 0;
        self.pageIndex = 1;
        self.pagesize = 10;
    }
    return self;
}


- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailueBlock)failure
{
    if (type)
    {
        self.pageIndex++;
    }
    else
    {
        self.pageIndex = 1;
    }
    
    
    if (self.dataSourceType == 0) {
        [[UUCommunityHandler sharedCommunityHandler] getCommunityTopicListWithRelevanceId:self.stockCode status:0 type:1 pageNo:self.pageIndex pageSize:self.pagesize success:^(UUCommunityTopicListModel *listModel) {
            if (type == 0) {
                self.dataArray = listModel.list;
            }else{
                self.dataArray = [self.dataArray arrayByAddingObjectsFromArray:listModel.list];
            }
            if (success) {
                success(self.dataArray);
            }
        } failure:^(NSString *errorMessage) {
            if (failure) {
                failure(errorMessage);
            }
        }];
    }else if (self.dataSourceType == 1){
        
        /*话题信息*/
        [[UUCommunityHandler sharedCommunityHandler] getTopicListWithUserID:self.userId contentType:1 pageNo:self.pageIndex pageSize:self.pagesize success:^(NSArray *dataArray) {

            if (type == 0) {
                self.dataArray = dataArray;
            }else{
                self.dataArray = [self.dataArray arrayByAddingObjectsFromArray:dataArray];
            }

            if (success) {
                success(self.dataArray);
            }

        } failure:^(NSString *errorMessage) {
            
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = UUStockDetailCommentViewCellId;
    
    UUStockDetailCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    cell.delegate = self.delegate;
    
    cell.normalListModel = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end

@implementation UUStockDetailComment

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UUStockDetailCommentViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_indexPath) {
        _indexPath(indexPath);
    }
}
- (void)setSelectedIndexPath:(void(^)(NSIndexPath *))indexPath
{
    _indexPath = [indexPath copy];
}

@end
