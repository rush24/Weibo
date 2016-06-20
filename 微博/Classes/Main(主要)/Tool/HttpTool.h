//
//  HttpTool.h
//  微博
//
//  Created by 张智勇 on 15/12/16.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpTool : NSObject

+ (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))setReachabilityStatusChangeBlock;

/**
 *  发送get请求
 *
 *  @param url
 *  @param params
 *  @param success
 *  @param failure
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param url
 *  @param params
 *  @param success
 *  @param failure
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 *  发送带有formdata的post请求
 *
 *  @param url
 *  @param params
 *  @param constructingBodyWithBlock
 *  @param success
 *  @param failure
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params
constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData)) constructingBodyWithBlock
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError *error))failure;
@end
