//
//  ProfileViewController.m
//  微博
//
//  Created by 张智勇 on 15/9/5.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
}

- (void)setting{

    NSLog(@"settting");
}

@end
