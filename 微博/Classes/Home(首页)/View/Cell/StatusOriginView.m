//
//  StatusOriginView.m
//  微博
//
//  Created by 张智勇 on 15/12/30.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "StatusOriginView.h"
#import "StatusOriginalFrame.h"
#import "Status.h"
#import "UIImageView+WebCache.h"
#import "StatusPhotosView.h"
#import "StatusLabel.h"

@interface StatusOriginView()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipIcon;
/** 正文 */
@property (nonatomic, weak) StatusLabel *textLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 相册 */
@property (nonatomic, weak) StatusPhotosView *photosView;

@end

@implementation StatusOriginView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //设置控件可交互（点击）
        self.userInteractionEnabled = YES;
        
        //头像
        UIImageView *iconView = [[UIImageView alloc]init];
        [self addSubview:iconView];
        self.iconView = iconView;

        //会员图标
        UIImageView *vipIcon = [[UIImageView alloc]init];
        //居中模式，不会因为设置的尺寸拉伸
        vipIcon.contentMode = UIViewContentModeCenter;
        [self addSubview:vipIcon];
        self.vipIcon = vipIcon;
        
        //昵称
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.font = StatusOrginalNameFont;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //来源
        UILabel *sourceLabel = [[UILabel alloc]init];
        sourceLabel.font = StatusOrginalSourceFont;
        sourceLabel.textColor = WeiboColor(129, 129, 129);
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        //时间
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.font = StatusOrginalTimeFont;
        timeLabel.textColor = WeiboColor(127, 13, 129);
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //正文
        StatusLabel *textLabel = [[StatusLabel alloc]init];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        //相册
        StatusPhotosView *photosView = [[StatusPhotosView alloc]init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    
    return self;
}

- (void)setOriginalFrame:(StatusOriginalFrame *)originalFrame{
    _originalFrame = originalFrame;
    
    Status *status = originalFrame.status;
    //给自己设置frame
    self.frame = originalFrame.frame;
    
    //头像
    [self.iconView setImageWithURL:[NSURL URLWithString:status.user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    self.iconView.frame = originalFrame.iconFrame;
    
    //昵称
    self.nameLabel.text = status.user.name;
    self.nameLabel.frame = originalFrame.nameFrame;
    
    if(status.user.isVip){//是会员
        self.nameLabel.textColor = [UIColor orangeColor];
        self.vipIcon.hidden = NO;
        
        [self.vipIcon setImage:[UIImage imageWithName:[NSString stringWithFormat:@"common_icon_membership_level%d",status.user.mbrank]]];
        self.vipIcon.frame = originalFrame.vipFrame;
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipIcon.hidden = YES;
    }
    
    //正文
    self.textLabel.attributedText = status.attributeText;
    self.textLabel.frame = originalFrame.textFrame;
    
    //时间
    self.timeLabel.text = status.created_at;
    //由于需要每次滚动微博保持时间变化，所以需要在此重新设置时间的frame
    CGFloat timeX = self.nameLabel.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + StatusCellInset * 0.3;
    CGSize timeSize = [status.created_at sizeWithFont:StatusOrginalTimeFont];
    self.timeLabel.frame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    
    //来源
    self.sourceLabel.text = status.source;
    //由于时间frame时刻更新，所以来源的frame也要随之更新
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + StatusCellInset;
    CGFloat sourceY = self.timeLabel.frame.origin.y;
    CGSize sourceSize = [status.source sizeWithFont:StatusOrginalSourceFont];
    self.sourceLabel.frame = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    
    //相册
    if(status.pic_urls.count){//有配图
        self.photosView.frame = originalFrame.photosViewFrame;
        self.photosView.pic_urls = status.pic_urls;
        self.photosView.hidden = NO;
    }else{
        self.photosView.hidden = YES;
    }
    
}

@end
