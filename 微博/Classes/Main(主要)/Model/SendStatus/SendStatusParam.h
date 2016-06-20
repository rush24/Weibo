//
//  SendStatusParam.h
//  微博
//
//  Created by 张智勇 on 15/12/27.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseParam.h"

@interface SendStatusParam : BaseParam


/**	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
@property (nonatomic, copy) NSString *status;

@end
