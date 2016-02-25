//
//  UUTabbarController.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTabbarController.h"
#import "BaseNavigationController.h"
#import "UUTabbar.h"
@interface UUTabbarController ()<UUTabbarDelegate>

@property (nonatomic,strong) UUTabbar *customTabbar;

@end

@implementation UUTabbarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        
        [self initViewControllers];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    //创建自定义tabbar
    [self createCustomTabbar];
}

//
- (void)createCustomTabbar
{
    NSArray *orgItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UUTabbarItems.plist" ofType:nil]];

    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0 ; i < orgItems.count ;i++) {
        NSDictionary *dic = [orgItems objectAtIndex:i];
        NSString *title = [dic objectForKey:@"title"];
        UIImage *image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        UIImage *selectedImage = [UIImage imageNamed:[dic objectForKey:@"selectedImage"]];
        UUTabbarItem *item = [[UUTabbarItem alloc] initWithTitle:title image:image selectedImage:selectedImage tag:i];
        [items addObject:item];
    }

    _customTabbar = [[UUTabbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - k_TABBER_HEIGHT, PHONE_WIDTH, k_TABBER_HEIGHT) items:items];
    _customTabbar.delegate = self;
    _customTabbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_customTabbar];
}

- (void)initViewControllers
{
    NSArray *viewControllerClassArray = @[@"UUDiscoverViewController",@"UUTransactionViewController",@"UUPersonalCenterViewController"];
    NSMutableArray *viewControllers = [NSMutableArray array];

    for (NSInteger i = 0; i < viewControllerClassArray.count; i++) {
        UIViewController *vc = [[NSClassFromString([viewControllerClassArray objectAtIndex:i]) alloc] init];

        [viewControllers addObject:vc];
    }
    self.viewControllers = viewControllers;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _customTabbar.selectedIndex = selectedIndex;
    [super setSelectedIndex:selectedIndex];
}



#pragma mark - UUTabbarDelegate
- (void)tabbar:(UUTabbar *)tabbar didSelectedItem:(UUTabbarItem *)tabbarItem
{
    self.selectedIndex = tabbarItem.tag;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
