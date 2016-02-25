//
//  NSString+URLEncoding.m
//  BoceshQuote
//
//  Created by jagtu on 14-1-9.
//  Copyright (c) 2014年 66money. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <MTDates/NSDate+MTDates.h>
#import <MTDates/NSDateComponents+MTDates.h>

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


+ (NSString *)amountValueWithDouble:(double)value
{
    NSString *returnValue = [NSString stringWithFormat:@"%.2f",value];
    
    if (value == 0) {
        return @"--";
    }
    
    return returnValue;
}

+ (NSString *)amountTransformToPrice:(CGFloat)price
{
    NSMutableString *amount = [NSMutableString stringWithFormat:@"%.2f",price];
    
    if (price <= 0) {
        return @"--";
    }
    if(price > 10000 * 10000)
    {
        NSRange range = [amount rangeOfString:@"."];
        if (range.location != NSNotFound) {
            [amount deleteCharactersInRange:range];
            [amount insertString:@"." atIndex:amount.length - 10];
            CGFloat price = [amount floatValue];
            amount = [NSMutableString stringWithFormat:@"%.2f亿",price];
        }
 
    }
    else if (price > 10000)
    {
        NSRange range = [amount rangeOfString:@"."];
        if (range.location != NSNotFound) {
            [amount deleteCharactersInRange:range];
            [amount insertString:@"." atIndex:amount.length - 6];
            CGFloat price = [amount floatValue];
            amount = [NSMutableString stringWithFormat:@"%.2f万",price];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%li",(NSInteger)price];
    }
    return amount;
}

@end

@implementation NSString (JSON)

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"%@",[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]];
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"%@:%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

@end


@implementation NSString (Date)
/*
 *  i < 60s          刚刚
 *  1m*i      i<60   i分钟前
 *  1h*i      i<24   i小时前
 *  1d*i      i<30   i天前
 *  1d*30 * i i<12   i个月前
 *  1d*30*365*i      i年前
 *
*/
- (NSString *)customDateValue
{
    NSDate *createDate = [NSDate mt_dateFromString:self usingFormat:@"yyyy-MM-dd HH:mm:ss"];
 
    
    NSDate *nowDate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:nowDate];
    
    nowDate = [nowDate dateByAddingTimeInterval:interval];
    interval = [zone secondsFromGMTForDate:createDate];
    createDate = [createDate dateByAddingTimeInterval:interval];
    
    NSInteger sinceCreate = [nowDate timeIntervalSinceDate:createDate];

    NSString *text = nil;
    if (sinceCreate < MTDateConstantSecondsInMinute) {
        text = @"刚刚";
    }else if (sinceCreate < MTDateConstantSecondsInHour){
        text = [NSString stringWithFormat:@"%ld分钟前",[nowDate mt_minutesSinceDate:createDate]];
    }else if (sinceCreate < MTDateConstantSecondsInDay){
        text = [NSString stringWithFormat:@"%ld小时前",[nowDate mt_hoursSinceDate:createDate]];
    }else if(sinceCreate < MTDateConstantSecondsInMonth){
        text = [NSString stringWithFormat:@"%ld天前",[nowDate mt_daysSinceDate:createDate]];
    }else if (sinceCreate < MTDateConstantSecondsInYear){
        text = [NSString stringWithFormat:@"%ld月前",[nowDate mt_monthsSinceDate:createDate]];
    }else{
        text = [NSString stringWithFormat:@"%ld年前",[nowDate mt_yearsSinceDate:createDate]];
    }
    return text;
}

@end
