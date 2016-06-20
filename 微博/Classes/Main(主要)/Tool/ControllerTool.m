//
//  ControllerTool.m
//  微博
//
//  Created by 张智勇 on 15/12/5.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "ControllerTool.h"
#import "TabBarController.h"
#import "NewFeatureViewController.h"

@implementation ControllerTool
+ (void)chooseRootViewController{
    //如何知道第一次使用这个版本？比较上次的使用情况
    NSString *versionKey = @"CFBundleVersion";
    
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion isEqualToString:lastVersion]) { // 当前版本号 == 上次使用的版本：显示TabBarController
        //        self.window.rootViewController = [[TabBarController alloc] init];
        window.rootViewController = [[TabBarController alloc]init];
    } else { // 当前版本号 != 上次使用的版本：显示版本新特性
        window.rootViewController = [[NewFeatureViewController alloc] init];
        
        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }

}

@end
