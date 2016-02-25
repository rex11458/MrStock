//
//  NSTimer+Addition.m
//  StockHelper
//
//  Created by LiuRex on 15/8/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "NSTimer+Addition.h"




@implementation NSTimer (Addition)


-(void)pauseTimer{
    
    if (![self isValid]) {
        return ;
    }
    
    [self setFireDate:[NSDate distantFuture]]; //如果给我一个期限，我希望是4001-01-01 00:00:00 +0000
    
    
}


-(void)resumeTimer{
    
    if (![self isValid]) {
        return ;
    }
    
    //[self setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self setFireDate:[NSDate date]];
    
}

@end

