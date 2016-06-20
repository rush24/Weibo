//
//  DiscoverViewController.m
//  微博
//
//  Created by 张智勇 on 15/9/5.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SearchBar.h"
#import "CommonGroup.h"
#import "CommonItem.h"
#import "CommonCell.h"

@interface DiscoverViewController()

@property(nonatomic,strong) NSMutableArray *groups;

@end

@implementation DiscoverViewController

- (NSMutableArray *)groups{
    if(_groups == nil){
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (id)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    //搜索框
    SearchBar *searchBar = [SearchBar searchBar];
    searchBar.width = 300;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
    
    //设置tableView属性
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundView.backgroundColor = GlobalBackgroundColor;//tableview样式为group时直接设置背景色无效，需这样设置
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = StatusCellMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(StatusCellMargin - 35, 0, 0, 0);
    
    //初始化模型
    [self setupGroups];
}

- (void)setupGroups{
    [self setupGroup0];
    [self setupGroup2];
    [self setupGroup1];
}

- (void)setupGroup0{
    // 1.创建组
    CommonGroup *group = [CommonGroup group];
    [self.groups addObject:group];
    
    // 3.设置组的所有行数据
    CommonItem *hotStatus = [CommonItem itemWithTitle:@"热门微博" icon:@"hot_status"];
    hotStatus.subtitle = @"笑话，娱乐，神最右都搬到这啦";
    
    CommonItem *findPeople = [CommonItem itemWithTitle:@"找人" icon:@"find_people"];
    findPeople.subtitle = @"名人、有意思的人尽在这里";
    
    group.items = @[hotStatus, findPeople];
}

- (void)setupGroup1{
    // 1.创建组
    CommonGroup *group = [CommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    CommonItem *gameCenter = [CommonItem itemWithTitle:@"游戏中心" icon:@"game_center"];
    CommonItem *near = [CommonItem itemWithTitle:@"周边" icon:@"near"];
    CommonItem *app = [CommonItem itemWithTitle:@"应用" icon:@"app"];
    
    group.items = @[gameCenter, near, app];
}

- (void)setupGroup2{
    // 1.创建组
    CommonGroup *group = [CommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    CommonItem *video = [CommonItem itemWithTitle:@"视频" icon:@"video"];
    CommonItem *music = [CommonItem itemWithTitle:@"音乐" icon:@"music"];
    CommonItem *movie = [CommonItem itemWithTitle:@"电影" icon:@"movie"];
    CommonItem *cast = [CommonItem itemWithTitle:@"播客" icon:@"cast"];
    CommonItem *more = [CommonItem itemWithTitle:@"更多" icon:@"more"];
    
    group.items = @[video, music, movie, cast, more];
}

#pragma mark - TableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CommonGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonCell *cell = [CommonCell cellWithTableView:tableView];
    CommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end



