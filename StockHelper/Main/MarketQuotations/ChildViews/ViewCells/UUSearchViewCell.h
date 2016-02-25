//
//  UUSearchViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUFavourisStockModel;
@protocol UUSearchViewCellDelegate;
@interface UUSearchViewCell : BaseViewCell

@property (nonatomic,strong) UUFavourisStockModel *stockModel;

@property (nonatomic,weak) id<UUSearchViewCellDelegate> delegate;

@property (nonatomic,strong,readonly) UIButton *favButton;

@property (nonatomic) BOOL hiddenAddFavButton;


@end

@protocol UUSearchViewCellDelegate <NSObject>

@optional
- (void)searchViewCell:(UUSearchViewCell *)cell favoriousOption:(UUFavourisStockModel *)stockModel;

@end