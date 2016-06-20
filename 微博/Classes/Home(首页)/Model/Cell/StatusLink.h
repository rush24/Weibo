//
//  Link.h
//  微博
//
//  Created by 张智勇 on 16/2/17.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusLink : NSObject

//链接的文字
@property(nonatomic,copy) NSString *text;

//链接的范围
@property(nonatomic,assign) NSRange range;

//链接范围所包含的矩形框
@property(nonatomic,strong) NSArray *rects;

@end
