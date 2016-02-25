//
//  UUTitleView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SeletedIndexBlock) (NSInteger);

@interface UUTitleView : UIView
{
    NSMutableArray *_buttonArray;
    
}

@property (nonatomic,copy) SeletedIndexBlock selectedIndex;


@property (nonatomic,copy) NSArray *titleArray;

- (id)initWithFrame:(CGRect)frame selectedIndex:(SeletedIndexBlock)selectedIndex;

@end
