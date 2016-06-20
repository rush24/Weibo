//
//  BaseParam.m
//  微博
//
//  Created by 张智勇 on 15/12/27.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "BaseParam.h"
#import "AccountTool.h"
#import "Account.h"

@implementation BaseParam

- (id)init{
    if(self = [super init]){
         self.access_token = [AccountTool account].access_token;
    }
    
    return self;
}

+ (instancetype)param{
    return [[self alloc]init];
}

@end
