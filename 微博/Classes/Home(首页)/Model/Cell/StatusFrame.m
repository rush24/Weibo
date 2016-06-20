//
//  StatusFrame.m
//  微博
//
//  Created by 张智勇 on 15/12/31.
//  Copyright © 2015年 张智勇. All rights reserved.
//  

#import "StatusFrame.h"
#import "Status.h"
#import "StatusDetailFrame.h"

@implementation StatusFrame

- (void)setStatus:(Status *)status{
    
    _status = status;
    
    //计算微博具体内容
    [self setDetailFrame];
    //计算底部工具条
    [self setToolbarFrame];
    //计算cell高度
    self.cellHeight = CGRectGetMaxY(self.toolbarFrame);
}

/**
 *  计算微博具体内容
 */
- (void)setDetailFrame{
    StatusDetailFrame *detailFrame = [[StatusDetailFrame alloc]init];
    detailFrame.status = self.status;
    self.detailFrame = detailFrame;
}

/**
 *  计算底部工具条
 */
- (void)setToolbarFrame{
    CGFloat toolbarX = 0;
    CGFloat toolbarY = CGRectGetMaxY(self.detailFrame.frame);
    CGFloat toolbarW = ScreenW;
    CGFloat toolbarH = 35;
    self.toolbarFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
}


@end 
