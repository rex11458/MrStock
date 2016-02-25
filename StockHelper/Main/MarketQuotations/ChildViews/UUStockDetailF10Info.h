//
//  UUStockDetailF10InfoView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDataSource.h"
@protocol UUStockDetailViewDelegate ;

@interface UUStockDetailF10SectionSubView : UIView

@property (nonatomic,strong) UILabel *titleLabel;

@end

@interface UUStockDetailF10SectionView : UIView

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UUStockDetailF10SectionSubView *subView;

@end



@interface UUStockDetailF10CompanyShareHolderSectionView : UIView

@property (nonatomic,strong) CAShapeLayer *outerCircleLayer;
@property (nonatomic,strong) CAShapeLayer *innerCircleLayer;
@property (nonatomic,strong) UUStockDetailF10SectionView *sectionView;
@property (nonatomic,strong) UUStockDetailF10SectionSubView *subView;

@end



@interface UUStockDetailF10DataSource : BaseDataSource<UITableViewDataSource>

@end

@interface UUStockDetailF10Info : NSObject<UITableViewDelegate>



@end



@protocol UUStockDetailViewDelegate <NSObject>

@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

