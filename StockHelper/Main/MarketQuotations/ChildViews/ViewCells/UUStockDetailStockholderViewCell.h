//
//  UUStockDetailStockholderViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/11/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseViewCell.h"

@interface UUStockDetailStockholderViewCell : BaseViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *holderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *holdCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *holdRateLabel;

@end
