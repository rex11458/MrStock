//
//  UUCommunityTopicDetailPraiseListView.m
//  UUStock
//
//  Created by LiuRex on 15/9/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityTopicDetailPraiseListView.h"
#import "UUTopicPraiseListModel.h"
@interface UUCommunityTopicDetailPraiseListView ()<UITextViewDelegate>
{
    NSMutableArray *_nameArray;
    NSString *_nameString;
}
@end

@implementation UUCommunityTopicDetailPraiseListView


- (void)setPraiseModelArray:(NSArray *)praiseModelArray
{
    _praiseModelArray = praiseModelArray;
    
    [self fillData];
}

- (void)fillData
{
    _nameArray = [NSMutableArray array];
    
    if (_praiseModelArray.count == 0) {
        _nameString = @"还没有人点赞";
    }else{
        
        for (NSInteger i = 0; i < _praiseModelArray.count; i++) {
            [_nameArray addObject:[[_praiseModelArray objectAtIndex:i] userName]];
        }
        NSString *names = [_nameArray componentsJoinedByString:@"、"];
        names = [names stringByAppendingString:@"觉得很赞"];
        _nameString = names;
    }

    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"zan"];
    attachment.bounds = CGRectMake(0, _textView.font.descender * 2, _textView.font.lineHeight, _textView.font.lineHeight);
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:_nameString]];
    [_nameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            
            NSRange range = [attString.string rangeOfString:name];
            if (range.location != NSNotFound) {
                [attString setAttributes:@{NSLinkAttributeName:name,NSFontAttributeName:k_SMALL_TEXT_FONT} range:NSMakeRange(range.location, range.length)];
            }
    }];
    _textView.attributedText = attString;
}

//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
//{
//    return NO;
//}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSString *name = [_nameString substringWithRange:NSMakeRange(characterRange.location - 1, characterRange.length)];
    
    [_praiseModelArray enumerateObjectsUsingBlock:^(UUTopicPraiseModel *model, NSUInteger idx, BOOL *stop) {
       
        if ([model.userName isEqualToString:name]) {
            if (_select) {
                _select(model);
            }
        }
    }];
    
    return NO;
}

- (void)select:(void (^)(UUTopicPraiseModel *))select
{
    _select = [select copy];
}

@end
