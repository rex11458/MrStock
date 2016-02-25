//
//  BaseNavigationController.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseNavigationController.h"
#import "NavigationInteractiveTransition.h"
#import "UUTabbarController.h"
@interface BaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NavigationInteractiveTransition *navT;


@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationBar.translucent = NO;
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
    {
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    }
    
    self.delegate = self;
//    
//    if(SCREEN_IOS_VS >= 7.0)
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        
//        UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
//        gesture.enabled = YES;
//        UIView *gestureView = gesture.view;
//        
//        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
//        popRecognizer.delegate = self;
//        popRecognizer.maximumNumberOfTouches = 1;
//        [gestureView addGestureRecognizer:popRecognizer];
//        
//        _navT = [[NavigationInteractiveTransition alloc] initWithViewController:self];
//        [popRecognizer addTarget:_navT action:@selector(handleControllerPop:)];
//    }
}



//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    /**
//     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
//     */
//    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
//}


#pragma mark - shouldAutorotate
- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:NSClassFromString(@"UUStockDetailViewController")])
    { // 如果是这个 vc 则支持自动旋转
        return YES;
    }
    return NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(SCREEN_IOS_VS >= 7.0)
    {
        if (self.viewControllers.count > 1)
        {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
        else
        {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != nil)
    {
        NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
        [viewControllers addObject:viewController];
        [self setViewControllers:viewControllers animated:animated];
    }
}

@end
