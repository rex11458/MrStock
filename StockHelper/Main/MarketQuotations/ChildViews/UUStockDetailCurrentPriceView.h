//
//  UUStockDetailCurrentPriceView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/19.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

//盘口信息

#import <UIKit/UIKit.h>
@class UUStockDetailModel;
@class UUStockCurrentPriceModel;
@interface UUStockDetailCurrentPriceView : UIView

@property (nonatomic,strong) UUStockDetailModel *detailModel;

@property (nonatomic,copy) NSArray *priceModelArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *sellPriceViewArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *sellAmountViewArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *buyPriceViewArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *buyAmountViewArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *currentTimeViewArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *currentPriceViewArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *currentAmountArray;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *arrowImageViewArray;

@property (strong, nonatomic) IBOutlet UILabel *delegateRate;//委比

@property (strong, nonatomic) IBOutlet UILabel *delegateValue; //委差




@end
