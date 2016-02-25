//
//  UURichTextView.m
//  StockHelper
//
//  Created by LiuRex on 15/9/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UURichTextView.h"

static NSDictionary *g_emojiDictionary;
static NSArray *g_emojiArray;

@implementation UURichTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.editable = NO;
        self.scrollEnabled = NO;
        self.delegate = self;
        
        g_emojiDictionary = [UURichTextView emojiDictionary];
        g_emojiArray = [UURichTextView emojiStringArray];

        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame selectStock:(void(^)(NSString *stockCode))selectStock
{
    if (self = [self initWithFrame:frame]) {
        _selectStock = [selectStock copy];
    }
    return self;
}

+ (NSString *)keyFromEmojiName:(NSString *)_name
{
    __block NSString *_key = nil;
    [g_emojiDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString  *name, BOOL * _Nonnull stop) {
        
        if ([_name isEqualToString:name]) {
            _key = key;
            return ;
        }
    }];
    return _key;
}


+ (NSDictionary *)emojiDictionary
{
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"_expression_en" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
}

+ (NSArray *) emojiStringArray
{
    NSDictionary *dic = [self emojiDictionary];
    
    return [dic allValues];
}



- (void)setText:(NSString *)text
{
    if (self.font == nil) {
        self.font = k_MIDDLE_TEXT_FONT;
    }
    if (self.textColor == nil) {
        self.textColor = k_BIG_TEXT_COLOR;
    }
    NSDictionary *attributes = @{ NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor};
    NSAttributedString * attText = [[UURichTextView emojjAttributedString:text attributes:attributes] mutableCopy];
    attText = [UURichTextView urlAttributedString:attText];
    [super setAttributedText:attText];
}

- (NSString *)text
{
    return self.attributedText.string;
}

+ (NSAttributedString *)emojjAttributedString:(NSString *)text attributes:(NSDictionary *)attributes
{
    NSString *markL       = @"[";
    NSString *markR       = @"]";
    UIFont *font = [attributes objectForKey:NSFontAttributeName];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    NSMutableArray *stack = [NSMutableArray array];
    
    for (int i = 0; i < attString.string.length; i++)
    {
        NSString *s = [attString.string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
        {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
            {
                [stack removeAllObjects];
            }
            
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == attString.string.length - 1))
            {
                NSMutableString *emojiStr = [[NSMutableString alloc] init];
                for (NSString *c in stack)
                {
                    [emojiStr appendString:c];
                }
                
                if ([[UURichTextView emojiStringArray] containsObject:emojiStr])
                {
                    NSRange range = NSMakeRange(i + 1 - emojiStr.length, emojiStr.length);
                    
                    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                    attachment.bounds = CGRectMake(0,font.descender,font.lineHeight,font.lineHeight);
                    attachment.image = [UIImage imageNamed:[self keyFromEmojiName:emojiStr]];
                    NSAttributedString *subAttString = [NSAttributedString attributedStringWithAttachment:attachment];
                    [attString replaceCharactersInRange:range withAttributedString:subAttString];
                    
                    i = 0;
                }
                [stack removeAllObjects];
            }
        }
    }
    return attString;
}

+ (NSAttributedString *)urlAttributedString:(NSAttributedString *)attributeString
{
    NSMutableAttributedString *attString = [attributeString mutableCopy];
    NSMutableDictionary *mAttributes = [NSMutableDictionary dictionary];
    [mAttributes setObject:[UIColorTools colorWithHexString:k_STOCK_LINK_COLOR withAlpha:1.0f] forKey:NSForegroundColorAttributeName];
    [mAttributes setObject:k_MIDDLE_TEXT_FONT forKey:NSFontAttributeName];
    
    NSError *error = nil;
    NSString *regulaStr = @"\\[[a-zA-Z0-9\u4E00-\u9FFF]*+\\(\\d{6}+[\\.INX]*\\)\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:attString.string
                                                    options:0
                                                      range:NSMakeRange(0, [attString.string length])];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSRange rangeL = NSMakeRange(match.range.location, 1);
            NSRange rangeR = NSMakeRange(match.range.location + match.range.length - 1, 1);
            [attString replaceCharactersInRange:rangeL withString:@" "];
            [attString replaceCharactersInRange:rangeR withString:@" "];
            
            [mAttributes setObject:[attString.string substringWithRange:NSMakeRange(match.range.location + 1, match.range.length - 2)] forKey:NSLinkAttributeName];
            
            [attString setAttributes:mAttributes range:match.range];
        }
    }
    return attString;
}


+ (NSAttributedString *)urlAttributedString:(NSString *)text attributes:(NSDictionary *)attributes
{
    NSString *string = text;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    NSMutableDictionary *mAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mAttributes setObject:[UIColorTools colorWithHexString:k_STOCK_LINK_COLOR withAlpha:1.0f] forKey:NSForegroundColorAttributeName];
    NSError *error = nil;
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
            [attString replaceCharactersInRange:rangeL withString:@" "];
            [attString replaceCharactersInRange:rangeR withString:@" "];
            
           [mAttributes setObject:[attString.string substringWithRange:NSMakeRange(match.range.location + 1, match.range.length - 2)] forKey:NSLinkAttributeName];

            [attString setAttributes:mAttributes range:match.range];
        }
    }
    
    return attString;
}

+ (CGRect)boundingRectWithSize:(CGSize)size string:(NSString *)text attributes:(NSDictionary *)attributes
{
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSAttributedString *attString = [UURichTextView emojjAttributedString:text attributes:attributes];
    
    return [attString boundingRectWithSize:size options:option context:nil];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSString *text = [self.text substringWithRange:characterRange];
    NSRange rangeL = [text rangeOfString:@"("];
    NSRange rangeR = [text rangeOfString:@")"];
    
    text = [text substringWithRange:NSMakeRange(rangeL.location + 1, rangeR.location - rangeL.location - 1)];
    
    if (_selectStock) {
        _selectStock(text);
    }
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return NO;
}

@end
