//
//  BaseView.h
//  StockHelper
//
//  Created by LiuRex on 15/5/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
@class BaseModel;
@protocol BaseViewDelegate;
@protocol BaseViewDataSource ;
@interface BaseView : UIView

@property (nonatomic,weak) id<BaseViewDataSource> dataSource;

@property (nonatomic,weak) id<BaseViewDelegate> delegate;

@end

@protocol BaseViewDelegate <NSObject>

@optional

- (void)baseView:(BaseView *)baseView actionTag:(NSInteger) actionTag value:(id)values;

@end


@protocol BaseViewDataSource <NSObject>

@property (nonatomic,strong) BaseModel *baseModel;

@end