//
//  UUVirtualTansactionSelectViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUVirtualTansactionSelectViewController.h"
#define UUVirtualTansactionSelectViewCellHeight 70.0f
@interface UUVirtualTansactionSelectViewCell : BaseViewCell
{
    UILabel *_textLabel;
}
@property (nonatomic, copy) NSString *text;

@end
