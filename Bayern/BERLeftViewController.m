//
//  BERLeftViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERLeftViewController.h"
#import "UserCenterViewController.h"
#import "BERLeftTableViewCell.h"
#import "Factory.h"
#import "LeftHeadCell.h"
static const CGFloat kJVTableViewTopInset = 80.0;

@interface BERLeftViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) UITableView *listTableView;
@end

@implementation BERLeftViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateHeadCell];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"111");
    });
    // Do any additional setup after loading the view.
    
    self.titleArray = [NSArray arrayWithObjects:@"",@"首   页",@"新   闻",@"图   片", @"视   频",@"赛   程",@"积   分",@"球   队",@"俱乐部", @"商   店", @"设   置",nil];
    self.contentArray = [NSArray arrayWithObjects:@"",@"Home",@"News",@"Photos", @"Videos",@"Fixtures",@"Standings",@"Team", @"Club", @"Fan Shop",@"Settings",nil];
    self.iconArray = [NSArray arrayWithObjects:@"",@"home",@"news",@"photos",@"videos", @"fixtures",@"standings",@"team", @"club",@"shop",@"setup",nil];
    
    self.listTableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    [self.view addSubview:self.listTableView];
    //默认选中第一行
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    self.view.backgroundColor = [UIColor clearColor];
}
-(void)updateHeadCell{
    [self.listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return Anno750(210);
    }
    return LeftCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    static NSString * headCell = @"HeadCell";
    if (indexPath.row == 0) {
        LeftHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:headCell];
        if (cell == nil) {
            cell = [[LeftHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headCell];
        }
        [cell updateStatus];
        return cell;
    }
    BERLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[BERLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        
    }
    cell.selectedIconName = self.iconArray[indexPath.row];
    cell.iconName = [NSString stringWithFormat:@"%@_1",self.iconArray[indexPath.row]];
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentLabel.text = self.contentArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[[AppDelegate sharedInstance] mainViewController] setCenterVCWithIndex:indexPath.row];
}

#pragma mark - Getter Method

- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -60, self.sliderWidth, WindowHeight+60) style:UITableViewStylePlain];
        _listTableView.backgroundColor = [UIColor blackColor];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _listTableView;
}


@end
