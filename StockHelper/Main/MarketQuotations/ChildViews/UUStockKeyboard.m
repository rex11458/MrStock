//
//  UUStockKeyboard.m
//  StockHelper
//
//  Created by LiuRex on 15/5/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockKeyboard.h"

#define KEYBOARD_HOR_BUTTON_COUNT 4
#define KEYBOARD_VER_BUTTON_COUNT 5

static UUStockKeyboard *g_keyboard;

@interface UUStockKeyboard ()
{
    UUStockNumberKeyboard *_numberKeyboard;
    UIView *_letterView;
}
@end

@implementation UUStockKeyboard


+ (UUStockKeyboard *)keyboardWithType:(UUStockKeyboardType)keyboardType
{
    CGFloat height = 0;

    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        // 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
        height = keyWindow.safeAreaInsets.bottom;
    }
    UUStockKeyboard *keyboard = [[UUStockKeyboard alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH,KEYBOARD_HEIGHT + height) keyboardType:keyboardType];
    
    return keyboard;
}

- (instancetype)initWithFrame:(CGRect)frame keyboardType:(UUStockKeyboardType)keyboardType
{
    if (self = [super initWithFrame:frame]) {
        self.keyboardType = keyboardType;
    }
    return self;
}

- (void)setKeyboardType:(UUStockKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    int index = 0;
    if (keyboardType == UUStockAlphabetKeyboardType) {
        index = 1;
    }
    
    UUStockCommonKeyboard *keyboard =  [[[NSBundle mainBundle] loadNibNamed:@"UUStockKeyboard" owner:self options:nil] objectAtIndex:index];
    keyboard.delegate = self;
    keyboard.frame = self.bounds;
    keyboard.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:keyboard];
}

- (void)changeKeyboard
{
    self.keyboardType = (_keyboardType == UUStockNumberKeyboardType ?UUStockAlphabetKeyboardType: UUStockNumberKeyboardType);
}


#pragma mark - UUStockCommonKeyboardDelegate
//切换键盘
- (void)changeKeybaord:(UUStockCommonKeyboard *)keyboard
{
    [self changeKeyboard];
}

//删除
- (void)deleteKeyboard:(UUStockCommonKeyboard *)keyobard
{
    if ([_delegate respondsToSelector:@selector(keyboard:didSelectedIndex:withValue:)]) {
        [_delegate keyboard:self didSelectedIndex:0 withValue:@"删除"];
    }

}

//收起键盘
- (void)resignKeyboard:(UUStockCommonKeyboard *)keyboard
{
    if ([_delegate respondsToSelector:@selector(keyboard:didSelectedIndex:withValue:)]) {
        [_delegate keyboard:self didSelectedIndex:0 withValue:@"收起"];
    }
}

- (void)commonKeybaord:(UUStockCommonKeyboard *)keyboard selectedString:(NSString *)string
{
    if ([_delegate respondsToSelector:@selector(keyboard:didSelectedIndex:withValue:)]) {
        [_delegate keyboard:self didSelectedIndex:0 withValue:string];
    }
}


@end
@implementation UUStockCommonKeyboard

- (void)awakeFromNib
{
    for (UIButton *button in self.subviews) {
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5f;
        [button setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.layer.borderColor = [UIColorTools colorWithHexString:@"#A7A7A7" withAlpha:1.0f].CGColor;
    }
}

- (IBAction)changeKeyboardAction:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(changeKeybaord:)]) {
        [_delegate changeKeybaord:self];
    }
}


- (IBAction)deleteAciton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(deleteKeyboard:)]) {
        [_delegate deleteKeyboard:self];
    }
}

//键盘消失
- (IBAction)resignKeyboardAciton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(resignKeyboard:)]) {
        [_delegate resignKeyboard:self];
    }
}

//点击数字或字母
- (IBAction)selectNumberOrLetterAciotn:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(commonKeybaord:selectedString:)]) {
        [_delegate commonKeybaord:self selectedString:sender.titleLabel.text];
    }
}

- (IBAction)SSMarketAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(commonKeybaord:selectedString:)]) {
        [_delegate commonKeybaord:self selectedString:@"上证"];
    }
}

- (IBAction)SZMarketAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(commonKeybaord:selectedString:)]) {
        [_delegate commonKeybaord:self selectedString:@"深证"];
    }
}

- (IBAction)searchAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(commonKeybaord:selectedString:)]) {
        [_delegate commonKeybaord:self selectedString:@"搜索"];
    }
}
@end

@implementation UUStockNumberKeyboard


@end

@implementation UUStockAlphabetKeyboard


@end


