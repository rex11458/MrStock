//
//  UIImage+Compress.m
//  StockHelper
//
//  Created by LiuRex on 15/7/6.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UIImage+Compress.h"
#define MAX_BETYS 1024 * 50
@implementation UIImage (Compress)

- (NSData *)compressData
{
    
//    UIImageJPEGRepresentation(self, <#CGFloat compressionQuality#>)
    
    
    return nil;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}




@end
