//
//  UUFavourisEditTableViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UUFavourisEditTableViewCellHeight 46.0f
@class UUFavourisStockModel;
@protocol UUFavourisEditTableViewCellDelegate;
@interface UUFavourisEditTableViewCell : BaseViewCell

@property (nonatomic,weak) id<UUFavourisEditTableViewCellDelegate> delegate;

@property (nonatomic,strong) UUFavourisStockModel *stockModel;

@property (nonatomic,strong,readonly) UIButton *checkButton;


- (void)hiddenRemindButton:(BOOL)hidden;



- (void)remindButtonSeleted:(BOOL)selected;

@end

@protocol UUFavourisEditTableViewCellDelegate <NSObject>

@optional
- (void)tableViewCell:(UUFavourisEditTableViewCell *)cell didSeletedIndex:(NSInteger)index;

@end