//
//  CommonItem.h
//  微博
//
//  Created by 张智勇 on 16/2/17.
//  Copyright © 2016年 张智勇. All rights reserved.
//  用一个CommonItem模型来描述每行的信息：图标、标题、子标题、右边的样式（箭头、文字、数字、开关、打钩）

#import <Foundation/Foundation.h>

@interface CommonItem : NSObject

/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title;

@end
