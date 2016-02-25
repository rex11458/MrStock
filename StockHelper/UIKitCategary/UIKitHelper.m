//
//  UIKitHelper.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UIKitHelper.h"

@implementation UIKitHelper

/**
 *  根据颜色生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  创建通用Button
 */
+ (UIButton *)buttonWithFrame:(CGRect )frame title:(NSString *)title titleHexColor:(NSString *)hexColor font:(UIFont *)font
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    if (hexColor) {
        [btn setTitleColor:[UIColorTools colorWithHexString:hexColor withAlpha:1.0] forState:UIControlStateNormal];
    }

    
    return btn;
}

/**
 *创建UILabel
 */
+(UILabel *)labelWithFrame:(CGRect)frame Font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = color;
    label.font = font;
//    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}
/**
 *  <#Description#>
 */
//textField
+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder Text:(NSString *)text leftViewText:(NSString *)leftViewText
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.text = text;
//    textField.backgroundColor = [UIColor whiteColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    textField.layer.borderWidth = 0.5;
//    textField.layer.cornerRadius = 4;
    textField.font=[UIFont boldSystemFontOfSize:15];

    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    if (![leftViewText isNull] && leftViewText.length > 0) {
        //textField.leftView
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60,41)];
        label.backgroundColor=[UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = leftViewText;
        label.backgroundColor = [UIColor clearColor];
        label.textColor=[UIColorTools colorWithHexString:@"#767676" withAlpha:1];
        textField.leftView = label;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }

return textField;
}
@end
