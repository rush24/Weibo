//
//  HomeViewController.m
//  微博
//
//  Created by 张智勇 on 15/9/5.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import "HomeViewController.h"
#import "TitleButton.h"
#import "PopMenu.h"
#import "AccountTool.h"
#import "Account.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "MJExtension.h"
#import "LoadMoreFooter.h"
#import "StatusTool.h"
#import "UserTool.h"
#import "StatusFrame.h"
#import "StatusCell.h"

@interface HomeViewController () <PopMenuDelegate>

/**
 *  微博数组(存放着所有的微博数据)
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@property(nonatomic,weak) TitleButton * titleButton;
@property (nonatomic, weak) LoadMoreFooter *footer;
@end

@implementation HomeViewController

/**
 *  懒加载
 *
 *  @return
 */
- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundView.backgroundColor = GlobalBackgroundColor;
    
    //设置每个cell之间没有分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置导航栏内容
    [self setupNavBar];
    
    // 集成刷新控件
    [self setupRefresh];
    
    //获取用户信息
    [self setupUserInfo];
    
    //监听链接点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkDidSelected:) name:StatusLinkDidSelectedNotification object:nil];
}

- (void)setupUserInfo{
    
    //1,封装请求参数
    UserInfoParam *param = [UserInfoParam param];
    param.uid = [AccountTool account].uid;
    //加载用户信息
    [UserTool userInfoWithParam:param success:^(UserInfoResult *user) {
        
        //设置用户昵称为标题
        [self.titleButton setTitle:user.name forState:UIControlStateNormal];
        //存储账号信息
        Account *account = [AccountTool account];
        account.name = user.name;
        [AccountTool save:account];
    } failure:^(NSError *error) {
        NSLog(@"请求失败%@",error);
    }];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh{
    // 1.添加下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    
    // 2.监听状态
    [refreshControl addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
    
    //让刷新控件自动进入刷新状态（显示菊花）
    [refreshControl beginRefreshing];
    
    //主动调用刷新方法（相当于手动下拉）
    [self refreshControlStateChange:refreshControl];
    
    //添加上拉加载更多控件
    LoadMoreFooter *footer = [LoadMoreFooter footer];
    self.tableView.tableFooterView = footer;
    self.footer = footer;
}

/**
 *  当下拉刷新控件进入刷新状态（转圈圈）的时候会自动调用
 */
- (void)refreshControlStateChange:(UIRefreshControl *)refreshContrl{
    
    [self loadNewStatus:refreshContrl];
}

/**
 *  提示用户刷新了几条微博
 *
 *  @param count
 */
- (void)refreshNewStatus:(int)count{
    
    //清零提醒数字
    [UIApplication sharedApplication].applicationIconBadgeNumber -= self.tabBarItem.badgeValue.intValue;
    self.tabBarItem.badgeValue = nil;
    
    UILabel *label = [[UILabel alloc]init];
    if(count){
        label.text = [NSString stringWithFormat:@"%d条新微薄",count];
    }else{
        label.text = [NSString stringWithFormat:@"没有新的微博"];
    }
    
    //设置背景图片、文字颜色对齐等等
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"timeline_new_status_background"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    //设置label的frame
    label.width = self.view.width;
    label.height = 35;
    label.x = 0;
    label.y = 64 - label.height;
    //把label加到navigationController上，并且在导航栏下面一层
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //动画，用transform能做到出来后回去不用设置，只要清空出来的transform
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        CGFloat delay = 0.8;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

/**
 *  根据微博模型数组 转化成 微博模型frame数据
 *
 *  @param statuses
 *
 *  @return 微博模型frame数据数组
 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses{
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    for (Status *status in statuses) {
        StatusFrame *statusFrame = [[StatusFrame alloc]init];
        statusFrame.status = status;
        [frames addObject:statusFrame];
    }
    return frames;
}

/**
 *  加载最新的微博数据
 */
- (void)loadNewStatus:(UIRefreshControl *)refreshContrl{
    
    //封装请求参数
    HomeStatusesParam *param = [HomeStatusesParam param];
    StatusFrame *firstStatusFrame = [self.statusFrames firstObject];
    Status *firstStatus = firstStatusFrame.status;
    if(firstStatus){
        // since_id false int64 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        param.since_id = @([firstStatus.idstr longLongValue]);
    }
    
    [StatusTool homeStatusesWithParam:param success:^(HomeStatusesResult *result) {
        
        //获得最新的微博数组
        NSArray *newFrames = [self statusFramesWithStatuses:result.statuses];
        
        // 将新数据插入到旧数据的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:indexSet];
        
        // 重新刷新表格
        [self.tableView reloadData];
        
        [refreshContrl endRefreshing];
        
        //提示刷新了几条微博
        [self refreshNewStatus:newFrames.count];
    } failure:^(NSError *error) {
        NSLog(@"请求失败--%@",error);
        [refreshContrl endRefreshing];
    }];

}

/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatuses
{
    // 1.封装请求参数
    HomeStatusesParam *param = [HomeStatusesParam param];
    StatusFrame *lastStatusFrame = [self.statusFrames lastObject];
    Status *lastStatus = lastStatusFrame.status;
    if (lastStatus) {
        param.max_id = @([lastStatus.idstr longLongValue] - 1);
    }
    
    // 2.加载微博数据
    [StatusTool homeStatusesWithParam:param success:^(HomeStatusesResult *result) {
        // 微博模型数组
        NSArray *newFrames = [self statusFramesWithStatuses: result.statuses];
        
        // 将新数据插入到旧数据的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 重新刷新表格
        [self.tableView reloadData];
        
        // 让刷新控件停止刷新（恢复默认的状态）
        [self.footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"请求失败--%@", error);
        // 让刷新控件停止刷新（恢复默认的状态）
        [self.footer endRefreshing];
    }];
}

/**
 *  设置导航栏内容
 */
- (void)setupNavBar{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_friendsearch" highImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendSearch)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_pop" highImageName:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    // 设置导航栏中间的标题按钮
    TitleButton *titleButton = [[TitleButton alloc] init];
    // 设置尺寸
    titleButton.height = 35;
    // 设置文字
    NSString *name = [AccountTool account].name;
    [titleButton setTitle:name ? name : @"首页" forState:UIControlStateNormal];
    // 设置图标
    [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    // 设置背景
    [titleButton setBackgroundImage:[UIImage resizedImage:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    // 监听按钮点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    self.titleButton = titleButton;

}

/**
 *  点击标题点击
 */
- (void)titleClick:(UIButton *)titleButton
{
    // 换成箭头向上
    [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    
    // 弹出菜单
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.backgroundColor = [UIColor redColor];
    
    PopMenu *menu = [[PopMenu alloc ] initWithContentView:button];
    menu.delegate = self;
    menu.arrowPosition = PopMenuArrowPositionLeft;
    //    menu.dimBackground = YES;
    [menu showInRect:CGRectMake(100, 100, 100, 100)];
}

/**
 *  点击链接
 */
- (void)linkDidSelected:(NSNotification *)note{
    NSString *linkText = note.userInfo[LinkText];
    NSLog(@"点击了链接：%@",linkText);
}
/**
 *  销毁通知
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 弹出菜单协议
- (void)popMenuDidDismissed:(PopMenu *)popMenu
{
    TitleButton *titleButton = (TitleButton *)self.navigationItem.titleView;
    [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

- (void)friendSearch
{
    NSLog(@"friendSearch---");
}

- (void)pop
{
    NSLog(@"pop---");
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.tableFooterView.hidden = self.statusFrames.count == 0;
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusCell *cell = [StatusCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newVc = [[UIViewController alloc] init];
    newVc.view.backgroundColor = [UIColor redColor];
    newVc.title = @"新控制器";
    [self.navigationController pushViewController:newVc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.statusFrames.count <= 0 || self.footer.isRefreshing) return;
    
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = self.view.height - self.tabBarController.tabBar.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        // 进入上拉刷新状态
        [self.footer beginRefreshing];
        // 加载更多的微博数据
        [self loadMoreStatuses];
    }
}

@end
