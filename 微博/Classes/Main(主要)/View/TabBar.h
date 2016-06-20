//
//  TabBar.h
//  微博
//
//  Created by 张智勇 on 15/9/11.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBar;

@protocol TabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButton:(TabBar *)tabBar;

@end

@interface TabBar : UITabBar

@property (nonatomic, weak) id<TabBarDelegate> myDelegate;


@end
