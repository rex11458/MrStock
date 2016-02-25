//
//  UUSocketManager.h
//  StockHelper
//
//  Created by LiuRex on 15/9/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncSocket.h>

UIKIT_EXTERN NSString * const SocketdidReceivedDataNotification;
UIKIT_EXTERN NSString *const  SocketdidDisconnectedNotification;

typedef void(^ReceivedData) (NSData *data);
typedef void(^Failure)(NSError *error);
typedef void (^Success)(AsyncSocket *socket);

enum{
    SocketOfflineByServer, //服务器掉线,默认为0
    SocketOfflineByUser    //用户主动下线
};


@interface UUSocketManager : NSObject <AsyncSocketDelegate>

@property (nonatomic,strong) AsyncSocket *socket;

@property (nonatomic, copy) NSString *host;

@property (nonatomic, assign) NSInteger port;

@property (nonatomic,strong) NSTimer *connectTimer; //计时器


@property (nonatomic,assign) BOOL showError;

@property (nonatomic, copy) ReceivedData receivedData;


@property (nonatomic, copy) Success success;


@property (nonatomic, copy) Failure failure;



+ (UUSocketManager *)manager;

//建立连接
- (void)socketConnetHost;
//断开连接
- (void)cutOffSocket;


@end
