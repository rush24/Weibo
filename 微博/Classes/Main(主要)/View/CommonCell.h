//
//  CommonCell.h
//  微博
//
//  Created by 张智勇 on 16/2/17.
//  Copyright © 2016年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommonItem;

@interface CommonCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//cell对应的item数据
@property(nonatomic,strong) CommonItem *item;

@end
