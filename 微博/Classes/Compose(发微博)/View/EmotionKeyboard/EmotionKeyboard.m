//
//  EmotionKeyboard.m
//  微博
//
//  Created by 张智勇 on 16/1/17.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionListView.h"
#import "EmotionToolbar.h"
#import "EmotionTool.h"

@interface EmotionKeyboard()<EmotionToolbarDelegate>

@property(nonatomic,weak) EmotionListView *listView;
@property(nonatomic,weak) EmotionToolbar *toolbar;

@end

@implementation EmotionKeyboard


+ (instancetype)keyboard{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加表情列表
        EmotionListView *listView = [[EmotionListView alloc]init];
        [self addSubview:listView];
        self.listView = listView;
        
        //添加表情工具条
        EmotionToolbar *toolbar = [[EmotionToolbar alloc]init];
        toolbar.delegate = self;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        

    }
    return self;
}

#pragma mark - EmotionToolbarDelegate
- (void)emotionToolbar:(EmotionToolbar *)toolbar didSelectedButton:(EmotionType)emotionType{
    switch (emotionType) {
        case EmotionTypeDefault:// 默认
            self.listView.emotions = [EmotionTool defaultEmotions];
            break;
            
        case EmotionTypeEmoji: // Emoji
            self.listView.emotions = [EmotionTool emojiEmotions];
            break;
            
        case EmotionTypeLxh: // 浪小花
            self.listView.emotions = [EmotionTool lxhEmotions];
            break;
            
        case EmotionTypeRecent: // 最近
            self.listView.emotions = [EmotionTool recentEmotions];
            break;
            
        default:
            break;
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置表情工具条的frame
    self.toolbar.width = self.width;
    self.toolbar.height = 35;
    self.toolbar.y = self.height - self.toolbar.height;
    
    //设置表情列表的frame
    self.listView.width = self.width;
    self.listView.height = self.toolbar.y;

}

@end



