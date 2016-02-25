//
//  UUPersonalHomeSubView.m
//  StockHelper
//
//  Created by LiuRex on 15/9/9.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalHomeSubView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Compress.h"
#import "UIImage+ImageEffects.h"
@implementation UUPersonalHomeSubView

- (void)awakeFromNib
{
    _headerImageView.layer.cornerRadius = CGRectGetWidth(_headerImageView.frame) * 0.5;
    _headerImageView.layer.masksToBounds = YES;
}

- (void)setUser:(User *)user
{
    if (user == nil || user == _user) {
        return;
    }
    _user = user;
    [self fillData];
}

- (void)fillData
{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_user.headImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _bgImageView.image = [image applyLightEffect];
        
    }];
    
    _nameLabel.text = _user.nickName;
    _fansLabel.text = [NSString stringWithFormat:@"粉丝：%@",[_user.fansCount stringValue]];
    _valueLabel.text = [NSString stringWithFormat:@"积分：%@",[_user.scores stringValue]];
    _idealLabel.text = [NSString stringWithFormat:@"投资理念：%@",_user.depict];
    
}

- (UIImage *)blurImage:(UIImage *)orgImage
{
    CGFloat width = PHONE_WIDTH;
    CGFloat height = PHONE_WIDTH * orgImage.size.height / orgImage.size.width;
    orgImage = [orgImage imageScaledToSize:CGSizeMake(width,height)];

    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:orgImage];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:5] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    CGImageRef cgImage = [context createCGImage:result fromRect:self.bounds];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

@end
