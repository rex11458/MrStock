//
//  UUSocketManager.m
//  StockHelper
//
//  Created by LiuRex on 15/9/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUSocketManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
 NSString * const SocketdidReceivedDataNotification = @"SocketdidReceivedDataNotification";
 NSString *const SocketdidDisconnectedNotification = @"SocketdidDisconnectedNotification";

static NSTimeInterval time_out = -1;


@implementation UUSocketManager

+ (UUSocketManager *)manager
{
    static UUSocketManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
        sharedInstace.showError = YES;
    });
    
    return sharedInstace;
}

//建立连接
- (void)socketConnetHost
{
    if ([_socket isConnected]){
        [self cutOffSocket];
    }
    [self connetionToHost];
}

- (void)connetionToHost
{
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    [self.socket  connectToHost:k_SOCKET_HOST onPort:k_socket_PORT withTimeout:-1 error:&error];
}

//断开连接
- (void)cutOffSocket
{
    self.socket.userData = SocketOfflineByUser;
    [self.connectTimer invalidate];
    [self.socket disconnect];
}



- (void)longConnectToSocket
{
    //根据服务器要求发送固定格式的数据
    NSString *longConnet = @"";
    NSData *dataStream = [longConnet dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:-1 tag:11];
}

#pragma mark - AsyncSocketDelegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket连接成功!");
    _showError = YES;
    if (_success) {
        _success(sock);
    }
    
    [sock readDataWithTimeout:time_out tag:0];
    
    //每30s向服务器发送心跳包
    //    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    //    [self.connectTimer fire];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"sorry the connet is failure %ld",sock.userData);
    
    if (sock.userData == SocketOfflineByServer) {
        //服务器断线
//        if (_showError) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:SocketdidDisconnectedNotification object:err userInfo:nil];
//            _showError = NO;
//            [SVProgressHUD showErrorWithStatus:@"连接服务器失败!"];
//        }
        [self socketConnetHost];
    }else if (sock.userData == SocketOfflineByUser){
        //用户自动断开
        return;
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NETWORK_ACTIVITY_INDICATOR_VISIBLIE(NO);
    [self.socket readDataWithTimeout:time_out tag:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SocketdidReceivedDataNotification object:data userInfo:nil];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NETWORK_ACTIVITY_INDICATOR_VISIBLIE(YES);
}
@end
