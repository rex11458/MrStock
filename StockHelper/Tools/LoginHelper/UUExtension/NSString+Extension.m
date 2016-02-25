//
//  NSString+URLEncoding.m
//  BoceshQuote
//
//  Created by jagtu on 14-1-9.
//  Copyright (c) 2014年 66money. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self, NULL,CFSTR("!*'()^;:@&=+$,/?%#[]"),kCFStringEncodingUTF8));

    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self, CFSTR(""),  kCFStringEncodingUTF8));

    return result;
}

-(NSString *)MD5String
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}

- (NSString *)MD5_16
{
    NSString *md5String = [self MD5String];
    
    NSRange range = NSMakeRange(7, 16);
    
    return [md5String substringWithRange:range];
}

-(NSString *) usesGroupingSeparator:(NSString *)separator withGroupingSize:(int)size
{
    NSString * tempString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * newString = @"";
    while (tempString.length > 0) {
        NSString * subString = [self substringToIndex:MIN(tempString.length, size)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == size && subString.length != tempString.length) {
            newString = [newString stringByAppendingString:@" "];
        }
        tempString = [tempString substringFromIndex:MIN(tempString.length, size)];
    }
    return [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)secureString
{
    NSString *md5String = [self MD5String];
    
    NSMutableString *secureString = [md5String mutableCopy];
    
    NSString *str0 = [secureString substringToIndex:1];
    NSString *str2 = [secureString substringWithRange:NSMakeRange(2, 1)];
    [secureString replaceCharactersInRange:NSMakeRange(0, 1) withString:str2];
    [secureString replaceCharactersInRange:NSMakeRange(2, 1) withString:str0];
    
    unsigned long length = secureString.length;
    unichar a[length];
    
    for (int i = 0; i <length; i++) {
        unichar c = [secureString characterAtIndex:length - i - 1];
        a[i] = c;
    }
    
    return [NSString stringWithCharacters:a length:length];
}

@end
