//
//  UUPersonalSettingViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUPersonalSettingViewCellHeight 70.0f
@interface UUPersonalSettingViewCell : BaseViewCell
{
    UILabel *_textLabel;
}

@property (nonatomic,strong) UIImageView *arrowImageView;

@property(nonatomic,copy) NSString *text;

@end
