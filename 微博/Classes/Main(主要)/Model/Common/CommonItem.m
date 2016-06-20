//
//  CommonItem.m
//  微博
//
//  Created by 张智勇 on 16/2/17.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "CommonItem.h"

@implementation CommonItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon{
    CommonItem *commonItem = [[CommonItem alloc]init];
    commonItem.title = title;
    commonItem.icon = icon;
    
    return commonItem;
}

+ (instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithTitle:title icon:nil];
}

@end
