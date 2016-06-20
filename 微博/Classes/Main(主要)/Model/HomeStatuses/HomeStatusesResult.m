//
//  HomeStatusesResult.m
//  微博
//
//  Created by 张智勇 on 15/12/16.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "HomeStatusesResult.h"
#import "Status.h"

@implementation HomeStatusesResult


- (NSDictionary *)objectClassInArray
{
    return @{@"statuses" : [Status class]};
}
@end
