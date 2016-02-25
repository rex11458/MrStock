//
//  UUExponentView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUIndexDetailModel.h"
#define TRIANGLE_LENGTH 0.0f
#define SQUARE_LENGTH  (PHONE_WIDTH / 3.0f)
#define SQUARE_HEIGHT SQUARE_LENGTH*0.8
@interface UUExponentView : UIControl
{
    SEL _action;
    id _target;
}
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (nonatomic,strong) UIColor *fillColor;

@property (nonatomic,strong) UUIndexDetailModel *indexDetailModel;

@end
