//
//  AppDelegate.m
//  StockHelper
//
//  Created by LiuRex on 15/5/8.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUAppDelegate.h"
#import "UUTabbarController.h"
#import "UUNetworkClient.h"
#import "BaseNavigationController.h"
#import "UUThemeManager.h"
#import "UUStockListViewController.h"

#import "UUMarketQuationHandler.h"
#import "UUDatabaseManager.h"
#import "UUSocketManager.h"
#import "UULoginViewController.h"
#import "UURegisterViewController.h"
@interface UUAppDelegate ()
{
    id _observer;
}
@end

@implementation UUAppDelegate

- (void)connectSocket
{
    [[UUSocketManager manager]  socketConnetHost];
}

- (void)getStockList
{
    /*
     *获取沪深股票列表
     */
//    selectStockModelWithCondition
    UUStockModel *model = [[UUDatabaseManager manager] selectStockModelWithCode:@"000001" market:1];
    if(model) return;
    
    _observer = [[UUMarketQuationHandler sharedMarkeQuationHandler] getStockListSuccess:^(NSArray *stockModelArray) {
        
        if (stockModelArray != nil && stockModelArray.count > 0) {
            [[UUDatabaseManager manager] updateStockModelArray:stockModelArray];
        }
        
        removeObserver(_observer);
    } failure:^(NSString *errorMessage) {
        removeObserver(_observer);
    }];
}

- (void)initRootViewController
{
    UUTabbarController *tabbarController = [[UUTabbarController alloc] init];
    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:tabbarController];
    self.window.rootViewController = baseNav;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //    //通知
    //    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
    //                                                   UIRemoteNotificationTypeSound |
    //                                                   UIRemoteNotificationTypeAlert)
    //                                       categories:nil];
    //    [APService setupWithOption:launchOptions];
    
    [self initRootViewController];
    
    //    [self configSubViews];
    
    //连接Socket服务器
    //    [SVProgressHUD showWithStatus:@"连接服务器" maskType:SVProgressHUDMaskTypeBlack];
    [self connectSocket];
    

    [[UUSocketManager manager] setSuccess:^(AsyncSocket *socket){
        [[UUStockListViewController sharedUUStockListViewController] loadData];
        [self performSelector:@selector(getStockList) withObject:nil afterDelay:2];
    }];
    
    [UUSocketManager manager].failure = ^(NSError *error){
        
        [SVProgressHUD showErrorWithStatus:@"通信失败"];
        
    };
    
    //主题
    [UUThemeManager customAppAppearance];
    return YES;
}


- (void)initRefreshTime
{
    NSInteger sec = 5; //行情默认5秒刷新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger value = [[[NSUserDefaults standardUserDefaults] objectForKey:UUMarketQuotationTimeInfoKey] integerValue];
    if (value < sec) {
        [defaults setObject:@(sec) forKey:UUMarketQuotationTimeInfoKey];
        [defaults synchronize];
    }
}

@end
