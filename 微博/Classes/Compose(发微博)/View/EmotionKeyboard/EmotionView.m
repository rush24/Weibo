//
//  EmotionView.m
//  微博
//
//  Created by 张智勇 on 16/1/29.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "EmotionView.h"
#import "Emotion.h"

@implementation EmotionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;

    }
    return self;
}

- (void)setEmotion:(Emotion *)emotion{
    _emotion = emotion;
    
    if(emotion.code){
        // 取消动画效果
        [UIView setAnimationsEnabled:NO];
        
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        
        // 再次开启动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView setAnimationsEnabled:YES];
        });
        
    }else{
        NSString *icon = [NSString stringWithFormat:@"%@/%@",emotion.directory,emotion.png];
        UIImage *image = [UIImage imageWithName:icon];
        if(iOS7){
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
            
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        
    }
}

@end
