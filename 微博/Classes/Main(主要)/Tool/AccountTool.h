//
//  AccountTool.h
//  微博
//
//  Created by 张智勇 on 15/12/5.
//  Copyright © 2015年 张智勇. All rights reserved.
//管理账号

#import <Foundation/Foundation.h>
#import "Account.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "AccessTokenParam.h"

@interface AccountTool : NSObject

/**
 *  存储帐号
 */
+ (void)save:(Account *)account;

/**
 *  读取帐号
 */
+ (Account *)account;

/**
 *  获得accesToken
 *
 *  @param param
 *  @param success
 *  @param failure
 */
+ (void)accessTokeWithParam:(AccessTokenParam *)param success:(void(^)(Account *account))success failure:(void(^)(NSError *))failure;
@end
