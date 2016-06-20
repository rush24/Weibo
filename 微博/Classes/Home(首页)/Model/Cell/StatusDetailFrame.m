//
//  StatusDetailFrame.m
//  微博
//
//  Created by 张智勇 on 16/1/2.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "StatusDetailFrame.h"
#import "Status.h"
#import "StatusOriginalFrame.h"
#import "StatusRetweetedFrame.h"

@implementation StatusDetailFrame

- (void)setStatus:(Status *)status{
    
    _status = status;
    
    //计算原创微博frame
    StatusOriginalFrame *originalFrame = [[StatusOriginalFrame alloc]init];
    originalFrame.status = status;
    self.originalFrame = originalFrame;
    
    //微博高度默认为0
    CGFloat h = 0;
    //计算转发微博frame
    if(status.retweeted_status){//如果有转发微博
        StatusRetweetedFrame *retweetedFrame = [[StatusRetweetedFrame alloc]init];
        retweetedFrame.status = status;
        self.retweetedFrame = retweetedFrame;
            
        //计算转发微博frame的y值
        CGRect f = retweetedFrame.frame;
        f.origin.y = CGRectGetMaxY(originalFrame.frame);
        retweetedFrame.frame = f;
        
        //微博高度等于转发微博高度
        h = CGRectGetMaxY(retweetedFrame.frame);
    }else{
        //否则微博高度等于原创微博高度
        h = CGRectGetMaxY(originalFrame.frame);
    }
    
    //自己的frame
    CGFloat x = 0;
    CGFloat y = StatusCellMargin;
    CGFloat w = ScreenW;
    self.frame = CGRectMake(x, y, w, h);
    
}

@end
