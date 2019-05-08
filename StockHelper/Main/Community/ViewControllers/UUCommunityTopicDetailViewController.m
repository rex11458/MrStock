//
//  UUCommunityTopicDetailViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityTopicDetailViewController.h"
#import "UUCommunityTopicDetailViewCell.h"
#import "UUTopicContainerView.h"
#import "UUCommunityHandler.h"
#import "UUCommunityTopicListModel.h"
#import "UUTopicPraiseListModel.h"
#import "UUTopicReplyListModel.h"
#import "HPGrowingTextView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreText/CoreText.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UUImageScanView.h"
#import "UUCommunityTopicDetailPraiseListView.h"
#import "UUPersonalHomeViewController.h"
#import "UULoginViewController.h"
#import "UURichTextView.h"
#import "UUStockIdxDetailViewController.h"
#import "UUPersonalStockDetailViewController.h"
#define USER_INFO_HEIGHT 58.0f

@interface UUCommunityTopicDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,UUTopicContainerViewDelegate,UUCommunityTopicDetailHeaderViewDelegate>
{
    UITableView *_tableView;
    UIView *_sectionView;
    UUCommunityTopicDetailHeaderView *_headerView;
    UUTopicContainerView *_containerView;
    
    UUTopicReplyListModel *_replyListModel;
//    UUTopicPraiseListModel *_praiseListModel;
    
    NSMutableArray *_praiseModelArray;
    
    NSMutableArray *_dataArray;
    
    NSInteger _replyType; // 0回复话题 1回复某条评论
    UUCommunityTopicDetailViewCell *_seletedCell; //选中的IndexPath；
    
    NSInteger _collectionID;
    
    UIButton *_favButton;
    
    
    NSInteger _pageIndex;
    NSInteger _pageSize;
    
    UIView *_noDataBGView; //没有数据时显示的图片
}
@end

@implementation UUCommunityTopicDetailViewController

- (instancetype)init
{
    if (self = [super init]) {
        _pageSize = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    [self addRightButtonWithSelected:NO];
    
    if ([UUserDataManager userIsOnLine]) {
        [self loadIsFav];
    }
    
    [self configSubViews];
    [self loadData];
}

- (void)addRightButtonWithSelected:(BOOL)selected
{
    UIImage *favImage = [UIImage imageNamed:@"Nav_collection"];
    UIImage *favSelectedImage = [UIImage imageNamed:@"Nav_Collection_selected"];
    UIButton *favButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, favImage.size.width  * 2, favImage.size.height) title:nil titleHexColor:nil font:nil];
    favButton.selected = selected;
    _favButton = favButton;
    [favButton setImage:favImage forState:UIControlStateNormal];
    [favButton setImage:favSelectedImage forState:UIControlStateSelected];

    [favButton addTarget:self action:@selector(favAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:favButton];
    
    self.navigationItem.rightBarButtonItems = @[item1];
}

- (void)loadIsFav
{
    _favButton.userInteractionEnabled = NO;
    [[UUCommunityHandler sharedCommunityHandler] isCollected:[@(_topicModel.id) stringValue] type:1 success:^(NSNumber *value) {
        
        _collectionID = [value integerValue];
        [self addRightButtonWithSelected:(_collectionID != -1)];
        _favButton.selected = (_collectionID != -1);
        _favButton.userInteractionEnabled = YES;
    } failure:^(NSString *errorMessage) {
        
    }];
}


- (void)deleteTopic:(void (^)(void))deleteTopic
{
    _deleteTopic = [deleteTopic copy];
}

- (void)praiseTopic:(void (^)(void))praiseTopic
{
    _praiseTopic = [praiseTopic copy];
}

- (void)deleteReply:(void(^)(void))deleteReply
{
    _deleteReply = [deleteReply copy];
}

- (void)replySuccess:(void(^)(void))replySuccess
{
    _replySuccess = [replySuccess copy];
}

