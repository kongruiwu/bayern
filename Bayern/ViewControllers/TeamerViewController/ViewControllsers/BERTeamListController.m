//
//  BERTeamListController.m
//  Bayern
//
//  Created by 吴孔锐 on 2016/10/13.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "BERTeamListController.h"
#import "TeamerListCell.h"
#import "ListTeamerModel.h"
#import "BERDetailTeamViewController.h"
@interface BERTeamListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView * tabview;

@end

@implementation BERTeamListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}
- (void)creatUI{
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH - Anno750(80) - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(350);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"TeamerListCell";
    TeamerListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
       cell = [[TeamerListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ListTeamerModel * model = self.dataArray[indexPath.row];
    [cell updateWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BERDetailTeamViewController *vc=[[BERDetailTeamViewController alloc]init];
    BOOL rec = YES;
    ListTeamerModel * model = self.dataArray[indexPath.row];
    NSString * string = [NSString stringWithFormat:@"%@",model.No];
    if (string.length == 0) {
        rec = NO;
    }
    vc.isTeamer=rec;
    vc.teamerID=[NSString stringWithFormat:@"%@",model.id];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
