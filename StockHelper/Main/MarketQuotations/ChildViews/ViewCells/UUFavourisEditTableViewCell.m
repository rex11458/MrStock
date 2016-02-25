//
//  UUFavourisEditTableViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisEditTableViewCell.h"
#import "UUFavourisStockModel.h"
@interface UUFavourisEditTableViewCell ()
{
//    UIButton *_checkButton;     //复选框
    
    UILabel *_stockNameLabel;   //股票名称
    
    UIButton *_remindButton;    //提醒
    UIButton *_topButton;       //置顶
    UIButton *_moveButton;      //移动
}
@end

@implementation UUFavourisEditTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkButton setImage:[UIImage imageNamed:@"fav_checkBox"] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:@"fav_checkBox_selected"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _checkButton.tag = 0;
    [self.contentView addSubview:_checkButton];
    
    _stockNameLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_stockNameLabel];
    
//    _remindButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _remindButton.tag = 1;
//    [_remindButton setImage:[UIImage imageNamed:@"fav_remind"] forState:UIControlStateNormal];
//    [_remindButton setImage:[UIImage imageNamed:@"fav_remind_selected"] forState:UIControlStateSelected];
//    [_remindButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.contentView addSubview:_remindButton];
//
    _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _topButton.tag = 2;
    [_topButton setImage:[UIImage imageNamed:@"fav_top"] forState:UIControlStateNormal];
    [_topButton setImage:[UIImage imageNamed:@"fav_top_selected"] forState:UIControlStateSelected];
    [_topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_topButton];
//
    _moveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moveButton.tag = 3;
    [_moveButton setImage:[UIImage imageNamed:@"fav_move"] forState:UIControlStateNormal];
    [self.contentView addSubview:_moveButton];
}

- (void)setStockModel:(UUFavourisStockModel *)stockModel
{
    if (stockModel == nil) {
        return;
    }
    _stockModel = stockModel;
    [self fillData];
}

- (void)fillData
{
    NSString *stockCode = _stockModel.code.length <= 6 ? _stockModel.code : [_stockModel.code substringToIndex:6];
    
    _stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",_stockModel.name,stockCode];
    

}

- (void)hiddenRemindButton:(BOOL)hidden
{
    _remindButton.hidden = hidden;
}


- (void)remindButtonSeleted:(BOOL)selected
{
    _remindButton.selected = selected;
}
#pragma mark -Cell事件
- (void)buttonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:didSeletedIndex:)]) {
        [_delegate tableViewCell:self didSeletedIndex:button.tag];
    }
}

- (void)layoutSubviews
{
    _checkButton.frame = CGRectMake(0, 0, UUFavourisEditTableViewCellHeight, UUFavourisEditTableViewCellHeight);
    _stockNameLabel.frame = CGRectMake(CGRectGetMaxX(_checkButton.frame), 0, 120.0f, UUFavourisEditTableViewCellHeight);
    _moveButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - UUFavourisEditTableViewCellHeight + k_LEFT_MARGIN, 0, UUFavourisEditTableViewCellHeight, UUFavourisEditTableViewCellHeight);
    _topButton.frame = CGRectMake(CGRectGetMinX(_moveButton.frame) - UUFavourisEditTableViewCellHeight*1.5, 0, UUFavourisEditTableViewCellHeight, UUFavourisEditTableViewCellHeight);
    _remindButton.frame = CGRectMake(CGRectGetMinX(_topButton.frame) - UUFavourisEditTableViewCellHeight, 0, UUFavourisEditTableViewCellHeight, UUFavourisEditTableViewCellHeight);
}

@end
