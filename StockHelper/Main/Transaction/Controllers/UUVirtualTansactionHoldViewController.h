//
//  UUVirtualTansactionHoldViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/31.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUVirtualTansactionHoldStockViewCell.h"

@interface UUVirtualTansactionHoldViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UUVirtualTansactionHoldStockViewCellDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    NSIndexPath *_selectedIndexPath;
}
@end
