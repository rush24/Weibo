//
//  UserTool.m
//  微博
//
//  Created by 张智勇 on 15/12/27.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "UserTool.h"
#import "HttpTool.h"
#import "MJExtension.h"

@implementation UserTool

+ (void)userInfoWithParam:(UserInfoParam *)param success:(void(^)(UserInfoResult *))success failure:(void(^)(NSError *))failure{
        NSDictionary *params = param.keyValues;
        [HttpTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id responseObj) {
            if(success){
                UserInfoResult *result = [UserInfoResult objectWithKeyValues:responseObj];
                success(result);
            }
        } failure:^(NSError *error) {
            
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)unreadCountWithParam:(UnreadCountParam *)param success:(void(^)(UnreadCountResult *))success failure:(void(^)(NSError *))failure{
    NSDictionary *params = param.keyValues;
    [HttpTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params success:^(id responseObj) {
        if(success){
            UnreadCountResult *result = [UnreadCountResult objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

@end
