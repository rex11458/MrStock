//
//  UUVirtualTansactionRemoveViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUToolBar.h"
@interface UUVirtualTansactionRemoveViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UUToolBarDelegate>
{
    UITableView *_tableView;

    NSArray *_dataArray;
}
@end
