//
//  Emotion.m
//  微博
//
//  Created by 张智勇 on 16/1/18.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "Emotion.h"
#import "NSString+Emoji.h"

@implementation Emotion

- (void)setCode:(NSString *)code
{
    if(code == nil) return;
    _code = [code copy];
    
    self.emoji = [NSString emojiWithStringCode:code];
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.chs = [decoder decodeObjectForKey:@"chs"];
        self.cht = [decoder decodeObjectForKey:@"cht"];
        self.png = [decoder decodeObjectForKey:@"png"];
        self.code = [decoder decodeObjectForKey:@"code"];
        self.directory = [decoder decodeObjectForKey:@"directory"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.chs forKey:@"chs"];
    [encoder encodeObject:self.chs forKey:@"cht"];
    [encoder encodeObject:self.png forKey:@"png"];
    [encoder encodeObject:self.code forKey:@"code"];
    [encoder encodeObject:self.directory forKey:@"directory"];
}

/**
 *  重写isEqual方法（比较是否为同一个表情）
 *
 *  @param emotion 作比较的表情对象
 *
 *  @return 是否为相同
 */
- (BOOL)isEqual:(Emotion *)emotion{
    if(self.code){
        return [self.code isEqualToString:emotion.code];
    }else{
        return [self.png isEqualToString:emotion.png] && [self.chs isEqualToString:emotion.chs] && [self.cht isEqualToString:emotion.cht];
    }
}

@end
