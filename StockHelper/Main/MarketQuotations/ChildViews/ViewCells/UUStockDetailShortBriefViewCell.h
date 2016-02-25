//
//  UUStockDetailShortBriefViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/11/25.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseViewCell.h"

@interface UUStockDetailShortBriefViewCell : BaseViewCell
@property (strong, nonatomic) IBOutlet UIView *subContentView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;


@end
