//
//  UUCommunityTopicDetailViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UURichLabel.h"

#define UUCommunityTopicDetailSectionViewHeight 39.0f
#define UUCommunityTopicDetailHeaderViewHeight 148.0f
@class UURichTextView;
@class UUTopicPraiseListModel;
@class UUCommunityTopicNormalListModel;
@class UUCommunityTopicDetailPraiseListView;
@protocol UUCommunityTopicDetailHeaderViewDelegate;

@interface UUCommunityTopicDetailViewController : BaseViewController
{
    void(^_deleteTopic)(void);
    void(^_praiseTopic)(void);
    void(^_deleteReply)(void);
    void(^_replySuccess)(void);
}
@property (nonatomic,strong) UUCommunityTopicNormalListModel *topicModel;

@property (nonatomic,assign) NSIndexPath *topicIndex;

- (void)deleteTopic:(void(^)(void))deleteTopic;
- (void)praiseTopic:(void(^)(void))praiseTopic;
- (void)deleteReply:(void(^)(void))deleteReply;
- (void)replySuccess:(void(^)(void))replySuccess;

@end


@interface UUCommunityTopicDetailHeaderView : UIView
{
    UIButton *_imageButton;    //头像
    
    UIButton *_commentButton;   //评论按钮
    
    UIButton *_deleteButton;    //删除
    
    UILabel *_fansLabel;         //粉丝数
    UILabel *_nameLabel;         //名字
    
    UURichTextView *_textView;
    
    UILabel *_createTimteLabel;
}

@property (nonatomic) id target;
@property (nonatomic) SEL userHomeAciton;
@property (nonatomic) SEL stockDetailAction;

//话题详情头部视图
@property (nonatomic,weak) id<UUCommunityTopicDetailHeaderViewDelegate> delegate;

@property (nonatomic,strong) UUCommunityTopicNormalListModel *topicModel; //话题详情
@property (nonatomic, copy) NSArray *praiseModelArray;

@property (nonatomic,strong) NSMutableArray *imageViewArray;

@property (nonatomic,strong,readonly) UIButton *praiseButton;

@property (nonatomic,strong) UUCommunityTopicDetailPraiseListView *praiseListView;

//图片高度
- (CGFloat)imageMaxHeight;

+ (CGRect)contentBoundsWithText:(NSString *)text;

@end

/*
 *
 */
@protocol UUCommunityTopicDetailHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(UUCommunityTopicDetailHeaderView *)headerView didSelectedIndex:(NSInteger)index;//0评论 1 点赞 2 删除

@end


////点赞列表
//@interface UUCommunityTopicDetailPraiseListView : UIView
//
//
//@property (nonatomic, strong) NSMutableArray *nameArray;
//@property (nonatomic, copy) NSString *nameString;
//
//
//@property (nonatomic,copy) NSArray * praiseModelArray;
//
//+ (CGSize)sizeWithText:(NSString *)text;
//- (CGFloat)height;
//
//@end
////
//
