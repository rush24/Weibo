//
//  ComposePhotosView.h
//  微博
//
//  Created by 张智勇 on 15/12/13.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposePhotosView : UIView

/**
 *  添加一张图片
 *
 *  @param image <#image description#>
 */
- (void)addImage:(UIImage *)image;

/**
 *  以数组返回图片
 *
 *  @return
 */
- (NSArray *)images;
@end
