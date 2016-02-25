//
//  UUStockDetailFinanceViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/11/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseViewCell.h"

@interface UUStockDetailFinanceViewCell : BaseViewCell
@property (strong, nonatomic) IBOutlet UIView *subContentView;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end


@interface UUStockDetailFinanceHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

@end