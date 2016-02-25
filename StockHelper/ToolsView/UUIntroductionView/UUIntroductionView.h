//
//  UUIntroductionView.h
//  StockHelper
//
//  Created by LiuRex on 15/9/29.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UUIntroductionInfoKey;

@protocol UUIntroductionViewDelegate;

@interface UUIntroductionView : UIView<UIScrollViewDelegate>

@property (nonatomic,weak) id<UUIntroductionViewDelegate> delegate;

- (void)show;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *experienceButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;



- (IBAction)buttonAction:(UIButton *)sender;
- (IBAction)pageControlAction:(UIPageControl *)sender;



- (instancetype)initWithDelegate:(id<UUIntroductionViewDelegate>)delegate;

+ (BOOL)equalVersion;


@end

@protocol UUIntroductionViewDelegate <NSObject>

@optional
- (void)introductionView:(UUIntroductionView *)introductionView didSelectedIndex:(NSInteger)index;

@end