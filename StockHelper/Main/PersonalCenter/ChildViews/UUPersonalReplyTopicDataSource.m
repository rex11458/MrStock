//
//  UUPersonalReplyTopicDataSource.m
//  StockHelper
//
//  Created by LiuRex on 15/10/30.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalReplyTopicDataSource.h"
#import "UUCommunityHandler.h"
#import "UUPersonalReplyViewCell.h"
@implementation UUPersonalReplyTopicDataSource

- (instancetype)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {

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
        /*话题信息*/
        [[UUCommunityHandler sharedCommunityHandler] getTopicListWithUserID:self.userId contentType:0 pageNo:self.pageIndex pageSize:self.pagesize success:^(NSArray *dataArray) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUPersonalReplyViewCellId";

    UUPersonalReplyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUPersonalReplyViewCell class]) owner:self options:nil] firstObject];
    }
    
    cell.replyModel = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}



@end
