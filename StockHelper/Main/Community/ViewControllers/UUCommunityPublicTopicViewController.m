//
//  UUCommunityPublicTopicViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityPublicTopicViewController.h"
#import "UUCommunityPublicTopicView.h"
#import "UUThemeManager.h"
#import "UUStockSearchViewController.h"
#import "UUFavourisStockModel.h"
#import "UIImage+Compress.h"
#import "UUCommunityHandler.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UUCommunityTopicListModel.h"
#import "GTMBase64.h"
@interface UUCommunityPublicTopicViewController ()<UUCommunityPublicTopicViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UUCommunityPublicTopicView *_publicTopicView;
}
@end

@implementation UUCommunityPublicTopicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UUThemeManager customAppAppearance];
    [_publicTopicView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发帖";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    
    
    self.view.backgroundColor = k_BG_COLOR;
    
    _publicTopicView = [[UUCommunityPublicTopicView alloc] initWithFrame:self.view.bounds];
    _publicTopicView.topicViewDelegate = self;
    _publicTopicView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_publicTopicView];
}

-(void)success:(void (^)(UUCommunityTopicNormalListModel *))success
{
    _success = [success copy];
}


- (void)sendAction
{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (UIImage *image in _publicTopicView.imageArray) {
       UIImage *upImage = [image imageScaledToSize:CGSizeMake(PHONE_WIDTH, image.size.height * PHONE_WIDTH / image.size.width)];
        NSData* imgData = UIImagePNGRepresentation(upImage);
        if (imgData == nil) {
           imgData = UIImageJPEGRepresentation(upImage, 1);
        }
        if (imgData) {
            NSString * base64String = [GTMBase64 stringByEncodingData:imgData];
            [dataArray addObject:base64String];
        }
    }
    
    NSString *jsonString = @"";

    if (dataArray.count > 0) {
       jsonString = [self jsonStringWithString:[NSString jsonStringWithArray:dataArray]];
    }
    
    [SVProgressHUD showWithStatus:@"正在发表..." maskType:SVProgressHUDMaskTypeBlack];
    [[UUCommunityHandler sharedCommunityHandler] publicTopicWithRelevanceId:_relevanceId content:_publicTopicView.textView.text images:jsonString success:^(id obj) {
        
        if (_success) {
            _success(nil);
        }
        
        [SVProgressHUD showSuccessWithStatus:@"发表成功" maskType:SVProgressHUDMaskTypeBlack];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
    }];
}


- (NSString *)jsonStringWithString:(NSString *)string
{
    NSMutableString *mString = [[NSMutableString alloc] initWithString:string];
    
    [mString replaceOccurrencesOfString:@"," withString:@"\",\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mString.length)];
    
    [mString insertString:@"\"" atIndex:1];
    [mString insertString:@"\"" atIndex:mString.length - 1];
    
    return mString;
}

#pragma mark - UUCommunityPublicTopicViewDelegate
//添加股票
- (void)publicTopicViewAddStock:(UUCommunityPublicTopicView *)publicTopicView
{
    UUStockSearchViewController *searchVC = [[UUStockSearchViewController alloc] init];
    searchVC.type = 1; //选择股票
    [searchVC setSuccess:^(UUFavourisStockModel *stockModel){
        
     NSString * text = _publicTopicView.textView.text;
        _publicTopicView.textView.text = [text stringByAppendingString:[NSString stringWithFormat:@"[%@(%@)]",stockModel.name,stockModel.code]];
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
}


//添加图片
- (void)publicTopicViewAddImage:(UUCommunityPublicTopicView *)publicTopicView
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
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
//    CGFloat imageWidth = PHONE_WIDTH;
//    CGFloat imageHeight = PHONE_WIDTH * image.size.height / image.size.width;
//    UIImage *newImage = [image imageScaledToSize:CGSizeMake(imageWidth, imageHeight)];
    [_publicTopicView addImage:image];

    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
