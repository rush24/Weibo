//
//  UserInfoParam.h
//  微博
//
//  Created by 张智勇 on 15/12/27.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseParam.h"

@interface UserInfoParam : BaseParam


/** false	int64	需要查询的用户ID。*/
@property (nonatomic, copy) NSString *uid;

@end
