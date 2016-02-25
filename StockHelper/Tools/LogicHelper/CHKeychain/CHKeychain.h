//
//  CHKeychain.h
//  AirPos
//
//  Created by Administrator on 14-2-19.
//  Copyright (c) 2014年 AirPos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface CHKeychain : NSObject

+ (int)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (int)delete:(NSString *)service;

@end