- (void)loadData
{
    _pageIndex = 1;
    //评论列表
    [[UUCommunityHandler sharedCommunityHandler] getTopicCommentListWithSubjectId:_topicModel.id pageNo:_pageIndex pageSize:_pageSize success:^(UUTopicReplyListModel *replyListModel) {
        
        _replyListModel = replyListModel;
    
        _dataArray = [replyListModel.list mutableCopy];

        _noDataBGView.hidden = (_dataArray.count != 0);

        //
        [_tableView reloadData];
        [_tableView.header endRefreshing];

    } failure:^(NSString *errorMessage) {
        [_tableView.header endRefreshing];

    }];
    
    if (![_tableView.header isRefreshing]) {
        [self showLoading];
    }
    //点赞列表
    [[UUCommunityHandler sharedCommunityHandler] getTopicPraiseListWithSubjectId:_topicModel.id pageNo:1 pageSize:10 success:^(UUTopicPraiseListModel *praiseListModel) {
        _praiseModelArray = [[NSMutableArray alloc] initWithArray:praiseListModel.list];
        _headerView.praiseModelArray = _praiseModelArray;
        [self stopLoading];
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void)loadMore
{
    _pageIndex++;
    //评论列表
    [[UUCommunityHandler sharedCommunityHandler] getTopicCommentListWithSubjectId:_topicModel.id pageNo:_pageIndex pageSize:_pageSize success:^(UUTopicReplyListModel *replyListModel) {
        
        _replyListModel = replyListModel;
        
        NSArray *dataArray = [[NSArray alloc] initWithArray:_dataArray];
       _dataArray = [[dataArray arrayByAddingObjectsFromArray:replyListModel.list] mutableCopy];
        
        _noDataBGView.hidden = (_dataArray.count != 0);
        //
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
        
    } failure:^(NSString *errorMessage) {
        [_tableView.footer endRefreshing];

    }];
    
    if (![_tableView.header isRefreshing] &&![_tableView.footer isRefreshing]) {
        [self showLoading];
    }
    //点赞列表
    [[UUCommunityHandler sharedCommunityHandler] getTopicPraiseListWithSubjectId:_topicModel.id pageNo:1 pageSize:10 success:^(UUTopicPraiseListModel *praiseListModel) {
        _praiseModelArray = [praiseListModel.list mutableCopy];
        _headerView.praiseModelArray = _praiseModelArray;
        [self stopLoading];
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void)configSubViews
{
    CGRect frame = CGRectMake(0,0, PHONE_WIDTH, CGRectGetHeight(self.view.bounds) - kUUTopicContainerViewHeight);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = k_BG_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _headerView = [self tableHeaderView];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _tableView.tableHeaderView = _headerView;
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    _tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    [self.view addSubview:_tableView];
    
    //输入框
    _containerView = [[UUTopicContainerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - kUUTopicContainerViewHeight, PHONE_WIDTH, kUUTopicContainerViewHeight)];
    _containerView.delegate = self;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_containerView];
    
    //空数据时显示的图片
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_tableView.tableHeaderView.frame), PHONE_WIDTH,CGRectGetHeight(_tableView.frame) - CGRectGetHeight(_tableView.tableHeaderView.frame))];
    [_tableView addSubview:bgView];
    _noDataBGView = bgView;
    [self showNodataWithTitle:k_remainder(@"no_data_community_topic_reply") inView:_noDataBGView];
}

- (UUCommunityTopicDetailHeaderView *) tableHeaderView
{
    UUCommunityTopicDetailHeaderView *headerView = [[UUCommunityTopicDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), UUCommunityTopicDetailHeaderViewHeight)];
    headerView.topicModel = self.topicModel;
    headerView.target = self;
    headerView.userHomeAciton = @selector(headerViewPushToUserHomeViewController:);
    headerView.stockDetailAction = @selector(headerViewPushToStockDetailViewController:);
    headerView.delegate = self;
    CGRect frame = headerView.frame;
    frame.size.height = UUCommunityTopicDetailHeaderViewHeight + [UUCommunityTopicDetailHeaderView contentBoundsWithText:_topicModel.content].size.height;
    frame.size.height += [headerView imageMaxHeight];
    headerView.frame = frame;
    
    [headerView.praiseListView select:^(UUTopicPraiseModel * praiseModel) {
       
        UUPersonalHomeViewController *homeVC = [[UUPersonalHomeViewController alloc] init];
        [self.navigationController pushViewController:homeVC animated:YES];
    }];
    return headerView;
}

