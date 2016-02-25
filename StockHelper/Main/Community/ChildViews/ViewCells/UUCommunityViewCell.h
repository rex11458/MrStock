//
//  UUCommunityViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUCommunityTopicNormalListModel;
#define UUCommunityViewCellHeight  140.0f
@interface UUCommunityViewCell : BaseViewCell

@property (nonatomic,assign) BOOL isEssential; //是否为精华帖

@property (nonatomic,assign) id target;

@property (nonatomic)       SEL userHomeAction;

@property (nonatomic)        SEL stockDetailAction;


@property (nonatomic,strong) UUCommunityTopicNormalListModel *normalListModel;

@property (strong, nonatomic) IBOutlet UIButton *headerImage;
@property (strong, nonatomic) IBOutlet UIButton *nameButton;

@property (strong, nonatomic) IBOutlet UILabel *fansLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *essentialImage;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;
- (IBAction)userHomeAction:(id)sender;

@end
