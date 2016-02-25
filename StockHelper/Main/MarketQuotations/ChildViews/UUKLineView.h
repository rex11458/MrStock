//
//  UUKLineView.h
//  StockHelper
//
//  Created by LiuRex on 15/5/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

//股票K线图

#import <UIKit/UIKit.h>
@class UUStockModelArray;

typedef enum : NSUInteger {
    kDayLineType ,
    kWeekLineType ,
    kMonthLineType
} kLineType;

@protocol UUKLine <NSObject>

@optional
//- (void)setLineModelArray:(UUStockModelArray *)lineModelArray;

- (void)setLineMargin:(CGFloat)lineMargin;

- (void)setLineWidth:(CGFloat)lineWidth;

- (void)setCurrentIndex:(NSInteger)currentIndex;

- (void)setKLineModelArray:(NSArray *)kLineModelArray;

@end

//复权事件回调
typedef void(^ExRights)(NSInteger);

@interface UUKLineView : UIView<UUKLine>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineBGViewTrailingConstraint;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *idxButtonArray;
- (IBAction)idxButtonAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;
- (IBAction)buttonAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *rightButtonView;

@property (nonatomic,strong,readonly) NSArray *lineViewArray;

@property (nonatomic) kLineType lineType;//日k，周K，月K

@property (nonatomic,copy) NSArray *closePricePointArray; // 所有收盘价格所在的点

@property (nonatomic) CGFloat lineWidth; //K线宽度

@property (nonatomic,assign) NSInteger type ; //0竖屏  1横屏

@property (nonatomic,copy) ExRights exrights;

@property (nonatomic,copy) NSArray *exRightsArray;

@end

//成交量
@interface UUVOLLineView : UIView<UUKLine>

@property (nonatomic,assign) NSInteger type;

@end

//MACD指标
@interface UUMACDLineView : UIView <UUKLine>
@property (nonatomic,assign) NSInteger type;

@end

//KDJ指标
@interface UUKDJLineView : UIView<UUKLine>
@property (nonatomic,assign) NSInteger type;

@end

//RSI指标
@interface UURSILineView : UIView<UUKLine>
@property (nonatomic,assign) NSInteger type;

@end



