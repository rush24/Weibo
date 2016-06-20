//
//  EmtionAttachment.h
//  微博
//
//  Created by 张智勇 on 16/2/12.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;
@interface EmotionAttachment : NSTextAttachment
@property(nonatomic,strong) Emotion *emotion;
@end
