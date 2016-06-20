//
//  StatusPhotosView.h
//  微博
//
//  Created by 张智勇 on 16/1/6.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusPhotosView : UIView

//图片数据
@property(nonatomic,strong) NSArray *pic_urls;

/**
 *  根据图片个数计算相册的最终尺寸
 *
 *  @param photosCount
 *
 *  @return 
 */
+ (CGSize)sizeWithPhotosCount:(int)photosCount;

@end
