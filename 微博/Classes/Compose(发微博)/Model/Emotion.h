//
//  Emotion.h
//  微博
//
//  Created by 张智勇 on 16/1/18.
//  Copyright © 2016年 张智勇. All rights reserved.
//  表情

#import <UIKit/UIKit.h>

@interface Emotion : NSObject<NSCoding>

/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的文字描述（繁体） */
@property (nonatomic, copy) NSString *cht;
/** 表情的文png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的编码 */
@property (nonatomic, copy) NSString *code;
/** 表情的路径名 */
@property (nonatomic, copy) NSString *directory;
/** emoji表情的字符 */
@property (nonatomic, copy) NSString *emoji;

@end
