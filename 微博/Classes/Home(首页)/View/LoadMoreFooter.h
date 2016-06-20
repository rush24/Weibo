//
//  LoadMoreFooter.h
//  微博
//
//  Created by 张智勇 on 15/12/7.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadMoreFooter : UIView
+ (instancetype)footer;

- (void)beginRefreshing;
- (void)endRefreshing;

@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;
@end
