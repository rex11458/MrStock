//
//  UUCommunityColumnsModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"
/*
 {
 "statusCode": "0",
 "message": "",
 "data": {
 "columns": [
 {
 "id": 1,
 "relevanceId": "xsxt",
 "type": 1,
 "name": "来炒股",
 "image": null,
 "description": "来来来",
 "orderId": 1,
 "isShow": 0,
 "subjectAmount": 0,
 "replyAmount": 0
 }
 ]
 }
 }
 */

@protocol  UUCommunityColumnsModel

@end
@interface UUCommunityColumnsModel : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *relevanceId;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString<Optional> *image;
@property (nonatomic, copy) NSString *columnDescription;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSInteger isShow;
@property (nonatomic, assign) NSInteger subjectAmount;
@property (nonatomic, assign) NSInteger replyAmount;


@end

@interface UUCommunityColumnsListModel : BaseModel


@property (nonatomic, copy) NSArray<UUCommunityColumnsModel> *columns;


@end