//
//  AppDelegate.m
//  StockHelper
//
//  Created by LiuRex on 15/5/8.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUAppDelegate.h"
#import "UUTabbarController.h"
#import <ShareSDK/ShareSDK.h>
#import "UUNetworkClient.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "BaseNavigationController.h"
#import "UUThemeManager.h"
#import "APService.h"
#import <UMengAnalytics-NO-IDFA/MobClick.h>

#import "UUIntroductionView.h"

#import "UUMarketQuationHandler.h"
#import "UUDatabaseManager.h"
#import "UUSocketManager.h"
#import "UULoginViewController.h"
#import "UURegisterViewController.h"
@interface UUAppDelegate ()<WXApiDelegate,UUIntroductionViewDelegate>
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

- (void)showIntroductionView
{
    //显示引导页
    if (![UUIntroductionView equalVersion]) {
        UUIntroductionView *introductionView = [[[NSBundle mainBundle] loadNibNamed:@"UUIntroductionView" owner:self options:nil] lastObject];
        introductionView.delegate = self;
        [introductionView show];
    }
}

#pragma mark - UUIntroduc.tionViewDelegate
- (void)introductionView:(UUIntroductionView *)introductionView didSelectedIndex:(NSInteger)index
{
    BaseNavigationController *nvc = (BaseNavigationController *)self.window.rootViewController;
    
    if (index == 0) {
        //注册
        UURegisterViewController *registerVC = [[UURegisterViewController alloc] init];
        //引导页进入页面
        registerVC.registerType = 1;
        [nvc pushViewController:registerVC animated:YES];
    }else if (index == 1){
        //登录
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:(nvc.viewControllers.count - 1) success:^{
            
        } failed:^{
            
        }];
        [nvc pushViewController:loginVC animated:YES];
    }
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
    
    //是否显示引导页
    [self showIntroductionView];
    
    //连接Socket服务器
    //    [SVProgressHUD showWithStatus:@"连接服务器" maskType:SVProgressHUDMaskTypeBlack];
    [self connectSocket];
    [[UUSocketManager manager] setSuccess:^(AsyncSocket *socket){
        [self getStockList];
        //        [SVProgressHUD showSuccessWithStatus:@"连接成功!"];
    }];
    
    [UUSocketManager manager].failure = ^(NSError *error){
        
        [SVProgressHUD showErrorWithStatus:@"通信失败"];
        
    };
    
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    //主题
    [UUThemeManager customAppAppearance];
    // 分享
    [ShareSDK registerApp:@"58122a897162"];
    //友盟统计
    [MobClick setAppVersion:k_Xcode_AppVersion];
    [MobClick startWithAppkey:k_Umeng_AppKey reportPolicy:BATCH channelId:nil];
#if DEBUG
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setLogEnabled:YES];
#endif
    
    //分享
    [self initShared];
    //行情刷新时间
    //    [self initRefreshTime];
    
    return YES;
}

void UncaughtExceptionHandler(NSException *exception) {
    
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSLog(@"%@,%@",name,reason);
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

- (void)initShared
{
    //    //微信
    [ShareSDK connectWeChatWithAppId:@"wxc7334e99a27f4c5a"
                           appSecret:@"2734029b53c4073d1eadcc52c35db722"
                           wechatCls:[WXApi class]];
    
    //    //新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:@"2867002513"
                               appSecret:@"c26f06f8888675b19ee4556907fea781"
                             redirectUri:@"http://www.66toutou.com"];
    
    //    //连接QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"1104714547"
                           appSecret:@"rHqCucsvBcb15GeW"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    ////    //连接QQ应用
    //    [ShareSDK connectQQWithQZoneAppKey:@"1103966657"
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                      tencentOAuthCls:[TencentOAuth class]];
    ////    /**
    ////     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
    ////     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
    ////
    ////     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
    ////     **/
    
}

//
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

/*
 //
 - (void)application:(UIApplication *)application
 didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 //    rootViewController.deviceTokenValueLabel.text =
 //    [NSString stringWithFormat:@"%@", deviceToken];
 //    rootViewController.deviceTokenValueLabel.textColor =
 //    [UIColor colorWithRed:0.0 / 255
 //                    green:122.0 / 255
 //                     blue:255.0 / 255
 //                    alpha:1];
 //    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
 [APService registerDeviceToken:deviceToken];
 }
 
 
 - (void)application:(UIApplication *)application
 didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
 NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
 }
 
 - (void)application:(UIApplication *)application
 didReceiveRemoteNotification:(NSDictionary *)userInfo {
 [APService handleRemoteNotification:userInfo];
 
 NSLog(@"收到通知:%@", [self logDic:userInfo]);
 }
 
 - (void)application:(UIApplication *)application
 didReceiveRemoteNotification:(NSDictionary *)userInfo
 fetchCompletionHandler:
 (void (^)(UIBackgroundFetchResult))completionHandler {
 [APService handleRemoteNotification:userInfo];
 NSLog(@"收到通知:%@", [self logDic:userInfo]);
 //    [rootViewController addNotificationCount];
 NSString *message = [self logDic:userInfo];
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
 [alertView show];
 
 
 completionHandler(UIBackgroundFetchResultNewData);
 }
 
 
 
 - (void)application:(UIApplication *)application
 didReceiveLocalNotification:(UILocalNotification *)notification {
 [APService showLocalNotificationAtFront:notification identifierKey:nil];
 }
 
 
 // log NSSet with UTF8
 // if not ,log will be \Uxxx
 - (NSString *)logDic:(NSDictionary *)dic {
 if (![dic count]) {
 return nil;
 }
 NSString *tempStr1 =
 [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
 withString:@"\\U"];
 NSString *tempStr2 =
 [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
 NSString *tempStr3 =
 [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
 NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
 NSString *str =
 [NSPropertyListSerialization propertyListFromData:tempData
 mutabilityOption:NSPropertyListImmutable
 format:NULL
 errorDescription:NULL];
 return str;
 }
 
 
 - (void)applicationWillResignActive:(UIApplication *)application {
 // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
 // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
 }
 
 - (void)applicationDidEnterBackground:(UIApplication *)application {
 // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
 // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
 [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
 
 }
 
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
