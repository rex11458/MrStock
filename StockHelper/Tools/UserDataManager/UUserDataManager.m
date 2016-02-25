//
//  UUserDataManager.m
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUserDataManager.h"

NSString * const UserIsOnLineInfoKey = @"userIsOnLineInfoKey";
//NSString * const KEY_USERNAME_PASSCODELOCK = @"com.liantai.tt.passwordlock";
//NSString * const FirstEnterMainInfoKey = @"firstEnterMainInfoKey";
//NSString *const GestureErrorTimesInfoKey = @"gestureErrorTimesInfoKey";

@implementation User

- (NSString *)customerID
{
    if (_customerID == nil) {
        _customerID = @"";
    }
    return _customerID;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self) {
        [self setCustomerID:[aDecoder decodeObjectForKey:@"customerID"]];
        
        [self setHeadImg:[aDecoder decodeObjectForKey:@"headImg"]];
       
        [self setMobile:[aDecoder decodeObjectForKey:@"mobile"]];
        
        [self setNickName:[aDecoder decodeObjectForKey:@"nickName"]];
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        
        [self setDepict:[aDecoder decodeObjectForKey:@"depict"]];

        
        [self setScores:[aDecoder decodeObjectForKey:@"scores"]];
        [self setFansCount:[aDecoder decodeObjectForKey:@"fansCount"]];
        [self setFollowCount:[aDecoder decodeObjectForKey:@"followCount"]];
        [self setMessageCount:[aDecoder decodeObjectForKey:@"messageCount"]];
        [self setActivityCount:[aDecoder decodeObjectForKey:@"activityCount"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.customerID forKey:@"customerID"];

    [aCoder encodeObject:self.headImg forKey:@"headImg"];

    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];

    [aCoder encodeObject:self.depict forKey:@"depict"];

    
    [aCoder encodeObject:self.scores forKey:@"scores"];
    [aCoder encodeObject:self.fansCount forKey:@"fansCount"];
    [aCoder encodeObject:self.followCount forKey:@"followCount"];
    [aCoder encodeObject:self.messageCount forKey:@"messageCount"];
    [aCoder encodeObject:self.activityCount forKey:@"activityCount"];
}


@end

@implementation UULoginUser

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self setSessionID:[aDecoder decodeObjectForKey:@"sessionID"]];

        [self setCookie:[aDecoder decodeObjectForKey:@"cookie"]];
//        [self setCustomerID:[aDecoder decodeObjectForKey:@"customerID"]];
        [self setDeviceID:[aDecoder decodeObjectForKey:@"deviceID"]];
        [self setEmail:[aDecoder decodeObjectForKey:@"email"]];
        
//        [self setHeadImg:[aDecoder decodeObjectForKey:@"headImg"]];
        [self setInviteCode:[aDecoder decodeObjectForKey:@"inviteCode"]];
        [self setInviteNumber:[aDecoder decodeObjectForKey:@"inviteNumber"]];
        [self setInviter:[aDecoder decodeObjectForKey:@"inviter"]];
        [self setIp:[aDecoder decodeObjectForKey:@"ip"]];
        
        [self setLastLoginIP:[aDecoder decodeObjectForKey:@"lastLoginIP"]];
        [self setLastLoginTime:[aDecoder decodeObjectForKey:@"lastLoginTime"]];
        [self setMarkSource:[aDecoder decodeObjectForKey:@"markSource"]];
//        [self setMobile:[aDecoder decodeObjectForKey:@"mobile"]];
//        [self setName:[aDecoder decodeObjectForKey:@"name"]];

//        [self setNickName:[aDecoder decodeObjectForKey:@"nickName"]];
        [self setRegisterTime:[aDecoder decodeObjectForKey:@"registerTime"]];
        [self setRetireTime:[aDecoder decodeObjectForKey:@"retireTime"]];
        [self setSex:[aDecoder decodeObjectForKey:@"sex"]];
        [self setStatus:[aDecoder decodeObjectForKey:@"status"]];
    
