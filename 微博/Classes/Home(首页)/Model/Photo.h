//
//  Photot.h
//  微博
//
//  Created by 张智勇 on 15/12/6.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
/** 缩略图 */
@property (nonatomic, copy) NSString *thumbnail_pic;
/** 大图 */
@property (nonatomic,copy) NSString *bmiddle_pic;

@end
