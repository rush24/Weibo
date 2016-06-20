//
//  EmotionGridView.m
//  微博
//
//  Created by 张智勇 on 16/1/24.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "EmotionGridView.h"
#import "Emotion.h"
#import "EmotionView.h"
#import "EmotionPopView.h"
#import "EmotionTool.h"

@interface EmotionGridView()

@property(nonatomic,weak) UIButton *deleteButton;
@property(nonatomic,strong) NSMutableArray *emotionViews;
@property(nonatomic,strong) EmotionPopView *emotionPopView;

@end

@implementation EmotionGridView

- (NSMutableArray *)emotionViews{
    if(!_emotionViews){
        self.emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

- (EmotionPopView *)emotionPopView{
    if(!_emotionPopView){
        self.emotionPopView = [EmotionPopView popView];
    }
    return _emotionPopView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添删除按钮
        UIButton *deleteButton = [[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageWithName:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageWithName:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteEmotion) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        //给自己添加一个长按手势识别器
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]init];
        [recognizer addTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    //添加新表情
    int count = emotions.count;
    int currentEmotionViewCount = self.emotionViews.count;
    
    for(int i = 0;i < count;i++){
        
        EmotionView *emotionView = nil;
        if(i >= currentEmotionViewCount){//emotionView不够用
            emotionView = [[EmotionView alloc]init];
            //添加表情单击事件
            [emotionView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:emotionView];
            //加进数组供布局时遍历
            [self.emotionViews addObject:emotionView];
        }else{
            emotionView = self.emotionViews[i];
        }
        
        //传递模型数据
        emotionView.emotion = emotions[i];
        
        emotionView.hidden = NO;
    }
    
    //隐藏后面的不需要用到的emotionView
    for(int i = count;i < currentEmotionViewCount;i++){
        EmotionView *emotionView = self.emotionViews[i];
        emotionView.hidden = YES;
    }
}

/**
 *  表情单击事件
 *
 *  @param emotionView
 */
- (void)emotionClick:(EmotionView *)emotionView{
    [self.emotionPopView showFromEmotionView:emotionView];
    //延迟0.25秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.emotionPopView dismiss];
        
        //选中表情
        [self selectedEmotion:emotionView.emotion];
    });
    
}

/**
 *  表情长按事件
 *
 *  @param recognizer
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    //捕获触摸点
    CGPoint point = [recognizer locationInView:recognizer.view];
    //检测触摸点落在哪个表情上
    EmotionView *emotionView = [self emotionViewWithPoint:point];
    if(recognizer.state == UIGestureRecognizerStateEnded){//手松开了
        //移除表情弹出控件
        [self.emotionPopView dismiss];
        //选中表情
        [self selectedEmotion:emotionView.emotion];
    }else{//手没有松开
        //显示表情弹出控件
        [self.emotionPopView showFromEmotionView:emotionView];
    }
}

/**
 *  根据触摸点返回对应的表情控件
 *
 *  @param point 触摸点
 *
 *  @return 触摸点所在的表情控件
 */
- (EmotionView *)emotionViewWithPoint:(CGPoint)point{
    EmotionView *touchedEmotionView = nil;
    for (EmotionView *emotionView in self.emotionViews) {
        if(CGRectContainsPoint(emotionView.frame, point) && emotionView.hidden == NO){
            touchedEmotionView = emotionView;
            break;
        }
    }
    return touchedEmotionView;
}

/**
 *  选中表情
 *
 *  @param emotion 表情
 */
- (void)selectedEmotion:(Emotion *)emotion{
    if(emotion == nil)  return;
    
    //保存使用记录
    [EmotionTool addRecentEmotion:emotion];
    
    //发出一个选中表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:EmotionDidSelectedNotification object:nil userInfo:@{SelectedEmotion:emotion}];
}

/**
 *  删除表情
 */
- (void)deleteEmotion{
    //发出一个删除表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:EmotionDidDeletedNotification object:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat leftInset = 15;
    CGFloat topInset = 15;
    
    //排列表情
    int count = self.emotionViews.count;
    CGFloat emotionViewW = (self.width - 2 * leftInset) / EmotionMaxCols;
    CGFloat emotionViewH = (self.height - topInset) / EmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *emotionView = self.emotionViews[i];
        emotionView.x = leftInset + (i % EmotionMaxCols) * emotionViewW;
        emotionView.y = topInset + (i / EmotionMaxCols) * emotionViewH;
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
    }
    
    //删除按钮
    self.deleteButton.width = emotionViewW;
    self.deleteButton.height = emotionViewH;
    self.deleteButton.x = self.width - leftInset - self.deleteButton.width;
    self.deleteButton.y = self.height - self.deleteButton.height;
}

@end
