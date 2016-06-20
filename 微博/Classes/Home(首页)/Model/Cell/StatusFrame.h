//
//  StatusFrame.h
//  微博
//
//  Created by 张智勇 on 15/12/31.
//  Copyright © 2015年 张智勇. All rights reserved.
//  该Frame包含一个cell内部的所有子控件的frame数据和显示数据

#import <Foundation/Foundation.h>

@class Status,StatusDetailFrame;

@interface StatusFrame : NSObject

/**子控件的frame数据*/
@property(nonatomic,strong) StatusDetailFrame *detailFrame;

@property(nonatomic,assign) CGRect toolbarFrame;

/**cell高度*/
@property(nonatomic,assign) CGFloat cellHeight;

@property(nonatomic,strong) Status *status;


@end
