//
//  UUTradeAnalyViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.


//交易分析

#import "BaseViewController.h"
#import "UUVirtualTransactionView.h"
@class UUTransactionAssetModel ;
@interface UUTradeAnalyViewController : BaseViewController


@property (nonatomic,strong) UUTransactionAssetModel *assetModel;

@property (nonatomic,copy) NSArray *profitArray;


@property (nonatomic, copy) NSString *userId;


@end

#define UUTradeAnalyHeaderViewHeight (220.0f + UUVirtualTransactionChatViewHeight)
@interface UUTradeAnalyHeaderView : UIView
{
    NSMutableArray *_labelViewArray;
    UILabel *_startTradeLabel;  //初次交易时间
    UILabel *_lastesTradeLabel; //最后交易时间
    
    
}

@property (nonatomic,strong) UUVirtualTransactionChatView *chatView;


@property (nonatomic,strong) UUTransactionAssetModel *assetModel;


@end
