//
//  PopMenu.m
//  微博
//
//  Created by 张智勇 on 15/9/10.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import "PopMenu.h"

@interface PopMenu()

/**
 *  最底部的遮盖 ：屏蔽除菜单以外控件的事件
 */
@property (nonatomic, weak) UIButton *cover;
/**
 *  容器 ：容纳具体要显示的内容contentView
 */
@property (nonatomic, weak) UIImageView *container;

@property (nonatomic, strong) UIView *contentView;

@end



@implementation PopMenu

//如果cover的frame在其他函数里用self.bounds设置，得到的self不是所运行的机器尺寸，所以必须用layoutSubViews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cover.frame = self.bounds;
}


- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [super init]) {
        self.contentView = contentView;
    }
    return self;
}
//类方法让类直接调用比较方便，但是由于不能用self，所以需要一个初始化方法。
+ (instancetype)popMenuWithContentView:(UIView *)contentView
{
    return [[self alloc] initWithContentView:contentView];
}



- (void)showInRect:(CGRect)rect
{
    
    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor clearColor];
    [cover addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cover];
    self.cover = cover;
    
    // 添加带箭头的菜单图片
    UIImageView *container = [[UIImageView alloc] init];
    container.userInteractionEnabled = YES;
    container.image = [UIImage resizedImage:@"popover_background"];
    container.frame = rect;
    [self addSubview:container];
    self.container = container;
    
    // 设置容器里面内容的frame
    CGFloat topMargin = 12;
    CGFloat leftMargin = 5;
    CGFloat rightMargin = 5;
    CGFloat bottomMargin = 8;
    
    self.contentView.y = topMargin;
    self.contentView.x = leftMargin;
    self.contentView.width = self.container.width - leftMargin - rightMargin;
    self.contentView.height = self.container.height - topMargin - bottomMargin;
    
    [self.container addSubview:self.contentView];
    // 添加菜单整体到窗口身上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    

}

//点击cover区域触发收回菜单
- (void)dismiss
{
    if ([self.delegate respondsToSelector:@selector(popMenuDidDismissed:)]) {
        [self.delegate popMenuDidDismissed:self];
    }
    
    [self removeFromSuperview];
}

- (void)setBackground:(UIImage *)background
{
    self.container.image = background;
}

//没有在头文件声明，外面无法直接调用，但是属性放在头文件，外面可通过直接改属性值来改变参数。
- (void)setArrowPosition:(PopMenuArrowPosition)arrowPosition
{
    _arrowPosition = arrowPosition;
    
    switch (arrowPosition) {
        case PopMenuArrowPositionCenter:
            self.container.image = [UIImage resizedImage:@"popover_background"];
            break;
            
        case PopMenuArrowPositionLeft:
            self.container.image = [UIImage resizedImage:@"popover_background_left"];
            break;
            
        case PopMenuArrowPositionRight:
            self.container.image = [UIImage resizedImage:@"popover_background_right"];
            break;
    }
}


@end










