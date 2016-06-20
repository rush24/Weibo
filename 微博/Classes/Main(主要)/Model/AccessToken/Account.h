//
//  Account.h
//  微博
//
//  Created by 张智勇 on 15/12/5.
//  Copyright © 2015年 张智勇. All rights reserved.
//
//账号模型
#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>

//用于调用access_token，接口获取授权后的access token
@property(nonatomic,copy) NSString *access_token;
//access_token的生命周期，单位是秒数
@property(nonatomic,copy) NSString *expires_in;
//过期时间
@property (nonatomic, strong) NSDate *expires_time;
//当前授权用户的UID
@property(nonatomic,copy) NSString *uid;

@property(nonatomic,copy) NSString *name;

@end
