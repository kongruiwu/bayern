//
//  BERTeamListViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/19.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERTeamListViewController.h"
#import "BERTeamCell.h"
#import "HupuTitleScrollView.h"

@interface BERTeamListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation BERTeamListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WindowWidth, WindowHeight - NAV_BAR_H - STATUS_BAR_H - tScrollHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
//    tableView.layer.borderColor = [UIColor redColor].CGColor;
//    tableView.layer.borderWidth = 2;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView = tableView;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TeamCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    
    BERTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[BERTeamCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        
    }
    
    [cell configureCell:self.listArr[indexPath.row]];
    cell.positionLalel.text = self.teamPosition;
    [cell showCellLineWithHeight:TeamCellHeight];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *teamerID=[NSString stringWithFormat:@"%@",[self.listArr[indexPath.row] objectForKey:@"id"]];
    NSString *teamerNum=[NSString stringWithFormat:@"%@",[self.listArr[indexPath.row] objectForKey:@"No"]];
    BOOL rec;
    if ([teamerNum isEqualToString:@""]) {
        rec=NO;
    }else
    {
        rec=YES;
    }
    if ([self.delegate respondsToSelector:@selector(pushtoTeamerViewWithID: andIsTeamer:)]) {
        [self.delegate pushtoTeamerViewWithID:teamerID andIsTeamer:rec];
    }
   
    
    
}
#pragma mark - Getter

- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    
    return _listArr;
}

@end
