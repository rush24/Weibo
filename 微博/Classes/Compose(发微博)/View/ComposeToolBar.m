//
//  ComposeToolBar.m
//  微博
//
//  Created by 张智勇 on 15/12/8.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "ComposeToolBar.h"

@interface ComposeToolBar()

@property(nonatomic,weak) UIButton *emotionButton;

@end

@implementation ComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"compose_toolbar_background"]];
        
        // 添加所有的子控件
        [self addButtonWithIcon:@"compose_trendbutton_background" highIcon:@"compose_trendbutton_background_highlighted" tag:ComposeToolbarButtonTypeTrend];
        [self addButtonWithIcon:@"compose_camerabutton_background" highIcon:@"compose_camerabutton_background_highlighted" tag:ComposeToolbarButtonTypeCamera];
        [self addButtonWithIcon:@"compose_toolbar_picture" highIcon:@"compose_toolbar_picture_highlighted" tag:ComposeToolbarButtonTypePicture];
        self.emotionButton = [self addButtonWithIcon:@"compose_emoticonbutton_background" highIcon:@"compose_emoticonbutton_background_highlighted" tag:ComposeToolbarButtonTypeEmotion];
        [self addButtonWithIcon:@"compose_mentionbutton_background" highIcon:@"compose_mentionbutton_background_highlighted" tag:ComposeToolbarButtonTypeMention];
    }
    return self;
}

- (void)setShowEmotionButton:(BOOL)showEmotionButton{
    _showEmotionButton = showEmotionButton;
    
    if(showEmotionButton){//显示表情按钮图标
        [self.emotionButton setImage:[UIImage imageWithName:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageWithName:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }else{//显示键盘按钮图标
        [self.emotionButton setImage:[UIImage imageWithName:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageWithName:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
    
}


/**
 *  添加一个按钮
 *
 *  @param icon
 *  @param highIcon
 *  @param tag
 */
- (UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(ComposeToolBarButtonType)tag{
    UIButton *button = [[UIButton alloc]init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    [self addSubview:button];
    
    return button;
}


/**
 *  监听按钮点击
 *
 *  @param button 
 */
- (void)buttonClick:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]){
        [self.delegate composeTool:self didClickedButton:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = self.subviews.count;
    CGFloat buttonW = self.width / count;
    CGFloat buttonH = self.height;
    for (int i = 0; i<count; i++) {
        UIButton *button = self.subviews[i];
        button.y = 0;
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }
}


@end



