//
//  Account.m
//  微博
//
//  Created by 张智勇 on 15/12/5.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "Account.h"

@implementation Account

/**
 *  重写setExpires_in方法来为expires_time设值
 *  （由于expires_time并不是服务器返回的属性，所以MJExtension框架无法为其进行KeyValue赋值，所以要自己手动赋值）
 *  @param expires_in
 */
- (void)setExpires_in:(NSString *)expires_in{
    _expires_in = [expires_in copy];
    
    //确定过期时间
    NSDate *now = [NSDate date];
    self.expires_time = [now dateByAddingTimeInterval:expires_in.doubleValue];
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.expires_time = [decoder decodeObjectForKey:@"expires_time"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.expires_time forKey:@"expires_time"];
    [encoder encodeObject:self.name forKey:@"name"];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"【[access_token:%@],[expires_in:%@],[expires_time:%@],[uid:%@],[name:%@]】",_access_token,_expires_in,_expires_time,_uid,_name];
}

@end
