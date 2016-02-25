//
//  NSObject+Extension.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (BOOL)isNull
{
    return [self isMemberOfClass:[NSNull class]];
}

@end
 