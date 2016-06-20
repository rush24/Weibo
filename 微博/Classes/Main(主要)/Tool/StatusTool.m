//
//  StatusTool.m
//  微博
//
//  Created by 张智勇 on 15/12/16.
//  Copyright © 2015年 张智勇. All rights reserved.
//
#import "StatusTool.h"
#import "HomeStatusesParam.h"
#import "HomeStatusesResult.h"
#import "MJExtension.h"
#import "HttpTool.h"

@implementation StatusTool


+ (void)homeStatusesWithParam:(HomeStatusesParam *)param success:(void(^)(HomeStatusesResult *))success failure:(void(^)(NSError *))failure{
    NSDictionary *params = param.keyValues;
    [HttpTool get:@"https://api.weibo.com/2/statuses/home_timeline.json" params:params success:^(id responseObj) {
        if(success){
            HomeStatusesResult *result = [HomeStatusesResult objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)sendStatusesWithParam:(SendStatusParam *)param success:(void(^)(SendStatusResult *))success failure:(void(^)(NSError *))failure{
    NSDictionary *params = param.keyValues;
    [HttpTool post:@"https://api.weibo.com/2/statuses/update.json" params:params success:^(id responseObj) {
        if(success){
            SendStatusResult *result = [SendStatusResult objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

@end
