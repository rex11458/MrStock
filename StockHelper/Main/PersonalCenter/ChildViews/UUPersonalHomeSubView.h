//
//  UUPersonalHomeSubView.h
//  StockHelper
//
//  Created by LiuRex on 15/9/9.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUPersonalHomeSubView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *fansLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *idealLabel;

@property (nonatomic,strong) User *user;


@end
