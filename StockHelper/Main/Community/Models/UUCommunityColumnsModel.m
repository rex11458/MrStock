//
//  UUCommunityColumnsModel.m
//  StockHelper
//
//  Created by LiuRex on 15/7/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityColumnsModel.h"

@implementation UUCommunityColumnsModel

+(JSONKeyMapper*)keyMapper
{
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithJSONToModelBlock:^NSString *(NSString *keyName) {
        

        return keyName;
        
    } modelToJSONBlock:^NSString *(NSString *keyName) {
       
        if ([keyName isEqualToString:@"columnDescription"]) {
            return @"description";
        }
        
        
        return keyName;
    }];
    
    
    return mapper;
}
@end

@implementation UUCommunityColumnsListModel



@end