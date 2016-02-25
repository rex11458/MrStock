//
//  UUPersonalCenterViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/7/2.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUPersonalCenterViewCellHeight 70.0f
@interface UUPersonalCenterViewCell : BaseViewCell

@property (nonatomic,strong) NSDictionary *dictionary;

@property (nonatomic,assign) BOOL showRemaind;

@end
