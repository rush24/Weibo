//
//  TabBarController.m
//  微博
//
//  Created by 张智勇 on 15/9/4.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "NavigationController.h"
#import "TabBar.h"
#import "ComposeViewController.h"
#import "AccountTool.h"
#import "UserTool.h"

@interface TabBarController ()<TabBarDelegate>

@property (nonatomic, weak) HomeViewController *home;
@property (nonatomic, weak) MessageViewController *message;
@property (nonatomic, weak) ProfileViewController *profile;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有的子控制器
    [self addAllChildVcs];
    
    // 创建自定义tabbar
    [self addCustomTabBar];
    
    //利用定时器获得用户的未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)getUnreadCount{
    //请求参数
    UnreadCountParam *param = [UnreadCountParam param];
    param.uid = [AccountTool account].uid;
    //获得未读数
    [UserTool unreadCountWithParam:param success:^(UnreadCountResult *result) {
        // 显示微博未读数
        if(result.status == 0){
            self.home.tabBarItem.badgeValue = nil;
        }else{
            self.home.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",result.status];
        }
        
        // 显示消息未读数
        if (result.messageCount == 0) {
            self.message.tabBarItem.badgeValue = nil;
        } else {
            self.message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.messageCount];
        }
        
        // 显示新粉丝数
        if (result.follower == 0) {
            self.profile.tabBarItem.badgeValue = nil;
        } else {
            self.profile.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.follower];
        }
        
        // 在图标上显示所有的未读数
        [UIApplication sharedApplication].applicationIconBadgeNumber = result.totalCount;
    } failure:^(NSError *error) {
        NSLog(@"获取未读数失败");
        
    }];
}

/**
 *  添加所有的子控制器
 */
- (void)addAllChildVcs{
    
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addOneChildVc:home title:@"首页" imageName:@"tabbar_home"
      selectedImageName:@"tabbar_home_selected"];
    self.home = home;
    
    MessageViewController *message = [[MessageViewController alloc] init];
    [self addOneChildVc:message title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    self.message = message;
    
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    [self addOneChildVc:discover title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self addOneChildVc:profile title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    self.profile = profile;
}

/**
 *  创建自定义tabbar
 */
- (void)addCustomTabBar{

    // 调整tabbar
    TabBar *customTabBar = [[TabBar alloc] init];
    customTabBar.selectionIndicatorImage = [UIImage imageWithName:@"navigationbar_button_background"];
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];
    customTabBar.myDelegate = self;
}

- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.view.backgroundColor = [UIColor whiteColor];
    // 设置标题
    childVc.title = title;
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[UITextAttributeTextColor] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    NavigationController *nav = [[NavigationController alloc]initWithRootViewController:childVc];
    
    // 添加为tabbar控制器的子控制器
    [self addChildViewController:nav];
}

#pragma mark - HMTabBarDelegate
- (void)tabBarDidClickedPlusButton:(TabBar *)tabBar
{
    // 弹出发微博控制器
    ComposeViewController *compose = [[ComposeViewController alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}

@end




