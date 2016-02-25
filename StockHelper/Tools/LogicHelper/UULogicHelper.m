//
//  UULogicHelper.m
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UULogicHelper.h"
#import "UIDevice+IdentifierAddition.h"
@implementation UULogicHelper

//获取设备唯一标示符
+(NSString *) getUniqueDeviceIdentifie
{
    NSString* deviceID = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        deviceID = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] MD5_16];
    }else{
        deviceID = [[[UIDevice currentDevice] uniqueDeviceIdentifier] MD5_16];
    }
    return [NSString stringWithFormat:@"I%@", deviceID];
}
@end

