//
//  StatusRetweetedFrame.m
//  微博
//
//  Created by 张智勇 on 15/12/31.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "StatusRetweetedFrame.h"
#import "Status.h"
#import "StatusPhotosView.h"

@implementation StatusRetweetedFrame

- (void)setStatus:(Status *)status{
    _status = status;
    
//    //昵称
//    CGFloat nameX = StatusCellInset;
//    CGFloat nameY = StatusCellInset;
//    NSString *name = [NSString stringWithFormat:@"@%@",status.retweeted_status.user.name];
//    CGSize nameSize = [name sizeWithFont:StatusRetweetedNameFont];
//    self.nameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);

    //正文
    CGFloat textX = StatusCellInset;
    CGFloat textY = StatusCellInset;
    CGFloat maxW = ScreenW - 2 * StatusCellInset;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [status.retweeted_status.attributeText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textFrame = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    //相册
    CGFloat h = 0;
    if(status.retweeted_status.pic_urls.count){
        CGFloat photosViewX = textX;
        CGFloat photosViewY = CGRectGetMaxY(self.textFrame) + StatusCellInset;
        CGSize photosViewSize = [StatusPhotosView sizeWithPhotosCount:status.retweeted_status.pic_urls.count];
        self.photosViewFrame = CGRectMake(photosViewX, photosViewY, photosViewSize.width, photosViewSize.height);
        h = CGRectGetMaxY(self.photosViewFrame) + StatusCellInset;
    }else{
        h = CGRectGetMaxY(self.textFrame) + StatusCellInset;
    }
    //自己
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = ScreenW;
    self.frame = CGRectMake(x, y, w, h);
}

@end
