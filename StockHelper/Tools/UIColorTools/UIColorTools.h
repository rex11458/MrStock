//
//  UIColorTools.h
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorModel.h"
@interface UIColorTools : NSObject

+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

+ (ColorModel *) RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

@end
