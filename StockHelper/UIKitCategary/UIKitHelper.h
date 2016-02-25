//
//  UIKitHelper.h
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//


@interface UIKitHelper : NSObject

/**
 *  根据颜色生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


/**
 *  创建通用Button
 */
+ (UIButton *)buttonWithFrame:(CGRect )frame title:(NSString *)title titleHexColor:(NSString *)hexColor font:(UIFont *)font;


/**
 *创建通用UILabel
 */
+(UILabel *)labelWithFrame:(CGRect)frame Font:(UIFont *)font textColor:(UIColor *)color;

/**
 *  UITextfield
 */

//-- createTextField
+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder Text:(NSString *)text leftViewText:(NSString *)leftViewText;
@end
