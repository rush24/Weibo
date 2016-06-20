//
//  CommonGroup.h
//  微博
//
//  Created by 张智勇 on 16/2/17.
//  Copyright © 2016年 张智勇. All rights reserved.
//  用一个CommonGroup模型来描述每组的信息：组头、组尾、这组的所有行模型

#import <Foundation/Foundation.h>

@interface CommonGroup : NSObject

/** 组头 */
@property (nonatomic, copy) NSString *header;
/** 组尾 */
@property (nonatomic, copy) NSString *footer;
/** 这组的所有行模型(数组中存放的都是CommonItem模型) */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)group;

@end
