//
//  UUStockDetailView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UUStockDetailView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic) id<UITableViewDelegate> delegate;

@property (nonatomic,weak) id<UITableViewDataSource> dataSource;


- (void)reload;

- (void)refresh;

@end


