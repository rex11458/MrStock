//
//  BaseCollectionViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/9/21.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:k_TABLEVIEWCELL_SELECTED_IMAGE];
    }
    return self;
}

@end
