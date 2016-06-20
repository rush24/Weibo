//
//  StatusOriginalFrame.h
//  微博
//
//  Created by 张智勇 on 15/12/31.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Status;

@interface StatusOriginalFrame : NSObject

@property(nonatomic,strong) Status *status;

/** 头像 */
@property (nonatomic, assign) CGRect iconFrame;
/** 昵称 */
@property (nonatomic, assign) CGRect nameFrame;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipFrame;
/** 正文 */
@property (nonatomic, assign) CGRect textFrame;
/** 来源 */
@property (nonatomic, assign) CGRect sourceFrame;
/** 时间 */
@property (nonatomic, assign) CGRect timeFrame;
/** 相册 */
@property (nonatomic, assign) CGRect photosViewFrame;
/** 自己 */
@property (nonatomic, assign) CGRect frame;

@end