- (void)favAction
{
    if (![UUserDataManager userIsOnLine]) {
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:(self.navigationController.viewControllers.count - 1) success:^{
            [self loadIsFav];
            [self fav];
        } failed:^{
            
        }];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    [self fav];
}

- (void)fav
{
    if (_collectionID == -1) {
        [[UUCommunityHandler sharedCommunityHandler] collectWithCollectedID:[@(_topicModel.id) stringValue] type:1 success:^(id obj) {
            
            [SVProgressHUD showSuccessWithStatus:@"收藏成功" maskType:SVProgressHUDMaskTypeBlack];
            _collectionID = [obj integerValue];
            _favButton.selected = YES;
        } failure:^(NSString *errorMessage) {
        }];
    }else
    {
        [[UUCommunityHandler sharedCommunityHandler] cancelCollectedListID:[@(_collectionID) stringValue] success:^(id obj) {
            
            [SVProgressHUD showSuccessWithStatus:@"取消收藏成功" maskType:SVProgressHUDMaskTypeBlack];
            _collectionID = -1;
            _favButton.selected = NO;
        } failure:^(NSString *errorMessage) {
            
        }];
    }
}

#pragma mark - 跳转到用户主页
- (void)pushToUserHomeViewController:(UUCommunityTopicDetailViewCell *)cell
{
    UUPersonalHomeViewController *homeVC = [[UUPersonalHomeViewController alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];
}
#pragma mark - 透视图点击头像跳转到用户主页
- (void)headerViewPushToUserHomeViewController:(UUCommunityTopicDetailHeaderView *)headerView
{
    UUPersonalHomeViewController *homeVC = [[UUPersonalHomeViewController alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];
}

#pragma mark - 跳转到股票详情
- (void)headerViewPushToStockDetailViewController:(NSString *)stockCode
{
#warning --
    UIViewController *vc = nil;
//    if (stockCode.length > 6)
//    {
//        UUStockIdxDetailViewController * idxVC = [[UUStockIdxDetailViewController alloc] init];
//        idxVC.code = stockCode;
//        vc = idxVC;
//    }
//    else
//    {
//        UUPersonalStockDetailViewController *norVC = [[UUPersonalStockDetailViewController alloc] init];
//        norVC.code = stockCode;
//        vc = norVC;
//    }
    
    vc.title = [NSString stringWithFormat:@"%@(%@)",@"",[stockCode substringToIndex:6]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UUCommunityTopicDetailHeaderViewDelegate
- (void)headerView:(UUCommunityTopicDetailHeaderView *)headerView didSelectedIndex:(NSInteger)index
{
    
    if (![UUserDataManager userIsOnLine]) {
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:(self.navigationController.viewControllers.count - 1) success:^{
            [self headerViewOperationWithIndex:index];
        } failed:^{
            
        }];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    [self headerViewOperationWithIndex:index];
}

- (void)headerViewOperationWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        //评论
        _replyType = 0;
        [_containerView becomeFirstResponder];
    }
    else if (index == 1)
    {
        //        //点赞
        _headerView.praiseButton.userInteractionEnabled = NO;
        [[UUCommunityHandler sharedCommunityHandler] praiseTopicWithSubId:_topicModel.id isSupport:!_topicModel.selfIsSupport success:^(UUTopicPraiseModel *praiseModel) {
            
            _topicModel.selfIsSupport = !_topicModel.selfIsSupport;
            _headerView.praiseButton.userInteractionEnabled = YES;
            
            _topicModel.supportAmount += _topicModel.selfIsSupport ? 1 : -1;
            _headerView.topicModel = _topicModel;
            
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_headerView.praiseModelArray];
            
            if (_topicModel.selfIsSupport) {
                [arr addObject:praiseModel];
            }else{
                [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UUTopicPraiseModel *model = (UUTopicPraiseModel *)obj;
                    if ([praiseModel.userId isEqualToString:model.userId]) {
                        if ([arr containsObject:model]) {
                            [arr removeObject:model];
                        }
                    }
                }];
            }
            _headerView.praiseModelArray = arr;
            if (_praiseTopic) {
                _praiseTopic();
            }
        } failure:^(NSString *errorMessage) {
            _headerView.praiseButton.userInteractionEnabled = YES;
        }];
    }
    else if (index == 2)
    {
        //删除话题
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除该话题?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


#pragma mark - UUTopicContainerViewDelegate
- (void)containerView:(UUTopicContainerView *)containerView sendMessage:(NSString *)message
{
    if (message.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"输入内容不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (![UUserDataManager userIsOnLine]) {
        
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:(self.navigationController.viewControllers.count - 1) success:^{
            [self containerViewOperationSendMessage:message];
        } failed:^{
            
        }];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    [self containerViewOperationSendMessage:message];
}

- (void)containerViewOperationSendMessage:(NSString *)message
{
    if (_replyType == 0) {
        //回复话题
        [SVProgressHUD showWithStatus:@"正在回复..." maskType:SVProgressHUDMaskTypeBlack];
        [[UUCommunityHandler sharedCommunityHandler]  commentTopicWithSubId:_topicModel.id content:message relevanceId:_topicModel.relevanceId success:^(UUTopicReplyModel *replyModel) {
            if (_dataArray == nil) {
                _dataArray = [NSMutableArray array];
            }
            [_dataArray insertObject:replyModel atIndex:0];
            _noDataBGView.hidden = (_dataArray.count != 0);
            
            //话题评论数加一
            _topicModel.replyAmount += 1;
            _topicModel.selfIsReply = YES;
            _headerView.topicModel = _topicModel;
            
            if (_replySuccess) {
                _replySuccess();
            }
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [SVProgressHUD showSuccessWithStatus:@"回复成功!" maskType:SVProgressHUDMaskTypeBlack];
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }else if(_replyType == 1){
        //回复某条评论
        UUTopicReplyModel *topicReplyModel = _seletedCell.topicReplyModel;
        
        [[UUCommunityHandler sharedCommunityHandler] replyUserWithReplyId:topicReplyModel.id relevanceId:@"r1" content:message success:^(UUTopicReplyModel *replyModel) {
            
            [_dataArray insertObject:replyModel atIndex:0];
            
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            //话题评论数加一
            _topicModel.replyAmount += 1;
            _topicModel.selfIsReply = YES;
            _headerView.topicModel = _topicModel;
            
            if (_replySuccess) {
                _replySuccess();
            }
            _replyType = 0;
        } failure:^(NSString *errorMessage) {
            
        }];
    }
}

- (void)containerViewResignFirstResponder:(UUTopicContainerView *)containerView
{
    
    _replyType = 0;
}

#pragma mark - UITableView delegatge、datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UUCommunityTopicDetailViewCell";
    
    UUCommunityTopicDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UUCommunityTopicDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.target = self;
        cell.userHomeAciton = @selector(pushToUserHomeViewController:);
    }
    cell.topicReplyModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = UUCommunityTopicDetailViewCellHeight + [UUCommunityTopicDetailViewCell contentBoundsWithText:[[_dataArray objectAtIndex:indexPath.row] content]].size.height;
    height += [[[_dataArray objectAtIndex:indexPath.row] tgtUserId] length] ? UUCommunityTopicDetailSubViewHeight : 0;
    
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![UUserDataManager userIsOnLine]) {
        UULoginViewController *loginVC = [[UULoginViewController alloc] initWithIndex:(self.navigationController.viewControllers.count - 1) success:^{
            [self tableViewOperationWithIndexPath:indexPath];
        } failed:^{
            
        }];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    [self tableViewOperationWithIndexPath:indexPath];
}

- (void)tableViewOperationWithIndexPath:(NSIndexPath *)indexPath
{
    _seletedCell = (UUCommunityTopicDetailViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if (![_seletedCell.topicReplyModel.userId isEqualToString:[UUserDataManager sharedUserDataManager].user.customerID])
    {
        _replyType = 1;
        _containerView.textView.placeholder = [NSString stringWithFormat:@"回复：%@",_seletedCell.topicReplyModel.userName];
        [_containerView becomeFirstResponder];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确认删除该条评论?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
}


#pragma mark -  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeBlack];
        [[UUCommunityHandler sharedCommunityHandler] deleteReplyWithReplyId:_seletedCell.topicReplyModel.id success:^(id obj) {
            NSIndexPath *indexPath = [_tableView indexPathForCell:_seletedCell];
            [_dataArray removeObjectAtIndex:indexPath.row];
            
            //话题评论数减一
            if (_topicModel.replyAmount > 0) {
                _topicModel.replyAmount -= 1;
                _topicModel.selfIsReply = NO;
                _headerView.topicModel = _topicModel;
            }
            if (_deleteReply) {
                _deleteReply();
            }
            [SVProgressHUD showSuccessWithStatus:@"删除成功!" maskType:SVProgressHUDMaskTypeBlack];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            _noDataBGView.hidden = (_dataArray.count !=0);
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }
}

#pragma mark -  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //删除话题
        [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeBlack];
        [[UUCommunityHandler sharedCommunityHandler] deleteTopicWithSubId:_topicModel.id success:^(id obj) {
            if (_deleteTopic) {
                _deleteTopic();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"删除成功!" maskType:SVProgressHUDMaskTypeBlack];
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }
}

@end


@implementation UUCommunityTopicDetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configSubViews
{
    _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageButton.frame =CGRectMake(2 * k_LEFT_MARGIN, k_TOP_MARGIN, 39.0f, 39);
    _imageButton.layer.cornerRadius = 39 * 0.5f;
    _imageButton.layer.masksToBounds = YES;
    [_imageButton setImage:[UIImage imageNamed:@"default_headerImage"] forState:UIControlStateNormal];
    //    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageButton];
    [_imageButton addTarget:self action:@selector(imageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _nameLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + k_LEFT_MARGIN,_imageButton.center.y - 20.0f,200, 20.0f) Font:[UIFont boldSystemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    [self addSubview:_nameLabel];
    _nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageButtonAction)];
    [_nameLabel addGestureRecognizer:tapGes];
    
    _fansLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + k_LEFT_MARGIN,_imageButton.center.y,100, 20.0f) Font:k_MIDDLE_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    [self addSubview:_fansLabel];
    
    _commentButton = [UIKitHelper buttonWithFrame:CGRectZero title:@"评论" titleHexColor:@"#ADADAD" font:[UIFont systemFontOfSize:14.0f]];
    _commentButton.tag = 0;
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_commentButton setImage:[UIImage imageNamed:@"Stock_detail_pinglun"] forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"Stock_detail_pinglun_selected"] forState:UIControlStateSelected];
    [_commentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    
    _praiseButton = [UIKitHelper buttonWithFrame:CGRectZero title:@"赞" titleHexColor:@"#ADADAD" font:[UIFont systemFontOfSize:14.0f]];
    _praiseButton.tag = 1;
    _praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);

    [_praiseButton setImage:[UIImage imageNamed:@"Stock_detail_zan"] forState:UIControlStateNormal];
    [_praiseButton setImage:[UIImage imageNamed:@"Stock_detail_zan_selected"] forState:UIControlStateSelected];

    [_praiseButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_praiseButton];
    
    //删除按钮
    _deleteButton = [UIKitHelper buttonWithFrame:CGRectZero title:@"" titleHexColor:@"#ADADAD" font:[UIFont systemFontOfSize:14.0f]];
    _deleteButton.tag = 2;
    [_deleteButton setImage:[UIImage imageNamed:@"TopicDetail_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteButton];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, USER_INFO_HEIGHT, PHONE_WIDTH, 0.5f)];
    line.backgroundColor = k_LINE_COLOR;
    [self addSubview:line];
    _textView = [[UURichTextView alloc] initWithFrame:CGRectMake(2 * k_LEFT_MARGIN,USER_INFO_HEIGHT, CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN, 0) selectStock:^(NSString *stockCode) {
        if ([_target respondsToSelector:_stockDetailAction]) {
            [_target performSelector:_stockDetailAction withObject:stockCode afterDelay:0.0];
        }
    }];

    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = k_MIDDLE_TEXT_FONT;
    _textView.textColor = k_BIG_TEXT_COLOR;
    [self addSubview:_textView];
    
    
    _createTimteLabel = [UIKitHelper labelWithFrame:CGRectMake(2 * k_LEFT_MARGIN,0, CGRectGetWidth(self.bounds) * 0.5, 40.0f) Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    [self addSubview:_createTimteLabel];
    
    _praiseListView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUCommunityTopicDetailPraiseListView class]) owner:self options:nil] firstObject];
    _praiseListView.backgroundColor = k_BG_COLOR;
    [self addSubview:_praiseListView];
}

