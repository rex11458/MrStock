//
//  UUStockKeyboard.h
//  StockHelper
//
//  Created by LiuRex on 15/5/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    UUStockNumberKeyboardType,
    UUStockAlphabetKeyboardType
    
} UUStockKeyboardType ;

@protocol UUStockKeyboardDelegate;
@class UUStockCommonKeyboard;


@protocol UUStockCommonKeyboardDelegate <NSObject>

@optional
- (void)changeKeybaord:(UUStockCommonKeyboard *)keyboard;
- (void)resignKeyboard:(UUStockCommonKeyboard *)keyboard;
- (void)deleteKeyboard:(UUStockCommonKeyboard *)keyobard;

- (void)commonKeybaord:(UUStockCommonKeyboard *)keyboard selectedString:(NSString *)string;

@end


@interface UUStockKeyboard : UIView<UUStockCommonKeyboardDelegate>

@property (nonatomic,weak) id<UUStockKeyboardDelegate> delegate;

@property (nonatomic) UUStockKeyboardType keyboardType;  //  只有这两种

+ (UUStockKeyboard *)keyboardWithType:(UUStockKeyboardType)keyboardType;

- (void)changeKeyboard;

@end

@protocol UUStockKeyboardDelegate <NSObject>

@optional
- (void)keyboard:(UUStockKeyboard *)keyboard didSelectedIndex:(NSInteger)index withValue:(id)value;

@end


@interface UUStockCommonKeyboard : UIView


@property (nonatomic,assign) id<UUStockCommonKeyboardDelegate> delegate;

//切换键盘
- (IBAction)changeKeyboardAction:(UIButton *)sender;
//回删
- (IBAction)deleteAciton:(UIButton *)sender;
//键盘消失
- (IBAction)resignKeyboardAciton:(UIButton *)sender;

//点击数字或字母
- (IBAction)selectNumberOrLetterAciotn:(UIButton *)sender;
//上证
- (IBAction)SSMarketAction:(UIButton *)sender;
//深证
- (IBAction)SZMarketAction:(UIButton *)sender;
//搜索
- (IBAction)searchAction:(id)sender;

@end

@interface UUStockNumberKeyboard : UUStockCommonKeyboard

@end

@interface UUStockAlphabetKeyboard : UUStockCommonKeyboard

@end

