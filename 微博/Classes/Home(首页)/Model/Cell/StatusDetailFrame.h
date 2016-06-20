//
//  StatusDetailFrame.h
//  微博
//
//  Created by 张智勇 on 16/1/2.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Status,StatusOriginalFrame,StatusRetweetedFrame;

@interface StatusDetailFrame : NSObject

@property(nonatomic,strong) Status *status;

@property(nonatomic,strong) StatusOriginalFrame *originalFrame;

@property(nonatomic,strong) StatusRetweetedFrame *retweetedFrame;

/**自己*/
@property(nonatomic,assign) CGRect frame;

@end