- (void)configImageViews
{
    _imageViewArray = [NSMutableArray array];
    NSString *imageString = _topicModel.images;
    NSData *data = [imageString dataUsingEncoding:NSASCIIStringEncoding];
    NSArray *images = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    CGFloat imageWidth = (PHONE_WIDTH - 4 *k_LEFT_MARGIN) / 3.0f;
    CGFloat imageY = CGRectGetMaxY(_textView.frame);

       for (NSInteger i = 0; i<images.count; i++) {
           
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[k_BASE_URL stringByAppendingFormat:@"head/subject/%@",images[i]]] placeholderImage:[UIImage imageNamed:@"image_default"]];
           
           if (images.count == 4) {

               imageView.frame = CGRectMake(2*k_LEFT_MARGIN +  i % 2 *(imageWidth + k_LEFT_MARGIN),i / 2 * (imageWidth + k_TOP_MARGIN) + imageY + k_TOP_MARGIN, imageWidth , imageWidth);
           }else{
               imageView.frame = CGRectMake(2*k_LEFT_MARGIN + i * imageWidth,imageY + k_TOP_MARGIN, imageWidth - 5, imageWidth - 5);
           }
           imageView.contentMode = UIViewContentModeCenter;
           imageView.clipsToBounds = YES;
           imageView.userInteractionEnabled = YES;
        
           UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)];
           [imageView addGestureRecognizer:ges];
           [_imageViewArray addObject:imageView];
        [self addSubview:imageView];
    }
}

