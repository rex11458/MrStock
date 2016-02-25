//
//  UUFavourisStockEditViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"

@interface UUFavourisStockEditViewController : BaseViewController
{
    void(^_deleteSuccess)(NSArray *);
    void(^_updatePositionSuccess)(NSArray *);

}
@property (nonatomic, copy) NSArray *stockModelArray;

- (void)deleteSuccess:(void(^)(NSArray *))success;

- (void)updatePositionSuccess:(void(^)(NSArray *))success;

@end