//        [self setScores:[aDecoder decodeObjectForKey:@"scores"]];
//        [self setFansCount:[aDecoder decodeObjectForKey:@"fansCount"]];
//        [self setFollowCount:[aDecoder decodeObjectForKey:@"followCount"]];
//        [self setMessageCount:[aDecoder decodeObjectForKey:@"messageCount"]];
//        [self setActivityCount:[aDecoder decodeObjectForKey:@"activityCount"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sessionID forKey:@"sessionID"];

    
    [aCoder encodeObject:self.cookie forKey:@"cookie"];
//    [aCoder encodeObject:self.customerID forKey:@"customerID"];
    [aCoder encodeObject:self.deviceID forKey:@"deviceID"];
    [aCoder encodeObject:self.email forKey:@"email"];

//    [aCoder encodeObject:self.headImg forKey:@"headImg"];
    [aCoder encodeObject:self.inviteCode forKey:@"inviteCode"];
    [aCoder encodeObject:self.inviteNumber forKey:@"inviteNumber"];
    [aCoder encodeObject:self.inviter forKey:@"inviter"];
    [aCoder encodeObject:self.ip forKey:@"ip"];

    [aCoder encodeObject:self.lastLoginIP forKey:@"lastLoginIP"];
    [aCoder encodeObject:self.lastLoginTime forKey:@"lastLoginTime"];
    [aCoder encodeObject:self.markSource forKey:@"markSource"];
//    [aCoder encodeObject:self.mobile forKey:@"mobile"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//
//    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.registerTime forKey:@"registerTime"];
    [aCoder encodeObject:self.retireTime forKey:@"retireTime"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.status forKey:@"status"];
//    /*
//     scores
//     fansCount
//     followCount
//     messageCount
//     activityCount
//     */
//    [aCoder encodeObject:self.scores forKey:@"scores"];
//    [aCoder encodeObject:self.fansCount forKey:@"fansCount"];
//    [aCoder encodeObject:self.followCount forKey:@"followCount"];
//    [aCoder encodeObject:self.messageCount forKey:@"messageCount"];
//    [aCoder encodeObject:self.activityCount forKey:@"activityCount"];
//    
    [super encodeWithCoder:aCoder];
}

@end

@implementation UUserDataManager

- (instancetype)init
{
    if(self = [super init])
    {
    }
    return self;
}

static id shared = nil;
+ (UUserDataManager *)sharedUserDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        
    });
    return shared;
}

- (UULoginUser *)user
{
    if (_user == nil) {
        
        NSString *path=[UUserDataManager userDataArchivePath];
        // NSLog(@"path == %@",path);
        _user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (_user == nil) {
            _user = [[UULoginUser alloc] init];
            return _user;
        }
    }
//    bd956a15cb44ccf3de45456fa447b611
    return _user;

}
//登录
+ (void)saveUserLoggingInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:UserIsOnLineInfoKey];
    [defaults synchronize];
    [UUserDataManager saveUserInfo];
}


//获取用户是否在线
+ (BOOL)userIsOnLine
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UserIsOnLineInfoKey] boolValue];
}

//保存登录后用户数据
+ (NSString *)userDataArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"userData.archive"];
}

+ (void)saveUserInfo
{
    NSString *path=[UUserDataManager userDataArchivePath];
    DLog(@"====%@",path);
    [NSKeyedArchiver archiveRootObject:[UUserDataManager sharedUserDataManager].user toFile:path];
}

//退出登录
+ (void)saveUserLogoffInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:UserIsOnLineInfoKey];
    [defaults synchronize];
    [UUserDataManager sharedUserDataManager].user = nil;
    NSString *path=[UUserDataManager userDataArchivePath];
    [NSKeyedArchiver archiveRootObject:nil toFile:path];
}

@end
