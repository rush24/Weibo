//
//  StatusPhotosView.m
//  微博
//
//  Created by 张智勇 on 16/1/6.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "StatusPhotosView.h"
#import "StatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define StatusPhotosMaxCount 9
#define StatusPhotosMaxCols(photosCount) ((photosCount==4)?2:3)
#define StatusPhotoW 98
#define StatusPhotoH StatusPhotoW
#define StatusPhotoMargin 3

@interface StatusPhotosView()

@property(nonatomic,weak) UIImageView *imageView;
@property(nonatomic,assign) CGRect lastFrame;

@end

@implementation StatusPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置控件可交互（点击）
        self.userInteractionEnabled = YES;
        //预先创建9个图片控件
        for(int i = 0; i < StatusPhotosMaxCount; i++){
            StatusPhotoView *photoView = [[StatusPhotoView alloc]init];
            photoView.tag = i;
            [self addSubview:photoView];
            
            //添加手势监听器
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]init];
            [recognizer addTarget:self action:@selector(tapPhoto:)];
            [photoView addGestureRecognizer:recognizer];
        }
    }
    return self;
}

/**
 *  点击图片
 *
 *  @param recognizer 手势监听器(一个监听器只能监听一个view)
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer{
    
//    //添加一个遮盖
//    UIView *cover = [[UIView alloc]init];
//    cover.frame = [UIScreen mainScreen].bounds;
//    cover.backgroundColor = [UIColor blackColor];
//    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)]];
//    [[UIApplication sharedApplication].keyWindow addSubview:cover];
//    
//    //把图片添加到遮盖上
//    StatusPhotoView *photoView = (StatusPhotoView *)recognizer.view;
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [imageView setImageWithURL:[NSURL URLWithString:photoView.photo.bmiddle_pic] placeholderImage:photoView.image];
//    
//    //更改坐标轴方法，给定一个photoView.frame,让它从以self（photosView）为坐标轴转为以cover为坐标轴
//    imageView.frame = [self convertRect:photoView.frame toView:cover];
//    [cover addSubview:imageView];
//    self.lastFrame = imageView.frame;
//    self.imageView = imageView;
//    
//    //放大
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect frame = imageView.frame;
//        frame.size.width = cover.width;
//        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
//        frame.origin.x = 0;
//        frame.origin.y = (cover.height - frame.size.height) * 0.5;
//        imageView.frame = frame;
//    }];
    
    //创建图片浏览器
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc]init];
    //设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    for(int i = 0;i < self.pic_urls.count;i++){
        Photo *pic = self.pic_urls[i];
        MJPhoto *photo = [[MJPhoto alloc]init];
        //设置图片路径
        photo.url = [NSURL URLWithString:pic.bmiddle_pic];
        //设置图片来源
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    photoBrowser.photos = photos;
    //设置图片默认索引
    photoBrowser.currentPhotoIndex = recognizer.view.tag;
    [photoBrowser show];
    
}

//- (void)tapCover:(UITapGestureRecognizer *)recognizer{
//    [UIView animateWithDuration:0.2 animations:^{
//        
//        recognizer.view.backgroundColor = [UIColor clearColor];
//        self.imageView.frame = self.lastFrame;
//
//    } completion:^(BOOL finished) {
//        [recognizer.view removeFromSuperview];
//    }];
//}

- (void)setPic_urls:(NSArray *)pic_urls{
    _pic_urls = pic_urls;
    
    for (int i = 0; i < StatusPhotosMaxCount; i++) {
        StatusPhotoView *photoView = self.subviews[i];
        if(i < pic_urls.count){//显示
            photoView.photo = pic_urls[i];
            photoView.hidden = NO;
        }else{
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int count = self.pic_urls.count;
    int maxCols = StatusPhotosMaxCols(count);
    
    for (int i = 0; i<count; i++) {
        StatusPhotoView *photoView = self.subviews[i];
        photoView.width = StatusPhotoW;
        photoView.height = StatusPhotoH;
        photoView.x = (i % maxCols) * (StatusPhotoW + StatusPhotoMargin);
        photoView.y = (i / maxCols) * (StatusPhotoH + StatusPhotoMargin);
    }
}

+ (CGSize)sizeWithPhotosCount:(int)photosCount{
    
    // 一行最多几列
    int maxCols = StatusPhotosMaxCols(photosCount);
    
    // 总列数
    int totalCols = photosCount >= maxCols ?  maxCols : photosCount;
    
    // 总行数
    // 知道总个数
    // 知道每一页最多显示多少个
    // 能算出一共能显示多少页
    int totalRows = (photosCount + maxCols - 1) / maxCols;
    
    // 计算尺寸
    CGFloat photosW = totalCols * StatusPhotoW + (totalCols - 1) * StatusPhotoMargin;
    CGFloat photosH = totalRows * StatusPhotoW + (totalRows - 1) * StatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
