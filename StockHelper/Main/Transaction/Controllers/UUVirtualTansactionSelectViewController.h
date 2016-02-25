//
//  UUVirtualTansactionSelectViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUToolBar.h"
@interface UUVirtualTansactionSelectViewController : BaseViewController<UUToolBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}

@property (nonatomic,strong) UITableView *tableView;

@end
