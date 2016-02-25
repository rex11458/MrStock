//
//  UUVirtualTansactionBusinessViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

 //当日成交、当日委托

#import "BaseViewController.h"
#import "UUVirtualTansactionBusinessHeaderView.h"
#import "UUToolBar.h"
#import "UUVirtualTansactionBusinessViewCell.h"


@interface UUVirtualTansactionBusinessViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UUToolBarDelegate>
{
    NSString *_remaindKey;
    
    NSMutableArray *_dataArray;
    
    UITableView *_tableView;
    UUVirtualTansactionBusinessHeaderView *_headerView;
}

@property (nonatomic,assign) UUVirtualTansactionBusinessType businessType;

@end
