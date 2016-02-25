//
//  UUGroupViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUGroupViewController.h"
#import "UUStockListViewController.h"
#import "UUFavourisManagerViewController.h"
@interface UUGroupViewController ()

@end

@implementation UUGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"组合";
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"自选" style:UIBarButtonItemStylePlain target:self action:@selector(favoriousAction)],[[UIBarButtonItem alloc] initWithTitle:@"行情" style:UIBarButtonItemStylePlain target:self action:@selector(stockListAction)]];
}


- (void)favoriousAction
{
    UUFavourisManagerViewController *favourisVC = [[UUFavourisManagerViewController alloc] initWithViewControllers:@[@"UUFavourisStockViewController",@"UUFavourisGroupViewController"]];
    favourisVC.editing = YES;
    [self.navigationController pushViewController:favourisVC animated:YES];
}

- (void)stockListAction
{
    UUStockListViewController *stockListVC = [[UUStockListViewController alloc] init];
    [self.navigationController pushViewController:stockListVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
