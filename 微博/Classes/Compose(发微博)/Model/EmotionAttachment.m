//
//  EmtionAttachment.m
//  微博
//
//  Created by 张智勇 on 16/2/12.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "EmotionAttachment.h"
#import "Emotion.h"
@implementation EmotionAttachment

- (void)setEmotion:(Emotion *)emotion{
    _emotion = emotion;
    
    self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@/%@",emotion.directory,emotion.png]];
}

@end
