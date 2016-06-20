//
//  StatusRetweetdView.m
//  微博
//
//  Created by 张智勇 on 15/12/30.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "StatusRetweetdView.h"
#import "StatusRetweetedFrame.h"
#import "Status.h"
#import "StatusPhotosView.h"
#import "StatusLabel.h"

@interface StatusRetweetdView()

/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 正文 */
@property (nonatomic, weak) StatusLabel *textLabel;
/** 相册 */
@property (nonatomic, weak) StatusPhotosView *photosView;

@end

@implementation StatusRetweetdView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //设置控件可交互（点击）
        self.userInteractionEnabled = YES;
        
        //设置转发区域背景
        self.image = [UIImage resizedImage:@"timeline_retweet_background"];
        
        //正文
        StatusLabel *textLabel = [[StatusLabel alloc]init];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        //相册
        StatusPhotosView *photosView = [[StatusPhotosView alloc]init];
        [self addSubview: photosView];
        self.photosView = photosView;
        
    }
    
    return self;
}

- (void)setRetweetedFrame:(StatusRetweetedFrame *)retweetedFrame{
    
    _retweetedFrame = retweetedFrame;
    
    Status *status = retweetedFrame.status;
    //给自己frame赋值
    self.frame = retweetedFrame.frame;
    
    //正文
    self.textLabel.attributedText = status.retweeted_status.attributeText;
    self.textLabel.frame = retweetedFrame.textFrame;
    
    //相册
    if(status.retweeted_status.pic_urls.count){//有配图
        self.photosView.frame = retweetedFrame.photosViewFrame;
        self.photosView.pic_urls = status.retweeted_status.pic_urls;
        self.photosView.hidden = NO;
    }else{
        self.photosView.hidden = YES;
    }
}

@end
