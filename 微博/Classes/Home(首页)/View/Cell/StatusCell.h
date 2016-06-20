//
//  StatusCell.h
//  微博
//
//  Created by 张智勇 on 15/12/30.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusFrame;
@interface StatusCell : UITableViewCell

@property(nonatomic,strong) StatusFrame *statusFrame;

/**
 *  创建cell
 *
 *  @param tableView
 *
 *  @return
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
