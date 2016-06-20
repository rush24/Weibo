//
//  UIImage+Extension.h
//  微博
//
//  Created by 张智勇 on 15/9/5.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

@end
