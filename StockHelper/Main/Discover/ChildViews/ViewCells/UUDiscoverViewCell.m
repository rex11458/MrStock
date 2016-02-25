//
//  UUDiscoverViewCellTableViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUDiscoverViewCell.h"
#import "UUTradeChanceModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define USER_INFO_HEIGHT 58.0f
#define TRADE_INFO_HEIGHT 102.0f

@interface UUDiscoverViewCell ()
@property (strong, nonatomic) IBOutlet UIButton *stockInfoButton;
@property (strong, nonatomic) IBOutlet UIButton *userInfoButton;
- (IBAction)userInfoAction:(id)sender;
- (IBAction)stockInfoAction:(id)sender;

@end

@implementation UUDiscoverViewCell


- (void)awakeFromNib
{
    _headerImageView.layer.cornerRadius = 39 * 0.5f;
    _headerImageView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _buyingButton.layer.borderColor = k_NAVIGATION_BAR_COLOR.CGColor;
    _buyingButton.layer.cornerRadius = 5.0f;
    _buyingButton.layer.borderWidth = 0.5;
    _buyingButton.layer.masksToBounds = YES;
    [_buyingButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
       [_buyingButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateHighlighted];
    [_buyingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [_stockInfoButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_userInfoButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
}

- (void)stockNameButtonAction
{
    if ([_target respondsToSelector:_stockDetailAction]) {
        [_target performSelector:_stockDetailAction withObject:self afterDelay:0.0f];
    }
}

- (void)setTradeChanceModel:(UUTradeChanceModel *)tradeChanceModel
{
    if (tradeChanceModel == nil || _tradeChanceModel == tradeChanceModel) {
        return;
    }
    _tradeChanceModel = tradeChanceModel;
    [self fillData];
    [self setNeedsDisplay];
}

- (void)fillData
{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_tradeChanceModel.userPic] placeholderImage:[UIImage imageNamed:@"default_headerImage"]];
    
    _userNameLabel.text = _tradeChanceModel.userName;
    
    _fansLabel.text = [NSString stringWithFormat:@"粉丝数：%ld",_tradeChanceModel.fans];
    
    _victoryRate.text = [NSString stringWithFormat:@"%.0f%%",_tradeChanceModel.winrate * 100];
    
    //周收益
    CGFloat profit = _tradeChanceModel.weekProfit;
    NSString *profitString = [NSString stringWithFormat:@"%.0f%%",_tradeChanceModel.weekProfit * 100];
    UIColor *color = k_EQUAL_COLOR;
    if (profit < 0) {
        color = k_UNDER_COLOR;
    }else if (profit > 0){
        color = k_UPPER_COLOR;
        profitString = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%.0f%%",fabs(_tradeChanceModel.monthProfit * 100)]];
    }
    _monthProftLabel.textColor = color;
    _monthProftLabel.text =  profitString;
    
    _stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",_tradeChanceModel.name,_tradeChanceModel.code];
    //买入时间
    if (_tradeChanceModel.resultDate.length > 6) {
        NSString *dateString = [[_tradeChanceModel.resultDate substringFromIndex:5] stringByAppendingFormat:@" %@",_tradeChanceModel.resultTime];
        _buyDateLabel.text = dateString;
        
    }
    
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"买入价格：%.2f",_tradeChanceModel.resultPrice]];
    NSMutableAttributedString *holdRateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"仓位：%.2f%%",_tradeChanceModel.position * 100]];

    NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0f],
                                     NSForegroundColorAttributeName : [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]
                                 };
    [priceString setAttributes:attributes range:NSMakeRange(0, 5)];
    [holdRateString setAttributes:attributes range:NSMakeRange(0, 3)];
    
    attributes = @{
                   NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0f],
                   NSForegroundColorAttributeName : k_BIG_TEXT_COLOR
                   };
    /*
     *--
     */
    [priceString setAttributes:attributes range:NSMakeRange(5,priceString.length - 5)];
    [holdRateString setAttributes:attributes range:NSMakeRange(3,holdRateString.length - 3)];

    
    _buyPriceLabel.attributedText = priceString;
    _holdRateLabel.attributedText = holdRateString;
}


- (IBAction)buyingButtonAction:(UIButton *)sender {
    
    if ([_target respondsToSelector:_buyingAction]) {
        [_target performSelector:_buyingAction withObject:self afterDelay:0.0];
    }

}

- (IBAction)userInfoAction:(id)sender {
    
    if ([_target respondsToSelector:_userDetailAction]) {
        [_target performSelector:_userDetailAction withObject:self afterDelay:0.0];
    }
}

- (IBAction)stockInfoAction:(id)sender {
    
    if ([_target respondsToSelector:_stockDetailAction]) {
        [_target performSelector:_stockDetailAction withObject:self afterDelay:0.0];
    }
}
@end
