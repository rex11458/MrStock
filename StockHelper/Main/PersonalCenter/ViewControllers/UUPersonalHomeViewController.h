//
//  UUPersonalHomeViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUVirtualTransactionView.h"
@class UUPersonalHomeSubView;
@interface UUPersonalHomeViewController : BaseViewController

@property (nonatomic,copy) NSString *userId;

@end


#define UUPersonalHomeHeaderViewHeight (290 + UUVirtualTransactionChatViewHeight)

@protocol UUPersonalHomeHeaderViewDelegate;

@interface UUPersonalHomeHeaderView : UIView
{
    id _target;
    SEL _action;
    
    
    NSMutableArray *_labelArray;
    UUPersonalHomeSubView *_subView;
}

@property (nonatomic,strong) UUVirtualTransactionChatView *chatView;


@property (nonatomic,weak) id<UUPersonalHomeHeaderViewDelegate> delegate;

@property (nonatomic,strong) UUTransactionAssetModel *assetModel;

@property (nonatomic,strong) User *user;

@end

@protocol UUPersonalHomeHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(UUPersonalHomeHeaderView *)headerView didSelectedIndex:(NSInteger)index;

@end



@protocol UUPersonalHomeSectionViewDelegate;
@interface UUPersonalHomeSectionView : UIView
{
    UIButton *_selectedButton;
}
@property (nonatomic, copy) NSArray *titles;

@property (nonatomic,weak) id<UUPersonalHomeSectionViewDelegate> delegate;


@property (nonatomic,assign) NSInteger index;

@end

@protocol UUPersonalHomeSectionViewDelegate <NSObject>

@optional
- (void)sectionView:(UUPersonalHomeSectionView *)sectionView didSelectedIndex:(NSInteger)index;

@end