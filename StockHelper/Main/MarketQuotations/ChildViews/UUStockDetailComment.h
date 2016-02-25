//
//  UUStockDetailComment.h
//  StockHelper
//
//  Created by LiuRex on 15/6/19.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//
#import "BaseDataSource.h"
#import "UUStockDetailCommentViewCell.h"

@interface UUStockDetailCommentDataSource : BaseDataSource<UITableViewDataSource>

@property (nonatomic,copy) NSString *stockCode;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic,assign) NSInteger dataSourceType; //0 股票评论列表   //1 个人话题回复列表

@property (nonatomic,weak) id<UUStockDetailCommentViewCellDelegate> delegate;

- (instancetype)initWithStockCode:(NSString *)stockCode;

- (instancetype)initWithUserId:(NSString *)userId;




@end

@interface UUStockDetailComment : NSObject<UITableViewDelegate>
{
    void(^_indexPath)(NSIndexPath *);
}
- (void)setSelectedIndexPath:(void(^)(NSIndexPath *))indexPath;

@end
