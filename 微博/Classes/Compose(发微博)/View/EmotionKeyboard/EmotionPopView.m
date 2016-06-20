//
//  EmotionPopView.m
//  微博
//
//  Created by 张智勇 on 16/1/30.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "EmotionPopView.h"
#import "EmotionView.h"

@interface EmotionPopView()

@property (weak, nonatomic) IBOutlet EmotionView *emotionView;

@end

@implementation EmotionPopView

+ (instancetype)popView{
    return [[[NSBundle mainBundle] loadNibNamed:@"EmotionPopView" owner:nil options:nil] lastObject];
}


- (void)showFromEmotionView:(EmotionView *)fromEmotionView{
    //传递模型数据
    self.emotionView.emotion = fromEmotionView.emotion;
    
    //添加到窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    //设置位置
    CGFloat centerX = fromEmotionView.centerX;
    CGFloat centerY = fromEmotionView.centerY - self.height * 0.5;
    CGPoint center = CGPointMake(centerX, centerY);
    //坐标系转换
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];
}

- (void)dismiss{
    [self removeFromSuperview];
}


- (void)drawRect:(CGRect)rect {
    [[UIImage imageWithName:@"emoticon_keyboard_magnifier"]drawInRect:rect];
}


@end
