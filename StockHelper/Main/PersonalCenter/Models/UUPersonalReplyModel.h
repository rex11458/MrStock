//
//  UUPersonalReplyModel.h
//  StockHelper
//
//  Created by LiuRex on 15/10/30.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalTopicModel.h"
/*
 *他的回帖
 * content = "1\U3001\U4e00\U6b65\U4e00\U5fae\U7b11\Uff0c\U4e00\U6b65\U4e00\U4f24\U5fc3\Uff0c\U4e00\U6b65\U4e00\U52ab\U96be\Uff0c\U5c3d\U7ba1\U8bb0\U5fc6\U518d\U60b2\U4f24\Uff0c\U6211\U5374\U7b11\U7740\Uff0c\U4e0d\U613f\U9057\U5fd8\U3002\n2\U3001\U6740\U5343\U964c \Uff1a\U767d\U5b50\U753b\Uff0c\U4f60\U82e5\U6562\U4e3a\U4f60\U95e8\U4e2d\U5f1f\U5b50\U4f24\U5979\U4e00\U5206\Uff0c\U6211\U4fbf\U5c60\U4f60\U6ee1\U95e8\Uff0c\U4f60\U82e5\U6562\U4e3a\U5929\U4e0b\U4eba\U635f\U5979\U4e00\U6beb\Uff0c\U6211\U4fbf\U6740\U5c3d\U5929\U4e0b\U4eba\U3002[\U5618][\U5618][\U5618][\U5618][\U5bb3\U7f9e]";
 createTime = "2015-07-21 14:08:00";
 fansAmount = 4;
 id = 3;
 images = "[\"84845a93-d052-43ff-b942-cf830de6132c.jpg\",\"9370cb08-0312-45c5-ab4b-82edcc3b3ded.jpg\",\"469ce959-47f0-4c1c-b280-39ebeab0a069.jpg\"]";
 level = 0;
 relevanceId = r1;
 replyAmount = 77;
 replyCreateTime = "2015-09-18 15:06:02";
 replyId = 180;
 replycontent = "\U70ed\U6069\U6069\U997f";
 selfIsReply = 1;
 selfIsSupport = 1;
 supportAmount = 4;
 userId = 5445F22DCFD243E8825008A1B93FFB59;
 userName = "\U4e0d\U8d25\U795e\U8bdd_wnnmm";
 userPic = "http://115.28.183.108/UserWeb/resources/headImg/4F0E5C22DBB74BB7809E7E3B7A4B26FD.jpg";
 */
@interface UUPersonalReplyModel : UUPersonalTopicModel

@property (nonatomic, copy) NSString *replyCreateTime;

@property (nonatomic,assign) NSInteger replyId;

@property (nonatomic, copy) NSString *replycontent;

+ (NSArray *)replyModelArrayWithDictionary:(NSDictionary *)dic;

@end
