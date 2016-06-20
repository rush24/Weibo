//
//  AccountTool.m
//  微博
//
//  Created by 张智勇 on 15/12/5.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#define AccountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]


#import "AccountTool.h"

@implementation AccountTool

+ (void)save:(Account *)account
{
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFilepath];
}

+ (Account *)account
{
    // 读取帐号
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFilepath];
    // 判断帐号是否已经过期
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *localeNow = [now  dateByAddingTimeInterval: interval];
        
    if ([localeNow compare:account.expires_time] != NSOrderedAscending) { // 过期
        account = nil;
    }
    return account;
}

+ (void)accessTokeWithParam:(AccessTokenParam *)param success:(void(^)(Account *account))success failure:(void(^)(NSError *))failure{
    NSDictionary *params = param.keyValues;
    [HttpTool post:@"https://api.weibo.com/oauth2/access_token" params:params success:^(id responseObj) {
        if(success){
            Account *result = [Account objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

@end
