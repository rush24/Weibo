//
//  EmotionPopView.h
//  微博
//
//  Created by 张智勇 on 16/1/30.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmotionView;
@interface EmotionPopView : UIView

+ (instancetype)popView;

/**
 *  显示popView
 *
 *  @param emotionView 显示哪个表情的popView
 */
- (void)showFromEmotionView:(EmotionView *)fromEmotionView;

/**
 *  删除popView
 */
- (void)dismiss;
@end
