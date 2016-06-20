//
//  HttpTool.m
//  微博
//
//  Created by 张智勇 on 15/12/16.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@implementation HttpTool

+ (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))setReachabilityStatusChangeBlock{
    // 4.监控网络
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 当网络状态改变了，就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(setReachabilityStatusChangeBlock){
            setReachabilityStatusChangeBlock(status);
        }
    }];
    
    [mgr startMonitoring];
} 

/**
 *  发送get请求
 *
 *  @param url
 *  @param params
 *  @param success
 *  @param failure
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    //获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //发送get请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if(success){
             success(responseObject);
         }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

/**
 *  发送post请求
 *
 *  @param url
 *  @param params
 *  @param success
 *  @param failure
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    //获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //发送post请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

/**
 *  带图片（formdata）post请求
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
     failure:(void (^)(NSError *error))failure{
    
    //获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //发送post请求
    [mgr POST:url parameters:params
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if(constructingBodyWithBlock){
            constructingBodyWithBlock(formData);
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success){
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure){
            failure(error);
        }
    }];
}


@end



