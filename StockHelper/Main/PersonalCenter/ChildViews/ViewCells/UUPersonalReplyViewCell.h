//
//  UUPersonalReplyViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/10/30.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseViewCell.h"
@class UUPersonalReplyModel;
#define UUPersonalReplyViewCellHeight 140.0f
@interface UUPersonalReplyViewCell : BaseViewCell

@property (nonatomic,strong) UUPersonalReplyModel *replyModel;
@property (strong, nonatomic) IBOutlet UILabel *replyContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicContentLabel;

@end