#pragma mark - 点击头像
- (void)imageButtonAction
{
    if ([_target respondsToSelector:_userHomeAciton]) {
        [_target performSelector:_userHomeAciton withObject:self afterDelay:0.0];
    }
}



#pragma mark - 点击浏览图片
- (void)imageViewAction:(UIGestureRecognizer *)ges
{
    UIImageView *imageView = (UIImageView *)ges.view;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    [_imageViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        UIImageView *imageView = (UIImageView *)obj;
        [imageArray addObject:imageView.image];
        
    }];
    
    UUImageScanView *scanView = [[UUImageScanView alloc] initWithFrame:self.bounds ImageArray:imageArray currentIndex:[_imageViewArray indexOfObject:imageView]];
    scanView.editing = NO;
    [scanView show];
}

- (void)setTopicModel:(UUCommunityTopicNormalListModel *)topicModel
{
    if (topicModel == nil) {
        return;
    }
    _topicModel = topicModel;

        if (_topicModel.supportAmount > 0) {
            [_praiseButton setTitle:[[NSNumber numberWithInteger:_topicModel.supportAmount] stringValue] forState:UIControlStateNormal];
        }else
        {
            [_praiseButton setTitle:@"赞" forState:UIControlStateNormal];
            
        }
        if (_topicModel.replyAmount > 0) {
            [_commentButton setTitle:[[NSNumber numberWithInteger:_topicModel.replyAmount] stringValue] forState:UIControlStateNormal];
        }else
        {
            [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
            
        }
        _praiseButton.selected = _topicModel.selfIsSupport;
        _commentButton.selected = _topicModel.selfIsReply;
    
    _deleteButton.hidden = ![_topicModel.userId isEqualToString:[UUserDataManager sharedUserDataManager].user.customerID];
    
    [_imageButton sd_setImageWithURL:[NSURL URLWithString:topicModel.userPic] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"user_default"]];
    
        _textView.font = k_MIDDLE_TEXT_FONT;
        _textView.text = _topicModel.content;
        CGRect bounds = [[self class] contentBoundsWithText:_topicModel.content];
        CGRect frame = _textView.frame;
        frame.size.height = bounds.size.height;
        _textView.frame = frame;
        
        _createTimteLabel.text = _topicModel.createTime;
        _nameLabel.text = _topicModel.userName;
        NSString *fans = [NSString stringWithFormat:@"粉丝:%@",@(_topicModel.fansAmount)];
        _fansLabel.text = fans;
        
        if (_topicModel.images.length > 0 && _imageViewArray == nil) {
            [self configImageViews];
        }
}

