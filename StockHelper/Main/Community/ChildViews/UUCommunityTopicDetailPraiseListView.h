//
//  UUCommunityTopicDetailPraiseListView.h
//  UUStock
//
//  Created by LiuRex on 15/9/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUTopicPraiseModel;
@interface UUCommunityTopicDetailPraiseListView : UIView
{
    void(^_select)(UUTopicPraiseModel *);
}
@property (nonatomic,copy) NSArray * praiseModelArray;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (void)select:(void(^)(UUTopicPraiseModel *))select;


@end
