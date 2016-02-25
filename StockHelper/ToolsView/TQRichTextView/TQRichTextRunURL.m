//
//  TQRichTextRunURL.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 2/27/14.
//  Copyright (c) 2014 fuqiang. All rights reserved.
//

#import "TQRichTextRunURL.h"
#define URL_MARK_L @"<"
#define URL_MARK_R @">"

@implementation TQRichTextRunURL

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [super decorateToAttributedString:attributedString range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:range];
}

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return TQRichTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString
{
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error = nil;
//    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
//   NSString *regulaStr = @"\\[[\\u4e00-\\u9fa5]+\\(\\d{6}\\)\\]";
    NSString *regulaStr = @"\\[[a-zA-Z0-9\u4E00-\u9FFF]*+\\(\\d{6}+[\\.INX]*\\)\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                    options:0
                                                      range:NSMakeRange(0, [string length])];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSRange rangeL = NSMakeRange(match.range.location, 1);
            NSRange rangeR = NSMakeRange(match.range.location + match.range.length - 1, 1);
            
            [attributedString replaceCharactersInRange:rangeL withString:@" "];
            [attributedString replaceCharactersInRange:rangeR withString:@" "];
            
            NSString *substringForMatch = [string substringWithRange:match.range];
            TQRichTextRunURL *run = [[TQRichTextRunURL alloc] init];
            run.range    = match.range;
            run.text     = substringForMatch;
            run.drawSelf = YES;
            [run decorateToAttributedString:attributedString range:match.range];
            [array addObject:run ];
        }
    }
    return array;
}


/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect
{
  
//    NSDictionary *attributes = @{};
//    [self.text drawInRect:rect withAttributes:attributes];
//
}

@end
