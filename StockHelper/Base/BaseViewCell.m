//
//  BaseViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/9/21.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseViewCell.h"

@implementation BaseViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:k_TABLEVIEWCELL_SELECTED_IMAGE];
        
    }
    return self;
}



- (void)awakeFromNib {
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:k_TABLEVIEWCELL_SELECTED_IMAGE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
