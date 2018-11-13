//
//  UUSuggestionViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUSuggestionViewController.h"
#import "UUSuggestionView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface UUSuggestionViewController ()
{
    UUSuggestionView *_suggestionView;
}
@end

@implementation UUSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"意见反馈";
    _suggestionView = [[UUSuggestionView alloc] initWithFrame:self.view.bounds];
    
    self.baseView = _suggestionView;
}

#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    [_suggestionView endEditing:YES];
    if (actionTag == UUCommitButtionActionTag) {
        [SVProgressHUD showWithStatus:@"正在执行..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"提交成功,感谢反馈"];

            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end
