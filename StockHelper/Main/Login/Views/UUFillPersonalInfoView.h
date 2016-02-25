//
//  UUFillPersonalInfoView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#define UUDoneButtonActionTag   100
#define UUHeaderButtonActionTag 101
@interface UUFillPersonalInfoView : BaseView<UITextViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    CGSize _contentSize;
    
    UIButton *_headerImageButton;
    
    UITextField *_nickNameTextField;
    UIButton *_doneButton;
    
    UITextView *_mottoTextView;
}

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *depict;


@property (nonatomic,copy) NSString *base64ImageString;

@property (nonatomic, copy) UIImage *headerImage;

@property (nonatomic,assign) NSInteger type; //type=1 编辑状态

@property (nonatomic,strong) UULoginUser *user;

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@end
