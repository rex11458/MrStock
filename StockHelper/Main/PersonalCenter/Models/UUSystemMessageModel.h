//
//  UUSystemMessageModel.h
//  StockHelper
//
//  Created by LiuRex on 15/11/2.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <JSONModel/JSONModel.h>
/*
 addresseeID = 5445F22DCFD243E8825008A1B93FFB59;
 addresserID = "<null>";
 createDate = "<null>";
 listID = 28;
 messageContext = "<null>";
 messageDate = 1445590902582;
 messageID = 13;
 messageType = "<null>";
 readDate = 0;
 templetID = "<null>";
 */
@protocol UUSystemMessageModel

@end

@interface UUSystemMessageModel : JSONModel

@property (nonatomic, copy) NSString *addresseeID;
@property (nonatomic, copy) NSString<Optional> *addresserID;
@property (nonatomic, copy) NSString<Optional> *createDate;
@property (nonatomic,assign) NSInteger listID;
@property (nonatomic, copy) NSString<Optional> *messageDate;
@property (nonatomic,assign) NSInteger messageID;
@property (nonatomic, copy) NSString<Optional> *messageType;
@property (nonatomic,assign) NSInteger readDate;
@property (nonatomic, copy) NSString<Optional> *templetID;

@end

@interface UUSystemMessageListModel : JSONModel

@property (nonatomic, copy) NSArray<UUSystemMessageModel> *data;

@end