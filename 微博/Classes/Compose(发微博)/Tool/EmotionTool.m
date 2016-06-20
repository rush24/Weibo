//
//  EmotionTool.m
//  微博
//
//  Created by 张智勇 on 16/2/6.
//  Copyright © 2016年 张智勇. All rights reserved.
//  表情工具类：存储、加载表情数据

#define RecentFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentEmotions.data"]

#import "EmotionTool.h"
#import "MJExtension.h"
#import "Emotion.h"

/** 默认表情 */
static NSArray *_defaultEmotions;
/** emoji表情 */
static NSArray *_emojiEmotions;
/** 浪小花表情 */
static NSArray *_lxhEmotions;
/** 最近表情 */
static NSMutableArray *_recentEmotions;


@implementation EmotionTool

+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaultEmotions = [Emotion objectArrayWithFile:plist];
        //为每个表情对象设置directory属性
        [_defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default"];
    }
    return _defaultEmotions;
}

+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions = [Emotion objectArrayWithFile:plist];
        //为每个表情对象设置directory属性
        [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/emoji"];
    }
    return _emojiEmotions;
}

+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [Emotion objectArrayWithFile:plist];
        //为每个表情对象设置directory属性
        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh"];
    }
    return _lxhEmotions;
}

+ (NSArray *)recentEmotions
{
    if(!_recentEmotions){
        //去沙盒加载最近使用的表情数据
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:RecentFilepath];
        if(!_recentEmotions){//沙盒中没有任何数据
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

+ (void)addRecentEmotion:(Emotion *)emotion{
    //加载最近的表情数据(防止外部没有先调用加载最近表情数据，导致_recentEmotions为空)
    [self recentEmotions];
    
    //删除之前存在的重复表情
    [_recentEmotions removeObject:emotion];
    
    //添加最新表情
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //存储到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:RecentFilepath];
}

+ (Emotion *)emotionWithDesc:(NSString *)desc{
    if(!desc)   return nil;
    __block Emotion *foundEmotion = nil;
    
    //从默认表情里面找
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(Emotion *emotion, NSUInteger idx, BOOL *stop) {
        if([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]){
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    if(foundEmotion)    return foundEmotion;
    
    //从浪小花表情中找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(Emotion *emotion, NSUInteger idx, BOOL *stop) {
        if([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]){
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}


@end
