//
//  User.h
//  微博
//
//  Created by 张智勇 on 15/12/6.
//  Copyright © 2015年 张智勇. All rights reserved.
//用户模型

#import <Foundation/Foundation.h>

@interface User : NSObject

/** string 	友好显示名称 */
@property (nonatomic, copy) NSString *name;

/** string 	用户头像地址（中图），50×50像素 */
@property (nonatomic, copy) NSString *profile_image_url;

/**会员类型*/
@property(nonatomic,assign) int mbtype;

/**会员等级*/
@property(nonatomic,assign) int mbrank;

/**是否是会员*/
- (BOOL)isVip;
@end
