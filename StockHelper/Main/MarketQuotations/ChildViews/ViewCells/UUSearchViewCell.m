//
//  UUSearchViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUSearchViewCell.h"
#import "UUFavourisStockModel.h"
#import "UUDatabaseManager.h"
@interface UUSearchViewCell ()
{
//    UIButton *_favButton;
}
@end

@implementation UUSearchViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _favButton = [UIKitHelper buttonWithFrame:CGRectMake(PHONE_WIDTH - 60, 0, 50, CGRectGetHeight(self.bounds)) title:@"" titleHexColor:@"#5700FF" font:[UIFont systemFontOfSize:12.0f]];
        [_favButton setImage:[UIImage imageNamed:@"Toolbar_zixuan"] forState:UIControlStateNormal];
        [_favButton setImage:[UIImage imageNamed:@"Toolbar_zixuan_selected"] forState:UIControlStateSelected];

        [_favButton addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_favButton];
    }
    return self;
}

- (void)setHiddenAddFavButton:(BOOL)hiddenAddFavButton
{
    _hiddenAddFavButton = hiddenAddFavButton;
    
    _favButton.hidden = hiddenAddFavButton;
}


- (void)setStockModel:(UUFavourisStockModel *)stockModel
{
    if (stockModel == nil || stockModel == _stockModel) {
        return;
    }
    _stockModel = stockModel;
    
    
    NSString *stockCode = _stockModel.code.length <= 6 ? _stockModel.code : [_stockModel.code substringToIndex:6];
    
    self.textLabel.text = [NSString stringWithFormat:@"%@(%@)",_stockModel.name,stockCode];
    
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    self.textLabel.textColor = k_BIG_TEXT_COLOR;
    _favButton.selected = [[UUDatabaseManager manager] isFavouris:_stockModel.code];
    
}


- (void)buttonAciton:(UIButton *)button
{
//    _favButton.selected = !_favButton.isSelected;
    if ([_delegate respondsToSelector:@selector(searchViewCell:favoriousOption:)]) {
        [_delegate searchViewCell:self favoriousOption:self.stockModel];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f].CGColor);
    CGContextMoveToPoint(context,k_LEFT_MARGIN, CGRectGetHeight(rect) - 0.5f);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - 2 * k_LEFT_MARGIN,CGRectGetHeight(self.bounds) - 0.5f);
    CGContextStrokePath(context);
}

@end
