//
//  UUTopicPraiseListModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/8.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"

/*
 list	Y	用户列表
 
 list结构
 名称	类型	描述
 userId	String	用户ID
 userName	String	用户昵称
 userPic	String	用户头像
 */
@protocol UUTopicPraiseModel

@end

@interface UUTopicPraiseModel : JSONModel

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPic;


@end

@interface UUTopicPraiseListModel : BaseModel

@property (nonatomic, copy) NSArray<UUTopicPraiseModel> *list;


@end
