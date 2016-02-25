//
//  UUStockCommomHeaderView.h
//  StockHelper
//
//  Created by LiuRex on 15/11/11.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "UUOptionView.h"
@class UUStockModel;
@class UUMarketQuotationView;
@class UUStockFinancialModel;
typedef void(^SelectedIndex)(NSInteger);

@interface UUStockCommomHeaderView : UIView<BaseViewDelegate>

@property (nonatomic,copy) SelectedIndex selectedIndex;

@property (nonatomic,strong) UUMarketQuotationView *marketQuotationView;

@property (nonatomic,strong) UUStockModel *stockModel;

//财务信息-个股
@property (nonatomic, strong) UUStockFinancialModel *finacialModel;


- (instancetype)initWithFrame:(CGRect)frame operation:(void(^)(NSInteger))index;

- (void)showLineViewWithIndex:(NSInteger)index;

@end
