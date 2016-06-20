//
//  EmotionListView.m
//  微博
//
//  Created by 张智勇 on 16/1/17.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import "EmotionListView.h"
#import "EmotionGridView.h"

@interface EmotionListView()<UIScrollViewDelegate>

@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UIPageControl *pageControl;

@end

@implementation EmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WeiboColor(244, 244, 244);
        
        //显示所有表情
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview: scrollView];
        self.scrollView = scrollView;
        
        //显示所有页码
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.hidesForSinglePage = YES;
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_selected"] forKey:@"_currentPageImage"];
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_normal"] forKey:@"_pageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    //设置总页数
    int totalPageCount = (emotions.count + EmotionMaxcountPerPage - 1) / EmotionMaxcountPerPage;
    int currentPageCount = self.scrollView.subviews.count;//没设置前有多少页
    self.pageControl.numberOfPages = totalPageCount;
    self.pageControl.currentPage = 0;//默认为第一页
    
    //决定scrollView显示多少页表情
    for(int i = 0;i < totalPageCount;i++){
        
        EmotionGridView *gridView = nil;
        if(i >= currentPageCount){//如果gridView不够用了，再创建
            gridView = [[EmotionGridView alloc]init];
            [self.scrollView addSubview:gridView];
        }else{//否则复用之前的
            gridView = self.scrollView.subviews[i];
        }
        
        int loc = i * EmotionMaxcountPerPage;
        int len = EmotionMaxcountPerPage;
        if(loc +len > emotions.count){//对越界进行处理
            len = emotions.count - loc;
        }
        NSRange range = NSMakeRange(loc, len);
        NSArray *gridEmotions = [emotions subarrayWithRange:range];
        gridView.emotions = gridEmotions;
        
        gridView.hidden = NO;
    }
    
    //隐藏后面的不需要用到的gridView
    for(int i = totalPageCount;i < currentPageCount;i++){
        EmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.hidden = YES;
    }
    
    //重新布局子控件
    [self setNeedsLayout];
    
    //表情滚动到最前面
    self.scrollView.contentOffset = CGPointZero;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置pageControl的frame
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.y = self.height - self.pageControl.height;
    
    //设置scrollView的frame
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    
    //设置scrollView内部的frame
    int count = self.pageControl.numberOfPages;
    CGFloat gridW = self.scrollView.width;
    CGFloat gridH = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(gridW * count, 0);
    for(int i = 0;i < count;i++){
        EmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.width = gridW;
        gridView.height = gridH;
        gridView.x = i * gridW;
    }
    
}

@end
