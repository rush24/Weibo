//
//  StatusPhotoView.m
//  微博
//
//  Created by 张智勇 on 16/1/6.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "StatusPhotoView.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"

@interface StatusPhotoView()

@property(nonatomic,weak) UIImageView *gifView;

@end

@implementation StatusPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置控件可交互（点击）
        self.userInteractionEnabled = YES;
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        //添加gif图标
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return self;
}

- (void)setPhoto:(Photo *)photo{
    _photo = photo;
    
    //下载图片
    [self setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
    
    //设置gif图标显示和位置
    self.gifView.hidden = ![photo.thumbnail_pic.pathExtension isEqualToString:@"gif"];
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

@end
