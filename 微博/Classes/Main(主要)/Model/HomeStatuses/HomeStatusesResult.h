//
//  HomeStatusesResult.h
//  微博
//
//  Created by 张智勇 on 15/12/16.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeStatusesResult : NSObject

/** 微博数组（装着HMStatus模型） */
@property (nonatomic, strong) NSArray *statuses;

/** 近期的微博总数 */
@property (nonatomic, assign) int total_number;
@end
