//
//  RegexResult.h
//  微博
//
//  Created by 张智勇 on 16/2/13.
//  Copyright © 2016年 张智勇. All rights reserved.
//  用来封装一个匹配结果

#import <Foundation/Foundation.h>

@interface RegexResult : NSObject

/**
 *  匹配到的字符串
 */
@property(nonatomic,copy) NSString *string;

/**
 *  匹配到的范围
 */
@property(nonatomic,assign) NSRange range;

/**
 *  是否为表情
 */
@property(nonatomic,assign,getter=isEmotion) BOOL emotion;

@end
