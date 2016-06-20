//
//  LoadMoreFooter.m
//  微博
//
//  Created by 张智勇 on 15/12/7.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "LoadMoreFooter.h"

@interface LoadMoreFooter()
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@end

@implementation LoadMoreFooter

+ (instancetype)footer{
    return [[[NSBundle mainBundle]loadNibNamed:@"LoadMoreFooter" owner:nil options:nil]lastObject];
}

- (void)beginRefreshing
{
    self.StatusLabel.text = @"正在拼命加载更多数据...";
    [self.loading startAnimating];
    self.refreshing = YES;
}

- (void)endRefreshing
{
    self.StatusLabel.text = @"上拉可以加载更多数据";
    [self.loading stopAnimating];
    self.refreshing = NO;
}

@end
