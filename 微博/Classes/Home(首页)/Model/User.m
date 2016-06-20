//
//  User.m
//  微博
//
//  Created by 张智勇 on 15/12/6.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "User.h"

@implementation User

- (BOOL)isVip{
    return self.mbtype > 2;
}

@end
