//
//  NSString+URLEncoding.h
//  BoceshQuote
//
//  Created by 胡明星 on 14-1-9.
//  Copyright (c) 2014年 66money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
CFStringRef CFURLCreateStringByReplacingPercentEscapes (
                                                        CFAllocatorRef allocator,
                                                        CFStringRef    originalString,
                                                        CFStringRef    charactersToLeaveEscaped
                                                        );

- (NSString*)URLDecodedString;
- (NSString *)URLEncodedString;
-(NSString *)MD5String;
- (NSString *)MD5_16;
-(NSString *) usesGroupingSeparator:(NSString *)separator withGroupingSize:(int)size;


/*
 密码加密字符串
 密码加密方法 MD5的第三个字符放到文首，然后再做对称交换（首字符和尾字符交换）
 */
- (NSString *)secureString;




@end
