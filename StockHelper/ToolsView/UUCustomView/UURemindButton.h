//
//  UURemindButton.h
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UURemindButton : UIButton
{
    UIImageView *_remindImageView;
}
@property (nonatomic,assign) BOOL showRemind;
@end
