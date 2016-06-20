//
//  PopMenu.h
//  微博
//
//  Created by 张智勇 on 15/9/10.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    PopMenuArrowPositionCenter = 0,
    PopMenuArrowPositionLeft = 1,
    PopMenuArrowPositionRight = 2
} PopMenuArrowPosition;
@class PopMenu;

@protocol PopMenuDelegate <NSObject>

@optional
- (void)popMenuDidDismissed:(PopMenu *)popMenu;

@end


@interface PopMenu : UIView

@property (nonatomic, weak) id<PopMenuDelegate> delegate;

@property (nonatomic, assign, getter = isDimBackground) BOOL dimBackground;

@property (nonatomic, assign) PopMenuArrowPosition arrowPosition;

/**
 *  初始化方法
 */
- (instancetype)initWithContentView:(UIView *)contentView;
+ (instancetype)popMenuWithContentView:(UIView *)contentView;

/**
 *  显示菜单
 */
- (void)showInRect:(CGRect)rect;


/**
 *  关闭菜单
 */
- (void)dismiss;

/**
 *  设置菜单的背景图片
 */
- (void)setBackground:(UIImage *)background;

@end
