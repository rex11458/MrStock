//
//  UULoginViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/1.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"

@interface UULoginViewController : BaseViewController
{
    BOOL _successed;
    
    void(^_success)(void);
    void(^_failed)(void);
}
@property (nonatomic,assign) NSInteger index;  //点击登陆当前VC在nvc中的位置


- (id)initWithIndex:(NSInteger)index success:(void(^)(void))success failed:(void(^)(void))failed;

- (void)loginWithMobile:(NSString *)mobile password:(NSString *)password;
@end
