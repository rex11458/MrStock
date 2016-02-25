//
//  UUSuggestionViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUSuggestionViewController.h"
#import "UUSuggestionView.h"
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
        
    }
}

@end
