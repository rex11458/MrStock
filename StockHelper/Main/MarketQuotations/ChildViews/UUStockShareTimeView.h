//
//  UUStockShareTimeView.h
//  StockHelper
//
//  Created by LiuRex on 15/8/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUStockQuoteEntity;

@protocol UUStockShareTimeViewDelegate ;

@interface UUStockShareTimeView : UIView
@property (strong, nonatomic) IBOutlet UIView *volBoxView;
@property (strong, nonatomic) IBOutlet UIView *lineBoxView;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) UUStockQuoteEntity *stockQuoteEntity;

@property (nonatomic, copy,readonly) NSArray *stockTimeEntityArray;

@property (strong, nonatomic) IBOutlet UILabel *highestPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowestPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *preCloseLabel;
@property (strong, nonatomic) IBOutlet UILabel *volLabel;
@property (strong, nonatomic) IBOutlet UILabel *highestRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowestRateLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineBGViewConstraint;


@property (nonatomic,weak) id<UUStockShareTimeViewDelegate> delegate;

@property (nonatomic,assign) NSInteger type; //0 竖屏 1 横屏

@end

@protocol UUStockShareTimeViewDelegate <NSObject>

@optional
- (void)shareTimeView:(UUStockShareTimeView *)shareTimeView longPress:(NSInteger)index;
- (void)cancelLongPress:(UUStockShareTimeView *)shareTimeView;

@end
