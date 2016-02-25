//
//  UUFavourisManagerViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisManagerViewController.h"
#import "UUFavourisGroupViewController.h"
#import "UUFavourisStockViewController.h"
#import "UUStockSearchViewController.h"
#define UUFavourisManagerHeaderViewHeight 46.0f
@implementation UUFavourisManagerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = k_BG_COLOR;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    if (_titles == titles) {
        return;
    }
    _titles = [titles copy];
    [self configSubViews];
}

- (void)configSubViews
{
    UIColor *titleColor = k_NAVIGATION_BAR_COLOR;
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    

    NSArray *titles = _titles;
    CGFloat buttonWidth = PHONE_WIDTH / (float)titles.count;
    CGFloat lineImageViewHeight = 1.0f;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, UUFavourisManagerHeaderViewHeight);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = k_BIG_TEXT_FONT;
        [button setTitleColor:k_BIG_TEXT_COLOR forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
        if (i == 0) button.selected = YES;
        [self addSubview:button];
        
        
        UIView *separetLine = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth,UUFavourisManagerHeaderViewHeight * 0.25, 0.5, UUFavourisManagerHeaderViewHeight * 0.5)];
        separetLine.backgroundColor = [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f];
        [button addSubview:separetLine];
    }
    self.buttonArray = buttonArray;
    
    
    CALayer *bottomBGLine = [CALayer layer];
    bottomBGLine.frame = CGRectMake(0, UUFavourisManagerHeaderViewHeight - lineImageViewHeight,CGRectGetWidth(self.bounds), lineImageViewHeight);
    bottomBGLine.backgroundColor = [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f].CGColor;
    [self.layer addSublayer:bottomBGLine];
    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,UUFavourisManagerHeaderViewHeight - lineImageViewHeight, buttonWidth,lineImageViewHeight)];
    
    _lineImageView.image = [UIKitHelper imageWithColor:titleColor];
    
    [self addSubview:_lineImageView];
}

- (void)scrollWithButtonIndex:(NSInteger)index
{
    if (index >= self.buttonArray.count) {
        return;
    }
    UIButton *button = [self.buttonArray objectAtIndex:index];
    
    [self scrollToButtonPosition:button];
    
}


- (void)buttonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(headerView:didSeletedIndex:)]) {
        [_delegate headerView:self didSeletedIndex:button.tag];
    }
    
    [self scrollToButtonPosition:button];
}


- (void)scrollToButtonPosition:(UIButton *)button
{
    for (UIButton *subButton in self.buttonArray) {
        
        subButton.selected = (subButton == button);
        
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = _lineImageView.frame;
        frame.origin.x = button.frame.origin.x;
        _lineImageView.frame = frame;
    }];
}


@end




@interface UUFavourisManagerViewController ()<UUFavourisManagerHeaderViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    UIPageViewController *_pageViewController;
    UUFavourisManagerHeaderView *_headerView;
}

@property (nonatomic) NSInteger currentIndex;



@end

@implementation UUFavourisManagerViewController

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    if (self = [super init]) {
        self.viewControllers = viewControllers;
    }
    return self;
}


- (void)addRightBarButtons
{
    UIImage *searchImage = [UIImage imageNamed:@"Nav_search"];
    UIImage *shareImage = [UIImage imageNamed:@"Nav_edit"];
    
    UIButton *searchButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, searchImage.size.width  * 2, searchImage.size.height) title:nil titleHexColor:nil font:nil];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:searchImage forState:UIControlStateNormal];
    UIButton *editButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, shareImage.size.width, shareImage.size.height) title:nil titleHexColor:nil font:nil];
    [editButton setImage:shareImage forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:searchButton];

    self.navigationItem.rightBarButtonItems = @[item1,item2];

}

- (void)searchAction
{
    UUStockSearchViewController *searchVC = [[UUStockSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)editingAction
{
    UUFavourisManagerViewController *favManagerViewController = [[UUFavourisManagerViewController alloc] initWithViewControllers:@[@"UUFavourisStockEditViewController",@"UUFavourisGroupEditViewController"]];
    favManagerViewController.editing = NO;
    


    [self.navigationController pushViewController:favManagerViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的自选";
    
    if (self.editing)
    {
        [self addRightBarButtons];
    }
    CGFloat headerViewHeight = UUFavourisManagerHeaderViewHeight;

    UUFavourisManagerHeaderView *headerView = [[UUFavourisManagerHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),headerViewHeight)];
    headerView.delegate = self;
    _headerView = headerView;
    _headerView.titles = @[@"股票",@"组合"];

    [self.view addSubview:headerView];
    
    // 设置UIPageViewController的配置项
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    
    // 实例化UIPageViewController对象，根据给定的属性
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options: options];
    // 设置UIPageViewController对象的代理
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    // 定义“这本书”的尺寸
    _pageViewController.view.frame = CGRectMake(0, headerViewHeight, PHONE_WIDTH, PHONE_HEIGHT - headerViewHeight);
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    
    NSArray *viewControllers =[NSArray arrayWithObject:[self viewControllerAtIndex:0]];
    
    
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [[self view] addSubview:[_pageViewController view]];
}

- (NSInteger)indexOfViewController:(UIViewController *)viewController
{
    return [self.viewControllers indexOfObject:NSStringFromClass([viewController class])];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index < self.viewControllers.count)
    {
        return [[NSClassFromString([self.viewControllers objectAtIndex:index]) alloc] init];
    }
    return nil;
}

#pragma mark - UIPageViewControllerDelegate,UIPageViewControllerDataSource
// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
    
    
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.viewControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
 
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    _currentIndex = [self indexOfViewController:[pendingViewControllers objectAtIndex:0]];
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed ) {
        [_headerView scrollWithButtonIndex:_currentIndex];
    }else{
        _currentIndex = [self indexOfViewController:[previousViewControllers objectAtIndex:0]];
    }
}
#pragma mark -  UUFavourisManagerHeaderViewDelegate
- (void)headerView:(UUFavourisManagerHeaderView *)headerView didSeletedIndex:(NSInteger)index
{
    UIPageViewControllerNavigationDirection direction ;
    
    
    if (index == _currentIndex) {
        return;
        
    }else if (index > _currentIndex){
        //从右向左滑动
        direction = UIPageViewControllerNavigationDirectionForward;
    }else{
        //从左向右滑动
        direction = UIPageViewControllerNavigationDirectionReverse;
        
    }
    
    
    //    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    
    [_pageViewController setViewControllers:@[[self viewControllerAtIndex:index]] direction:direction animated:YES completion:^(BOOL finished) {
        //        weakSelf.view.userInteractionEnabled = YES;
        
        if (finished) {
            weakSelf.currentIndex = index;

        }
    }];
}



@end
