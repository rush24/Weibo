//
//  UnreadCountResult.m
//  微博
//
//  Created by 张智勇 on 15/12/29.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "UnreadCountResult.h"

@implementation UnreadCountResult

- (int)messageCount{
    return self.cmt + self.dm + self.mention_cmt + self.mention_status;
}

- (int)totalCount{
    return self.messageCount + self.status + self.follower;
}

@end
