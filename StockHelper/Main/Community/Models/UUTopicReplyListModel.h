//
//  UUTopicRepyListModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/8.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"
/*
 "list": [
 {
 "id": 1,
 "subjectId": 5,
 "userId": "111",
 "content": "hahahhahahahah",
 "orderId": 1,
 "tgtUserId": "",
 "tgtContent": "",
 "tgtOrderId": 0,
 "createTime": "2015-07-08 10:01:07"
 
 content = huifu31;
 createTime = "2015-09-07 15:09:52";
 id = 77;
 orderId = 106;
 subjectId = 3;
 tgtContent = "";
 tgtOrderId = 0;
 userId = 111;
 tgtUserId = "";

 
 userName = "<null>";
 userPic = "<null>";
 tgtUserName = "";
 tgtUserPic = "";

 }
 ]
 */
@protocol UUTopicReplyModel

@end
@interface UUTopicReplyModel : JSONModel

@property (nonatomic) NSInteger      id;
@property (nonatomic,copy) NSString  *subjectId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *tgtUserId;
@property (nonatomic, copy) NSString *tgtContent;
@property (nonatomic, assign) NSInteger tgtOrderId;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *userPic;
@property (nonatomic, copy) NSString<Optional> *tgtUserName;
@property (nonatomic, copy) NSString<Optional> *tgtUserPic;

@end

@interface UUTopicReplyListModel : BaseModel

@property (nonatomic,copy) NSArray<UUTopicReplyModel> *list;

@end

@interface UUTopicReplySubModel : NSObject

@property (nonatomic, copy) NSString    *tgtUserId;
@property (nonatomic,copy) NSString     *tgtUserName;
@property (nonatomic, copy) NSString    *tgtContent;
@property (nonatomic, assign) NSInteger tgtOrderId;

- (id)initWithTgtUserId:(NSString *)tgtUserId tgtUserName:(NSString *)tgtUserName tgtContent:(NSString *)tgtContent tgtOrderId:(NSInteger)tgtOrderId;
@end









