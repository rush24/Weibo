//
//  EmotionTool.h
//  微博
//
//  Created by 张智勇 on 16/2/6.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Emotion;

@interface EmotionTool : NSObject

/**
 *  得到默认表情
 *
 *  @return 默认表情数组
 */
+ (NSArray *)defaultEmotions;

/**
 *  得到emoji表情
 *
 *  @return emoji表情数组
 */
+ (NSArray *)emojiEmotions;

/**
 *  得到浪小花表情
 *
 *  @return 浪小花表情数组
 */
+ (NSArray *)lxhEmotions;

/**
 *  得到最近表情
 *
 *  @return 最近表情数组
 */
+ (NSArray *)recentEmotions;

/**
 *  添加最近表情
 */
+ (void)addRecentEmotion:(Emotion *)emotion;

/**
 *  通过描述得到对应表情
 *
 *  @param desc
 *
 *  @return
 */
+ (Emotion *)emotionWithDesc:(NSString *)desc;
@end
