//
//  AppConfig.h
//  StockHelper
//
//  Created by LiuRex on 15/5/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#ifndef StockHelper_AppConfig_h
#define StockHelper_AppConfig_h



//股票开盘时间
#define k_STOCK_OPEN_DATE @"1970-1-1 09:30:00"

#define SZ_CRC_CODE_KEY @"sz_crc_code_key"
#define SS_CRC_CODE_KEY @"ss_crc_code_key"

//是否是指数
#define k_IS_INDEX(market) !((market & 0xff) == UUStockExchangeAShareType || (market & \
                        0xff) == UUStockExchangePannikinType || (market & 0xff) == \
                            UUStockExchangeChiNextType)

//友盟AppKey
#define k_Umeng_AppKey @"55dc01c067e58e0772000ff1"
//版本
#define k_Xcode_AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//设备宽高
#define PHONE_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGHT    [[UIScreen mainScreen] bounds].size.height
//版本
#define SCREEN_IOS_VS [[[UIDevice currentDevice] systemVersion] floatValue]

//网络是否可用
#define NETWORK_UNAVAILABLE [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable

//网络错误提示
#define NETWORK_ERROR_MESSAGE      @"网络请求失败,请稍后重试~"

#define NETWORK_UNAVAILABLE_MESSAGE  @"网络连接错误,请检查网络~"

//错误提示以及空数据提示
#define k_remainder(key)    [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UUMarkWords.plist" ofType:nil]] valueForKey:key]

#define NETWORK_ACTIVITY_INDICATOR_VISIBLIE(isVisible) [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isVisible]


//控件边距
#define k_LEFT_MARGIN  10.0f
#define k_RIGHT_MARGIN 10.0f
#define k_TOP_MARGIN   10.0f
#define k_BOTTOM_MARGIN 10.0f


//搜索键盘高度
#define KEYBOARD_HEIGHT  178.0f

//tabbar高度
#define k_TABBER_HEIGHT 49.0f

#define k_F10INFO_HEIGHT 30.0f


#define k_NAVIGATION_BAR_COLOR [UIColorTools colorWithHexString:@"#FF5C5C" withAlpha:1.0f]

//页面背景色
#define k_BG_COLOR [UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f]
//分割线颜色
#define k_LINE_COLOR [UIColorTools colorWithHexString:@"#DBDBDB" withAlpha:1.0f]

//cell选中后的背景
#define k_TABLEVIEWCELL_SELECTED_IMAGE [UIKitHelper imageWithColor:[UIColorTools colorWithHexString:@"#000000" withAlpha:0.1]]

//大号文字颜色
#define k_BIG_TEXT_COLOR [UIColorTools colorWithHexString:@"#474747" withAlpha:1.0f]
//大号文字字体
#define k_BIG_TEXT_FONT [UIFont boldSystemFontOfSize:16.0f]

#define k_MIDDLE_TEXT_COLOR [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]
#define k_MIDDLE_TEXT_FONT [UIFont systemFontOfSize:14.0f]

#define k_SMALL_TEXT_FONT [UIFont boldSystemFontOfSize:12.0f]

//股票链接颜色
#define k_STOCK_LINK_COLOR @"#2697E3"
//涨跌颜色
#define k_UPPER_COLOR_VALUE @"E81B00"
#define k_UPPER_COLOR  [UIColorTools colorWithHexString:@"#E81B00" withAlpha:1.0f]

#define k_UNDER_COLOR_VALUE @"5CD274"
#define  k_UNDER_COLOR [UIColorTools colorWithHexString:@"5CD274" withAlpha:1.0f]

#define k_EQUAL_COLOR_VALUE @"ADADAD"
#define k_EQUAL_COLOR  [UIColorTools colorWithHexString:@"ADADAD" withAlpha:1.0f]

//均线颜色
#define k_SHARE_TIME_COLOR @"DB3396"
#define K_SHARE_TIME_AVG_COLOR @"03ACE5"
//行情刷新时间（秒）
#define k_MARKET_QUOTATION_SECONDS [[[NSUserDefaults standardUserDefaults] objectForKey:UUMarketQuotationTimeInfoKey] integerValue]

#define UUMarketQuotationTimeInfoKey @"UUMarketQuotationTimeInfoKey"

#endif






