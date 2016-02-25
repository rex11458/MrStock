//
//  UUFansListViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/8/6.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUFansListViewCellHeight 70.0f
@class UUFocusModel;
@interface UUFansListViewCell : UITableViewCell
{
    UIImageView *_headerImageView;

    UILabel *_textLabel;
}

@property (nonatomic,strong) UUFocusModel *focusModel;

@end
