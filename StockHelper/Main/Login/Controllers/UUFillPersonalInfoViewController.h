//
//  UUFillPersonalInfoViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//
//填写头像和昵称
#import "BaseViewController.h"
@class UUFillPersonalInfoView;
@class UULoginUser;
@interface UUFillPersonalInfoViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UUFillPersonalInfoView *_infoView;
}

@property (nonatomic, copy) NSString *code;


@property (nonatomic,copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;

@property (nonatomic,assign) NSInteger type; //type=1 编辑个人信息 type ＝ 0 注册填写个人信息

//registerType = 1 从引导页进入注册页面   ，0 从登陆页进入注册页面
@property (nonatomic,assign) NSInteger registerType;


@end
