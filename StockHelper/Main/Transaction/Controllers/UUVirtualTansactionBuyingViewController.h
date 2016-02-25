//
//  UUVirtualTansactionBuyingViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUVirtualTansactionBuyingView.h"
@class UUStockModel;
@interface UUVirtualTansactionBuyingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,BaseViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>
{
    
    id _observer;
    NSArray *_dataArray;
    
    UITableView *_tableView;
    UUVirtualTansactionBuyingView *_buyingView;
    
    UISearchBar *_searchBar;
}

@property (nonatomic,assign) NSInteger type;  //0 买入 1卖出

@property (nonatomic,strong)UUStockModel *stockModel;

@property (nonatomic,assign) NSInteger holdCount;

@end
