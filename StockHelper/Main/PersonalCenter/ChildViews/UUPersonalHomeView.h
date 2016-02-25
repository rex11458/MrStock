//
//  UUPersonalHomeView.h
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"

@interface UUPersonalHomeView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic) id<UITableViewDelegate> delegate;

@property (nonatomic,weak) id<UITableViewDataSource> dataSource;

- (void)reload;

@end