- (void)setPraiseModelArray:(NSArray *)praiseModelArray
{
    if (praiseModelArray == nil) {
        return;
    }
    _praiseModelArray = [praiseModelArray copy];
    _praiseListView.praiseModelArray = _praiseModelArray;
}


+ (CGRect)contentBoundsWithText:(NSString *)text
{
    if (text == nil) {
        return CGRectZero;
    }
    CGRect bounds = [UURichLabel boundingRectWithSize:CGSizeMake(PHONE_WIDTH - 4 * k_LEFT_MARGIN, MAXFLOAT) string:text attributes:@{NSFontAttributeName:k_MIDDLE_TEXT_FONT}];
    
    return CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds) + 2 * k_TOP_MARGIN);
}

//- (CGFloat)praiseListViewHeight
//{
//    return [_praiseListView height];
//}

- (CGFloat)imageMaxHeight
{
    if (_imageViewArray.count == 0) {
        return 0;
    }
    
    CGFloat imageHeight = (PHONE_WIDTH - 4 *k_LEFT_MARGIN) / 3.0f ;

    if (_imageViewArray.count == 4) {
        imageHeight = imageHeight * 2;
    }
    return imageHeight;
}

- (void)buttonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [_delegate headerView:self didSelectedIndex:button.tag];
    }
}

- (void)layoutSubviews
{
    CGFloat buttonWidth = 60.0f;
    CGFloat buttonHeight = 40.0f;
    
    _deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - buttonWidth ,_imageButton.center.y - buttonHeight * 0.5,buttonWidth, buttonHeight);
    
    _praiseButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - buttonWidth ,CGRectGetMaxY(_textView.frame) + k_TOP_MARGIN + [self imageMaxHeight], buttonWidth, buttonHeight);

    _commentButton.frame = CGRectMake(CGRectGetMinX(_praiseButton.frame) - buttonWidth , CGRectGetMinY(_praiseButton.frame) , buttonWidth, buttonHeight);

    _createTimteLabel.frame =CGRectMake(2 * k_LEFT_MARGIN,CGRectGetMinY(_praiseButton.frame), CGRectGetWidth(self.bounds) * 0.5, 40.0f);
    _praiseListView.frame = CGRectMake(0, CGRectGetMaxY(_commentButton.frame), PHONE_WIDTH, 50.0f);
}

@end

