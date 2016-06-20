//
//  EmotionToolbar.m
//  微博
//
//  Created by 张智勇 on 16/1/18.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "EmotionToolbar.h"

#define EmotionToolbarButtonMaxCount 4

@interface EmotionToolbar()

@property(nonatomic,weak) UIButton *selectedButton;

@end
@implementation EmotionToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加工具条按钮
        [self setButton:@"最近" tag:EmotionTypeRecent];
        [self setButton:@"默认" tag:EmotionTypeDefault];
        [self setButton:@"Emoji" tag:EmotionTypeEmoji];
        [self setButton:@"浪小花" tag:EmotionTypeLxh];
        
        //监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:EmotionDidSelectedNotification object:nil];
        
    }
    return self;
}

/**
 *  添加表情工具条按钮
 *
 *  @param title
 */
- (UIButton *)setButton:(NSString *)title tag:(EmotionType)tag{
    
    UIButton *button = [[UIButton alloc]init];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    int count = self.subviews.count;
    if(count == 1){
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
        
    }else if(count == EmotionToolbarButtonMaxCount){
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
    }else{
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    }
    
    return button;
}

- (void)setDelegate:(id<EmotionToolbarDelegate>)delegate{
    _delegate = delegate;
    
    //一旦设置完代理就默认点击默认按钮（否则由于设置代理在创建toolbar之后，而调用默认点击方法又是在创建时调用，但此时代理为空无法调用）
    UIButton *defaultButton = [self viewWithTag:EmotionTypeDefault];
    [self buttonClick:defaultButton];

}

- (void)buttonClick:(UIButton *)button{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    if([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]){
        [self.delegate emotionToolbar:self didSelectedButton:button.tag];
    }
}

/**
 *  表情选中了
 *
 *  @param note 含有表情对象
 */
- (void)emotionDidSelected:(NSNotification *)note{
    if(self.selectedButton.tag == EmotionTypeRecent){
        [self buttonClick:self.selectedButton];
    }
}

/**
 *  销毁通知（有添加就有销毁）
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置按钮的frame
    CGFloat buttonW = self.width / EmotionToolbarButtonMaxCount;
    CGFloat buttonH = self.height;
    for(int i = 0;i < EmotionToolbarButtonMaxCount;i++){
        UIButton *button = self.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }
}

@end
