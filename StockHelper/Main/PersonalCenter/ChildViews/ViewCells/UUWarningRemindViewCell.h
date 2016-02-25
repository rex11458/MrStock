//
//  UUWarningRemindViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/8/7.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUWarningRemindViewCellHeight 44.0f
@interface UUWarningRemindViewCell : UITableViewCell
{
    UILabel *_nameLabel;
    id _target;
    SEL _action;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action;

@end
