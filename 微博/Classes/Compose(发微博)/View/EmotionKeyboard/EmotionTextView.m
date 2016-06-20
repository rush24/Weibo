//
//  EmotionTextView.m
//  微博
//
//  Created by 张智勇 on 16/2/8.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "EmotionTextView.h"
#import "Emotion.h"
#import "RegexKitLite.h"
#import "EmotionAttachment.h"

@implementation EmotionTextView

- (void)appendEmotion:(Emotion *)emotion{
    
    if(emotion.emoji){//emoji表情
        [self insertText:emotion.emoji];
    }else{//图片表情
        NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
        
        //创建一个带有图片表情的富文本
        EmotionAttachment *attach = [[EmotionAttachment alloc]init];
        attach.emotion = emotion;
        attach.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        //记录表情的插入位置
        int insertIndex = self.selectedRange.location;
        
        //插入图片到光标位置
        [attributeText insertAttributedString:attachString atIndex:insertIndex];
        
        //设置字体
        [attributeText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributeText.length)];
        
        //重新赋值
        self.attributedText = attributeText;
        
        //让光标回到表情后面的位置
        self.selectedRange = NSMakeRange(insertIndex+1,0);
        
    }
}

- (NSString *)realText{
    //用了拼接所有的文字
    NSMutableString *string = [NSMutableString string];
    
    //遍历富文本里的所有内容
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        EmotionAttachment *attach = attrs[@"NSAttachment"];
        
        if(attach){//是带有附件的富文本
            [string appendString:attach.emotion.chs];
        }else{//普通文本
            NSString *substr = [self.attributedText attributedSubstringFromRange:range].string;
            [string appendString:substr];
        }
    }];
    
    return string;
}


@end
