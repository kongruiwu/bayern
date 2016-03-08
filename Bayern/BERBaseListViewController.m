//
//  HFBaseListViewController.m
//  HupuNFL
//
//  Created by hupu.com on 14/11/10.
//  Copyright (c) 2014年 hupu.com. All rights reserved.
//

#import "BERBaseListViewController.h"

@interface BERBaseListViewController ()

@end

@implementation BERBaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initModel];
    [self initDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Method

- (void)initModel {
    self.dataArray = [NSMutableArray array];
}

- (void)initDisplay {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refresh addTarget:self action:@selector(handleData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

#pragma mark - Public Method

- (void)handleData:(id)sender {
    if (self.refreshControl.refreshing == YES) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.3];
    }
}

//重新请求列表数据的对外接口
- (void)refreshData {
    
}

//请求更多数据的对外接口
- (void)loadMoreData {
    
}

//结束上拉刷新的接口
- (void)finishRefreshingControl {
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
}

- (void)checkNeedReloadMoreWithDataArr:(NSArray *)listArr {
    if (listArr.count == 0) {
        self.needReloadMore = NO;
    } else {
        self.needReloadMore = YES;
    }
    
}

//触发自动刷新列表的对外接口
- (void)autoRefreshData {
    if (self.dataArray.count == 0) {
        [self.tableView setContentOffset:CGPointMake(0, -90) animated:YES];
        [self.refreshControl beginRefreshing];
        [self handleData:self];
    }
}

//检查是否需要清理数据的对外借口
- (void)cleanListArrayIfNeeded {
    if (self.isRefreshData) {
        [self.dataArray removeAllObjects];
        self.isRefreshData = NO;
    }
}

//隐藏下拉刷新的对外接口
- (void)hideRefreshControl {
    [self.refreshControl removeFromSuperview];
}

//通过比对服务端列表个数和分页数量，决定列表是否需要上拉更多
- (void)checkPagnationForReloadMoreWithListCount:(NSInteger)listCount {
    if (self.pagnationNum <= listCount) {
        self.needReloadMore = YES;
    } else {
        //下发分页列表数量比既定分页数量少，则无加载更多
        self.needReloadMore = NO;
    }
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.needReloadMore) {
        return self.dataArray.count +1;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.needReloadMore) {
        if (indexPath.row == self.dataArray.count) {
            return LOADING_CELL_HEIGHT;
        }
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    static NSString *moreCellIntifier = @"moreCell";
    
    if (self.needReloadMore == YES && indexPath.row == self.dataArray.count) {
        AFLoadingCell *moreCell = [tableView dequeueReusableCellWithIdentifier:moreCellIntifier];
        if (moreCell == nil) {
            moreCell = [[AFLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellIntifier];
        }
        [moreCell.spinner startAnimating];
        return moreCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.dataArray.count) {
        return; //避免数组越界
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[AFLoadingCell class]]) {
        return; //点击加载更多cell，不操作
    }
    
    //将子页面的点击事件传递给需要的母页面
    if ([self.baseListDelegate respondsToSelector:@selector(tableViewDidSelectWithIndexPath:)]) {
        [self.baseListDelegate tableViewDidSelectWithIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.needReloadMore) {
        return;
    }
    
    //check to reload more cell rows
    if (scrollView.contentOffset.y + loadMoreOffset >= scrollView.contentSize.height - scrollView.frame.size.height && self.refreshControl.isRefreshing == NO) {
        [self loadMoreData];
    }
}

#pragma mark - Public Method

- (void)drawTitle:(NSString *)title {
    CGFloat titleViewH = 24;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, titleViewH)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    icon.frame = CGRectMake(0, 0, 24, 24);
    [titleView addSubview:icon];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 60, titleViewH)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = title;
    [titleView addSubview:titleLb];
    
    self.navigationItem.titleView = titleView;
}

//用于首页，左右切换页面滑动
- (void)drawMainTabItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"item"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftDidScroll)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"game"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightDidScroll)];
    [item2 setBackButtonBackgroundImage:[UIImage imageNamed:@"game"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = item2;
}

#pragma mark - Selector Method

- (void)leftDidScroll {
    [[AppDelegate sharedInstance] toggleLeftDrawer:self animated:YES];
}

- (void)rightDidScroll {
    [[AppDelegate sharedInstance] toggleRightDrawer:self animated:YES];
}

//- (void)doBack {
//    switch (self.backType) {
//        case RTSelectorBackTypeDismiss:
//            [self dismissViewControllerAnimated:YES completion:nil];
//            break;
//        case RTSelectorBackTypePopBack:
//            [self.navigationController popViewControllerAnimated:YES];
//            break;
//        case RTSelectorBackTypePopToRoot:
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            break;
//            
//        default:
//            break;
//    }
//}

@end
