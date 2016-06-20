//
//  ComposePhotosView.m
//  微博
//
//  Created by 张智勇 on 15/12/13.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "ComposePhotosView.h"

@implementation ComposePhotosView

/**
 *  添加一张图片
 *
 *  @param image 
 */
- (void)addImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    [self addSubview:imageView];
}

- (NSArray *)images{
    NSMutableArray *array = [NSMutableArray array];
    for(UIImageView *imageView in self.subviews){
        [array addObject:imageView.image];
    }
    return array;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int count = self.subviews.count;
    int maxColPerRow = 4;
    CGFloat margin = 10;
    CGFloat imageViewW = (self.width - (maxColPerRow+1)*margin)/maxColPerRow;
    CGFloat imageViewH = imageViewW;
    
    for(int i = 0;i < count;i++){
        int row = i / maxColPerRow;
        int col = i % maxColPerRow;
        UIImageView * imageView = self.subviews[i];
        imageView.width = imageViewW;
        imageView.height = imageViewH;
        imageView.x = col * (imageViewW + margin) + margin;
        imageView.y = row * (imageViewH + margin);
    }
}

@end
