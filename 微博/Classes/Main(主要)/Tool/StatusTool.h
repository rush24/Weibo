//
//  StatusTool.h
//  微博
//
//  Created by 张智勇 on 15/12/16.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeStatusesParam.h"
#import "HomeStatusesResult.h"
#import "SendStatusParam.h"
#import "SendStatusResult.h"


@interface StatusTool : NSObject

/**
 *  加载首页的微博数据
 *
 *  @param param
 *  @param success
 *  @param failure
 */
+ (void)homeStatusesWithParam:(HomeStatusesParam *)param success:(void(^)(HomeStatusesResult *))success failure:(void(^)(NSError *))failure;

/**
 *  发送没有图片微博数据
 *
 *  @param param
 *  @param success
 *  @param failure
 */
+ (void)sendStatusesWithParam:(SendStatusParam *)param success:(void(^)(SendStatusResult *))success failure:(void(^)(NSError *))failure;

@end
