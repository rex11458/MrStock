//
//  UUFillPersonalInfoViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFillPersonalInfoViewController.h"
#import "UUFillPersonalInfoView.h"
#import "UULoginHandler.h"
#import "UULoginViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
@implementation UUFillPersonalInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = self.type ?@"个人信息设置" :  @"注册";
    
    self.navigationItem.title = title;
    
    UUFillPersonalInfoView *infoView = [[UUFillPersonalInfoView alloc] initWithFrame:self.view.bounds type:self.type];
    self.baseView = infoView;
    if (self.type == 1)
    {
        infoView.user = [UUserDataManager sharedUserDataManager].user;
    }
    _infoView = infoView;
}

#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    [_infoView endEditing:YES];
    if (actionTag == UUDoneButtonActionTag) {
        
        if (self.type == 0) {
            [SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeBlack];
            
            if (_infoView.base64ImageString == nil) {
                [SVProgressHUD showErrorWithStatus:@"请选择上传头像" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
            [[UULoginHandler sharedLoginHandler] registerWithNickName:_infoView.nickName password:_password mobile:_mobile code:_code headImg:_infoView.base64ImageString success:^(NSString *message) {
                
                [SVProgressHUD showSuccessWithStatus:message];
                
                if (_registerType == 0)
                {
                    UULoginViewController *loginVC = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 3];
                    [loginVC loginWithMobile:_mobile password:_password]; //type = 1表示注册成功后登录 pop回首页
                }else
                {
                    UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:0 success:^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } failed:^{
                        [SVProgressHUD showErrorWithStatus:@"登录失败，请进入登录页面重新登录!" maskType:SVProgressHUDMaskTypeBlack];
                    }];
                    [loginVC loginWithMobile:_mobile password:_password];
                }
                
            } failure:^(NSString *errorMessage) {
                [SVProgressHUD showErrorWithStatus:errorMessage];
            }];
        }else if(self.type == 1)
        {
            //编辑
            if (_infoView.nickName.length < 6) {
                [SVProgressHUD showInfoWithStatus:@"用户名不能小于6位" maskType:SVProgressHUDMaskTypeBlack];
            }else if (_infoView.nickName.length > 12){
                [SVProgressHUD showInfoWithStatus:@"用户名不能大于12位" maskType:SVProgressHUDMaskTypeBlack];
            }
            
            [SVProgressHUD showWithStatus:@"正在执行..." maskType:SVProgressHUDMaskTypeBlack];
            [[UULoginHandler sharedLoginHandler] modifyUserInfoWithNickName:_infoView.nickName depict:_infoView.depict headImg:_infoView.base64ImageString success:^(id obj) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSString *errorMessage) {
                [SVProgressHUD showErrorWithStatus:errorMessage];
            }];
        }

    }else if (actionTag == UUHeaderButtonActionTag)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照", @"从手机相册选择",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 2){
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    
    if (buttonIndex == 0) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

        }
        else
        {
            return;
        }
        
    }
    
    else if (buttonIndex == 1){
        
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    imagePicker.allowsEditing=YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    NSURL *mediaUrl;
    mediaUrl=(NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    if(mediaUrl==nil)
    {
        image=(UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        
        if(image==nil)
        {
            image=(UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
            
        }
        
        else
        {
            [[info valueForKey:UIImagePickerControllerCropRect] CGRectValue];
            
        }
    }
    _infoView.headerImage = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //上传头像
}


@end
