//
//  UUShareView.h
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#define UUShareViewHeight (PHONE_WIDTH * 0.6)

//typedef enum : NSUInteger {
//    UUShareWeiXinType  = 0,
//    UUSharePenyouType,
//    UUShareQQType,
//    UUShareWeiboType
//} UUShareType;
//


@protocol UUShareViewDelegate ;

@interface UUShareView : UIView

@property (nonatomic,weak) id<UUShareViewDelegate> delegate;

- (void)show;

@end

@protocol UUShareViewDelegate <NSObject>

- (void)shareView:(UUShareView *)shareView shareWithType:(ShareType)shareType;

@end