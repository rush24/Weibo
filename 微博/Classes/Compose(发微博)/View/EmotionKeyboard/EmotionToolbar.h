//
//  EmotionToolbar.h
//  微博
//
//  Created by 张智勇 on 16/1/18.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmotionToolbar;

typedef enum{
    EmotionTypeRecent,//最近
    EmotionTypeDefault,//默认
    EmotionTypeEmoji,//Emoji
    EmotionTypeLxh//浪小花
}EmotionType;


@protocol EmotionToolbarDelegate <NSObject>

@optional

- (void)emotionToolbar:(EmotionToolbar *)toolbar didSelectedButton:(EmotionType)emotionType;

@end

@interface EmotionToolbar : UIView
@property(nonatomic,weak) id<EmotionToolbarDelegate> delegate;
@end
