//
//  UIImage+Compress.h
//  StockHelper
//
//  Created by LiuRex on 15/7/6.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)
//图片压缩

- (NSData *)compressData;

- (UIImage*)imageScaledToSize:(CGSize)newSize;



@end
