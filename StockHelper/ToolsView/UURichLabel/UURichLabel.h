//
//  UURichLabel.h
//  StockHelper
//
//  Created by LiuRex on 15/9/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UURichLabel : UILabel

+ (CGRect)boundingRectWithSize:(CGSize)size string:(NSString *)text attributes:(NSDictionary *)attributes;
@end
