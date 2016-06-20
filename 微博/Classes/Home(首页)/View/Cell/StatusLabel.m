//
//  StatusLabel.m
//  微博
//
//  Created by 张智勇 on 16/2/17.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "StatusLabel.h"
#import "StatusLink.h"
#define LinkHighlightTag 10 //数字随意

@interface StatusLabel()

@property(nonatomic,weak) UITextView *textView;
@property(nonatomic,strong) NSMutableArray *links;

@end

@implementation StatusLabel

- (NSMutableArray *)links{
    if(!_links){
        NSMutableArray *links = [NSMutableArray array];//这里之所以要先定义数组的原因是：如果不定义，直接用_links addObject是不行的，由于_本身用懒加载没有初始化，无法添加元素。
        //遍历attributedText里每段富文本
        [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            NSString *linkText = attrs[LinkText];//从字典里取出有含特殊标记（LinkText）的链接文本
            if(linkText == nil) return;
            
            //创建一个链接
            StatusLink *link = [[StatusLink alloc]init];
            link.text = linkText;
            link.range = range;
            
            NSMutableArray *rects = [NSMutableArray array];
            //设置选中字符的范围
            self.textView.selectedRange = range;
            //算出选中字符范围的边框
            NSArray *selectedRects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
            for(UITextSelectionRect *selectedRect in selectedRects){
                if(selectedRect.rect.size.width == 0 || selectedRect.rect.size.height == 0) continue;
                [rects addObject:selectedRect];
            }
            link.rects = rects;
            [links addObject:link];
        
        }];
        _links = links;
    }
    
    return _links;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITextView *textView = [[UITextView alloc]init];
        textView.editable = NO;//不能编辑
        textView.scrollEnabled = NO;//不能滚动
        textView.userInteractionEnabled = NO;//不能交互
        //设置文字的内边距
        textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        textView.backgroundColor = [UIColor clearColor];
        [self addSubview:textView];
        self.textView = textView;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textView.frame = self.bounds;
}

#pragma mark - 公共接口
- (void)setAttributedText:(NSAttributedString *)attributedText{
    _attributedText = attributedText;
    
    self.textView.attributedText = attributedText;
    self.links = nil;//清空链接
}

#pragma mark - 事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    //得到被点击的链接
    StatusLink *touchingLink = [self touchingLinkWithPoint:point];
    //链接高亮
    [self showLinkHighlight:touchingLink];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    //得到被点击的链接
    StatusLink *touchingLink = [self touchingLinkWithPoint:point];
    if(touchingLink){//说明手指在某个链接上抬起，发出点击链接通知
        [[NSNotificationCenter defaultCenter] postNotificationName:StatusLinkDidSelectedNotification object:nil userInfo:@{LinkText:touchingLink.text}];
    }
    //否则相当于触摸被取消
    [self touchesCancelled:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeLinkHighlight];//移除高亮
    });
}

/**
 *  根据触摸点返回触摸的链接
 *
 *  @param point 触摸点
 *
 *  @return 触摸的链接
 */
- (StatusLink *)touchingLinkWithPoint:(CGPoint)point{
    __block StatusLink *touchingLink = nil;
    [self.links enumerateObjectsUsingBlock:^(StatusLink *link, NSUInteger idx, BOOL *stop) {
        for (UITextSelectionRect *selectedrect in link.rects) {
            if(CGRectContainsPoint(selectedrect.rect, point)){
                touchingLink = link;
                break;
            }
        }
    }];
    
    return touchingLink;
}

/**
 *  链接高亮
 *
 *  @param link
 */
- (void)showLinkHighlight:(StatusLink *)link{
    for(UITextSelectionRect *selectedRect in link.rects){
        UIView *bg = [[UIView alloc]init];
        bg.tag = LinkHighlightTag;//作标记以便准确消除
        bg.layer.cornerRadius = 3;//圆角
        bg.frame = selectedRect.rect;
        bg.backgroundColor = WeiboColor(177, 215, 252);
        [self insertSubview:bg atIndex:0];
    }
}

/**
 *  移除链接高亮
 */
- (void)removeLinkHighlight{
    for(UIView *child in self.subviews){
        if(child.tag == LinkHighlightTag){
            [child removeFromSuperview];
        }
    }
}

@end


