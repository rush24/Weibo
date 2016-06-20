//
//  Status.m
//  微博
//
//  Created by 张智勇 on 15/12/6.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "Status.h"
#import "MJExtension.h"
#import "Photo.h"
#import "NSDate+MJ.h"
#import "RegexResult.h"
#import "RegexKitLite.h"
#import "EmotionAttachment.h"
#import "EmotionTool.h"

@implementation Status

- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [Photo class]};
}

/**
 *  重写create_at Get方法
 *
 *  @return
 */
- (NSString *)created_at{
    //Mon Jan 04 15:08:06 +0800 2016
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];//不加这句createDate为空
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //获得发布的具体时间
    NSDate *createDate = [fmt dateFromString:_created_at];
    // 判断是否为今年
    if (createDate.isThisYear) {
        if (createDate.isToday) { // 今天
            NSDateComponents *cmps = [createDate deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        } else if (createDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else { // 至少是前天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];
    }
}

- (void)setSource:(NSString *)source{
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"</"].location - range.location;
    if(source.length > 0){//如果有来源
        NSString *subString = [source substringWithRange:range];
        _source = [NSString stringWithFormat:@"来自%@",subString];
    }else{//隐藏来源，新浪服务器返回为空，我们显示空字符串
        _source = @"";
    }
}

- (void)setRetweeted_status:(Status *)retweeted_status{
    _retweeted_status = retweeted_status;
    
    self.retweeted = NO;//自己是原创微博，不是转发微博
    retweeted_status.retweeted = YES;

}

- (void)setText:(NSString *)text{
    _text = [text copy];
    
    [self creatAttributedText];
}

- (void)setUser:(User *)user{
    _user = user;
    
    [self creatAttributedText];
}

- (void)setRetweeted:(BOOL)retweeted{
    _retweeted = retweeted;
  
    [self creatAttributedText];
}

/**
 *  拼接设置富文本
 */
- (void)creatAttributedText{
    if (self.text == nil || self.user == nil) return;//字典赋值有先后顺序，防止有属性还没赋值，故在为text,user,retweeted赋值时都调用此方法
    
    if (self.retweeted) {
        NSString *totalText = [NSString stringWithFormat:@"@%@ : %@", self.user.name, self.text];
        NSAttributedString *attributedString = [self attributedStringWithText:totalText];
        self.attributeText = attributedString;
    } else {
        self.attributeText = [self attributedStringWithText:self.text];
    }
}

/**
 *  通过传进的字符串拼接出富文本字符串
 *
 *  @param 普通文本字符串
 *
 *  @return 富文本字符串
 */
-(NSAttributedString *)attributedStringWithText:(NSString *)text{
    //匹配字符串
    NSArray *regexResults = [self regexResultWithText:text];
    
    //根据匹配结果，拼接对应的表情图片和普通文本
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc]init];
    
    //遍历
    [regexResults enumerateObjectsUsingBlock:^(RegexResult *regexResult, NSUInteger idx, BOOL *stop) {
        Emotion *emotion = nil;
        
        if(regexResult.isEmotion){//如果匹配出为表情字符串
            emotion = [EmotionTool emotionWithDesc:regexResult.string];
        }
        
        if(emotion){//如果存在这个表情
            //创建表情附件
            EmotionAttachment *attach = [[EmotionAttachment alloc]init];
            attach.bounds = CGRectMake(0, -3, StatusOrginalTextFont.lineHeight, StatusOrginalTextFont.lineHeight);
            //传递表情
            attach.emotion = [EmotionTool emotionWithDesc:regexResult.string];
            //将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributeText appendAttributedString:attachString];
        }else{//非表情
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc]initWithString:regexResult.string];
            // 匹配#话题#
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [regexResult.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:StatusHighTextColor range:*capturedRanges];
                [substr addAttribute:LinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-]+ ?";
            [regexResult.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:StatusHighTextColor range:*capturedRanges];
                [substr addAttribute:LinkText value:*capturedStrings range:*capturedRanges];

            }];
            
            // 匹配超链接
            NSString *httpRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [regexResult.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:StatusHighTextColor range:*capturedRanges];
                [substr addAttribute:LinkText value:*capturedStrings range:*capturedRanges];

            }];
            
            [attributeText appendAttributedString:substr];
        }
    }];
    
    // 设置字体
    [attributeText addAttribute:NSFontAttributeName value:StatusOrginalTextFont range:NSMakeRange(0, attributeText.length)];
    
    return attributeText;
}

/**
 *  根据字符串计算匹配后的结果（排好序的）
 *
 *  @param text
 *
 *  @return
 */
- (NSArray *)regexResultWithText:(NSString *)text{
    //用来存放匹配的结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
    //匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        RegexResult *regexResult = [[RegexResult alloc]init];
        regexResult.string = *capturedStrings;
        regexResult.range = *capturedRanges;
        regexResult.emotion = YES;
        [regexResults addObject:regexResult];
    }];
    
    //匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        RegexResult *regexResult = [[RegexResult alloc]init];
        regexResult.string = *capturedStrings;
        regexResult.range = *capturedRanges;
        regexResult.emotion = NO;
        [regexResults addObject:regexResult];
    }];
    
    //排序
    [regexResults sortUsingComparator:^NSComparisonResult(RegexResult *regexResult1, RegexResult *regexResult2) {
        
        int loc1 = regexResult1.range.location;
        int loc2 = regexResult2.range.location;
        
        return [@(loc1) compare:@(loc2)];
    }];
    
    return regexResults;
}

@end
