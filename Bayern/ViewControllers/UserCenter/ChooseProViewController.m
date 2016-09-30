//
//  ChooseProViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/25.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "ChooseProViewController.h"
#import "ChooseCityViewController.h"

@interface ChooseProViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSArray * dataArray;;
@end
@implementation ChooseProViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavUnAlpha];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setNavAlpha];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self drawBackButton];
    [self drawTitle:@"选择地址"];
    [self creatUI];
}
- (void)creatUI{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    self.dataArray = [NSArray arrayWithContentsOfFile:path];
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(90);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID =@"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView * lineview = [Factory creatViewWithColor:COLOR_LINECOLOR];
        [cell addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@1);
        }];
    }
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.textLabel.text = dic[@"state"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCityViewController * vc = [[ChooseCityViewController alloc]init];
    NSDictionary * dic = self.dataArray[indexPath.row];
    vc.dataArray = dic[@"cities"];
    vc.addressPre = dic[@"state"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
