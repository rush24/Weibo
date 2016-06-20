//
//  UnreadCountParam.h
//  微博
//
//  Created by 张智勇 on 15/12/29.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "BaseParam.h"

@interface UnreadCountParam : BaseParam


/** false	int64	需要查询的用户ID。*/
@property (nonatomic, copy) NSString *uid;

@end
