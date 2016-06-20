//
//  Photot.m
//  微博
//
//  Created by 张智勇 on 15/12/6.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (void)setThumbnail_pic:(NSString *)thumbnail_pic{
    _thumbnail_pic = [thumbnail_pic copy];
    
    self.bmiddle_pic = [thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}

@end
