//
//  UUGeniusRankViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"

#import "UUGeniusRankViewCell.h"

@interface UUGeniusRankViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}


@property (nonatomic, assign) UUGeniusType type;


- (id)initWithTitle:(NSString *)title type:(UUGeniusType)type;

@end
