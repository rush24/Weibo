//
//  StatusDetailView.m
//  微博
//
//  Created by 张智勇 on 15/12/30.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "StatusDetailView.h"
#import "StatusOriginView.h"
#import "StatusRetweetdView.h"
#import "StatusDetailFrame.h"

@interface StatusDetailView()

@property(nonatomic,weak) StatusOriginView *originView;
@property(nonatomic,weak) StatusRetweetdView *retweetdView;

@end

@implementation StatusDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置控件可交互（点击）
        self.userInteractionEnabled = YES;
        
        self.image = [UIImage resizedImage:@"timeline_card_top_background"];
        //添加原创微博
        [self setOriginView];
        //添加转发微博
        [self setRetweetdView];
    }
    return self;
}

/**
 *  添加原创微博
 */
- (void)setOriginView{
    StatusOriginView *originView = [[StatusOriginView alloc]init];
    [self addSubview:originView];
    self.originView = originView;
}

/**
 *  添加转发微博
 */
- (void)setRetweetdView{
    StatusRetweetdView *retweetdView = [[StatusRetweetdView alloc]init];
    [self addSubview:retweetdView];
    self.retweetdView = retweetdView;
}

- (void)setDetailFrame:(StatusDetailFrame *)detailFrame{
    
    _detailFrame = detailFrame;
    
    //给自己frame赋值
    self.frame = detailFrame.frame;
    
    //原创微博frame数据
    self.originView.originalFrame = detailFrame.originalFrame;
    //转发微博frame数据
    self.retweetdView.retweetedFrame = detailFrame.retweetedFrame;
}

@end

