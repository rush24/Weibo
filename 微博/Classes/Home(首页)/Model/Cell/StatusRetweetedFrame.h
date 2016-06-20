//
//  StatusRetweetedFrame.h
//  微博
//
//  Created by 张智勇 on 15/12/31.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Status;
@interface StatusRetweetedFrame : NSObject

@property(nonatomic,strong) Status *status;

/** 昵称 */
@property (nonatomic, assign) CGRect nameFrame;
/** 正文 */
@property (nonatomic, assign) CGRect textFrame;
/** 相册 */
@property (nonatomic, assign) CGRect photosViewFrame;

/** 自己 */
@property (nonatomic, assign) CGRect frame;

@end
