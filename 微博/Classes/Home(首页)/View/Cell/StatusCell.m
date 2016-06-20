//
//  StatusCell.m
//  微博
//
//  Created by 张智勇 on 15/12/30.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "StatusCell.h"
#import "StatusDetailView.h"
#import "StatusToolbar.h"
#import "StatusFrame.h"

@interface StatusCell()

@property(nonatomic,weak) StatusDetailView *detailView;
@property(nonatomic,weak) StatusToolbar *toolbar;
@end

@implementation StatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        //添加微博内容
        [self setDetailView];
        //添加工具条
        [self setToolbar];
        
    }
    return self;
}

/**
 *  添加微博内容
 */
- (void)setDetailView{
    StatusDetailView *detailView = [[StatusDetailView alloc]init];
    [self.contentView addSubview:detailView];
    self.detailView = detailView;
}

/**
 *  添加工具条
 */
- (void)setToolbar{
    StatusToolbar *toolbar = [[StatusToolbar alloc]init];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}

- (void)setStatusFrame:(StatusFrame *)statusFrame{
    _statusFrame = statusFrame;
    
    //微博具体内容的frame数据
    self.detailView.detailFrame = statusFrame.detailFrame;
    
    //底部工具条的frame数据
    self.toolbar.frame = statusFrame.toolbarFrame;
    self.toolbar.status = statusFrame.status;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"status";
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

@end



