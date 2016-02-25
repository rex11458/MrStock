//
//  UUStockSearchView.h
//  StockHelper
//
//  Created by LiuRex on 15/5/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UUStockSearchBarDelegate ;
@interface UUStockSearchBar : UIView

@property (nonatomic,weak) id<UUStockSearchBarDelegate> delegate;

@end

@protocol UUStockSearchBarDelegate <NSObject>

@optional
- (void)searchBar:(UUStockSearchBar *)searchBar textDidChange:(NSString *)searchText;

- (void)SSMarketAction:(UUStockSearchBar *)searchBar;

- (void)SZMarketAction:(UUStockSearchBar *)searchBar;

@end