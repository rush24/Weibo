//
//  MessageViewController.m
//  微博
//
//  Created by 张智勇 on 15/9/5.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import "MessageViewController.h"

@implementation MessageViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"写私信" style:UIBarButtonItemStyleDone target:self action:@selector(composeMsg)];
}


- (void)composeMsg{

    NSLog(@"composeMsg");
}



@end
