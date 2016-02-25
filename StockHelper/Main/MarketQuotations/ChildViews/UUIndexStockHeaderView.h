//
//  UUIndexStockHeaderView.h
//  StockHelper
//
//  Created by LiuRex on 15/11/11.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockCommomHeaderView.h"
#import "UUIndexDetailModel.h"
@interface UUIndexStockHeaderView : UUStockCommomHeaderView
{
    @private
    UUIndexDetailModel *_indexModel;
}
@property (nonatomic, strong) NSMutableArray *textLabelArray;

@end
