//
//  EmotionTextView.h
//  微博
//
//  Created by 张智勇 on 16/2/8.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "TextView.h"
@class Emotion;

@interface EmotionTextView : TextView

- (void)appendEmotion:(Emotion *)emotion;

- (NSString *)realText;
@end
