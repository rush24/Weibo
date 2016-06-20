//
//  UserTool.h
//  微博
//
//  Created by 张智勇 on 15/12/27.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoParam.h"
#import "UserInfoResult.h"
#import "UnreadCountParam.h"
#import "UnreadCountResult.h"

@interface UserTool : NSObject

/**
 *  加载用户的个人信息
 *
 *  @param param
 *  @param success
 *  @param failure
 */
+ (void)userInfoWithParam:(UserInfoParam *)param success:(void(^)(UserInfoResult *))success failure:(void(^)(NSError *))failure;

/**
 *  加载微博未读数
 *
 *  @param param
 *  @param success
 *  @param failure
 */
+ (void)unreadCountWithParam:(UnreadCountParam *)param success:(void(^)(UnreadCountResult *))success failure:(void(^)(NSError *))failure;

@end
