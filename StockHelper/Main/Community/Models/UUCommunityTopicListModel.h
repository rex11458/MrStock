//
//  UUCommunityTopicListModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/2.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"
/*
 id	int	类目id
 subjectId	Int	话题ID
 relevanceId	String	关联ID
 userId	String	用户ID
 content	String	发表内容
 level	string	级别 0普通 1精华
 createTime	String	创建时间
 list结构
 
 
 
 名称	类型	描述
 id	int	话题ID
 relevanceId	String	关联ID
 userId	String	用户ID
 content	String	发表内容
 level	string	级别 0普通 1精华
 createTime	String	创建时间
 replyAmount	Int	回复数
 supportAmount	Int	点赞数
 userPic	String	用户头像
 userName	String	用户昵称
 fansAmount	Int	粉丝数

 */
@protocol UUCommunityTopicTopListModel



@end

@protocol UUCommunityTopicNormalListModel

@end

@interface UUCommunityTopicTopListModel : JSONModel

@property (nonatomic, assign) int           id;
@property (nonatomic, assign) NSInteger     subjectId;
@property (nonatomic, copy) NSString        *relevanceId;
@property (nonatomic, copy) NSString        *userId;
@property (nonatomic, copy) NSString        *content;
@property (nonatomic, copy) NSString        *level;
@property (nonatomic, copy) NSString        *createTime;
@end

/*
 content = "\U66f4\U597d\U7684\U597d\U597d\U7684\U56de\U7535\U8bdd\U5f88\U9ad8\U5174\U521a\U521a";
 createTime = "2015-07-20 19:21:33";
 fansAmount = 0;
 //id = 40;
 //images = "[\"e8f15916-c46d-435f-b228-4874b47b671c.jpg\",\"9a55d45f-206a-483c-b294-6422141aa483.jpg\"]";
 isOnTop = 0;
 isShow = 0;
 lastUpdateTime = "2015-07-20 19:21:33";
 level = 0;
 relevanceId = r1;
 replyAmount = 28;
 selfIsReply = 0;
 selfIsSupport = 0;
 supportAmount = 1;
 userId = 8DD39784CFE94F54BBBC4EE7C3571FDF;
 userName = zhuweifeng;
 userPic = "http://115.28.183.108/UserWeb/resources/headImg/1F4280A7FE7946F391ECCCD258AC3462.jpg";
 
 */

/*
 content = Ghdhshdhhdggddghdhdhsvvxvvxhhdshdghshhddhsh;
 createTime = "2015-10-28 18:21:18";
 //fans = 6;
 id = 99;
 images = "[\"e30261ac-87d5-4a7d-bc13-1c8dd9bb25e3.jpg\",\"ec2c89c0-35d8-43fb-b57f-c57680d43d6d.jpg\"]";
 isOnTop = 0;
 isShow = 0;
 lastUpdateTime = "2015-10-28 18:21:18";
 level = 0;
 messageType = 0;
 orderId = 0;
 relevanceId = "column_xsxt";
 replyAmount = 0;
 selfIsReply = 0;
 selfIsSupport = 0;
 supportAmount = 0;
 userId = CAABE68686304D88873EC261C3147EF0;
 userName = "\U6211\U4e0d\U662f\U4ef2\U5929\U742a12345";
 userPic = "http://115.28.183.108/UserWeb/resources/headImg/8CCBDF4ABB9B4250B71B13BCD7EF1F39.jpg";
 */
/*
 content = xxxxx;
 createTime = "2015-09-22 17:04:24";
 //fansAmount = 4;
 id = 92;
 images = "[\"3085b27b-1a22-47a3-a3d6-88837167c7b0.jpg\"]";
 level = 0;
 relevanceId = "column_xsxt";
 replyAmount = 0;
 selfIsReply = 0;
 selfIsSupport = 0;
 supportAmount = 0;
 userId = 5445F22DCFD243E8825008A1B93FFB59;
 userName = "\U4e0d\U8d25\U795e\U8bdd_wnnmm";
 userPic = "http://115.28.183.108/UserWeb/resources/headImg/4F0E5C22DBB74BB7809E7E3B7A4B26FD.jpg";

 */


@interface UUCommunityTopicNormalListModel : JSONModel
@property (nonatomic, assign) int                   id;
@property (nonatomic, copy) NSString                *relevanceId;
@property (nonatomic, copy) NSString                *userId;
@property (nonatomic, copy) NSString                *content;
@property (nonatomic, copy) NSString<Optional>      *userPic;
@property (nonatomic, copy) NSString<Optional>      *userName;
@property (nonatomic, copy) NSString                *images;

@property (nonatomic, copy) NSString                *createTime;
@property (nonatomic, copy) NSString                *lastUpdateTime;

@property (nonatomic,assign) NSInteger              replyAmount;
@property (nonatomic, assign) NSInteger             supportAmount;
@property (nonatomic, assign) NSInteger             fansAmount;

@property (nonatomic, copy) NSString                *level;
@property (nonatomic, assign) NSInteger             isOnTop;
@property (nonatomic,assign) NSInteger              isShow;
@property (nonatomic,assign) BOOL              selfIsReply;
@property (nonatomic,assign) BOOL              selfIsSupport;

@end

@interface UUCommunityTopicListModel : BaseModel

@property (nonatomic, copy) NSArray<UUCommunityTopicTopListModel> *topList;
@property (nonatomic, copy) NSArray<UUCommunityTopicNormalListModel> *list;
@property (nonatomic, copy) NSString *todayAmount;

@end


