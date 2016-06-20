//
//  StatusOriginalFrame.m
//  微博
//
//  Created by 张智勇 on 15/12/31.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "StatusOriginalFrame.h"
#import "Status.h"
#import "StatusPhotosView.h"

@implementation StatusOriginalFrame

- (void)setStatus:(Status *)status{
    _status = status;
    
    //头像
    CGFloat iconX = StatusCellInset;
    CGFloat iconY = StatusCellInset;
    CGFloat iconW = 35;
    CGFloat iconH = 35;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //昵称
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + StatusCellInset;
    CGFloat nameY = iconY;
    CGSize nameSize = [status.user.name sizeWithFont:StatusOrginalNameFont];
    self.nameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    //会员图标
    if(status.user.isVip){//是会员
        CGFloat vipX = CGRectGetMaxX(self.nameFrame) + StatusCellInset;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = vipY;
        self.vipFrame = CGRectMake(vipX, vipY, vipW, vipH);
    }
        
    //时间
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameFrame) + StatusCellInset * 0.5;
    CGSize timeSize = [status.created_at sizeWithFont:StatusOrginalTimeFont];
    self.timeFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    //来源
    CGFloat sourceX = CGRectGetMaxX(self.timeFrame) + StatusCellInset;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:StatusOrginalSourceFont];
    self.sourceFrame = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    
    //正文
    CGFloat textX = StatusCellInset;
    CGFloat textY = CGRectGetMaxY(self.iconFrame) + StatusCellInset;
    CGFloat maxW = ScreenW - 2 * StatusCellInset;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [status.attributeText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textFrame = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    //相册
    CGFloat h = 0;
    if(status.pic_urls.count){
        CGFloat photosViewX = textX;
        CGFloat photosViewY = CGRectGetMaxY(self.textFrame) + StatusCellInset;
        CGSize photosViewSize = [StatusPhotosView sizeWithPhotosCount:status.pic_urls.count];
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
