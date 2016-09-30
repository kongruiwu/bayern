//
//  ScoreDeatilViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/22.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "ScoreDeatilViewController.h"
#import "BERStandingTableViewCell.h"
#import "BERStandModel.h"
@interface ScoreDeatilViewController()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation ScoreDeatilViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self creatUI];
    [self loadData];
}
- (void)creatUI{
    for (int i=0; i<3; i++) {
        UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0+SCREENWIDTH/3*i,0, SCREENWIDTH/3, Anno750(80))];
        navView.tag=1200+i;
        [self.view addSubview:navView];
    }
    UIView *view1=(UIView *)[self.view viewWithTag:1200];
    UILabel *barNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, view1.frame.size.width, view1.frame.size.height-20)];
    barNameLabel.text=@"俱乐部";
    barNameLabel.textColor= COLOR_CONTENT_GRAY_3;
    barNameLabel.font=[UIFont systemFontOfSize:font750(30)];
    barNameLabel.textAlignment=NSTextAlignmentCenter;
    [view1 addSubview:barNameLabel];
    
    UIView *view2=(UIView *)[self.view viewWithTag:1201];
    NSArray *resArray=@[@"胜",@"平",@"负"];
    for (int i=0; i<resArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0+view2.frame.size.width/resArray.count*i, 10, view2.frame.size.width/resArray.count, view2.frame.size.height-20)];
        label.text=resArray[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:font750(30)];
        label.textColor=COLOR_CONTENT_GRAY_3;
        [view2 addSubview:label];
    }
    
    UIView *view3=(UIView *)[self.view viewWithTag:1202];
    NSArray *standArray=@[@"进/失球",@"积分"];
    for (int i=0; i<2; i++) {
        UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0+view3.frame.size.width/2*i, 10, view3.frame.size.width/2, view3.frame.size.height-20)];
        scoreLabel.text=standArray[i];
        scoreLabel.textColor=COLOR_CONTENT_GRAY_3;
        scoreLabel.font=[UIFont systemFontOfSize:font750(30)];
        scoreLabel.textAlignment=NSTextAlignmentCenter;
        [view3 addSubview:scoreLabel];
    }
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, Anno750(80), SCREENWIDTH, SCREENHEIGH - 64 - Anno750(160)) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(100);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"BERStandingTableViewCell";
    BERStandingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[BERStandingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    BERStandModel * model = self.dataArray[indexPath.row];
    [cell configUIWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)loadData
{
    [self.view showLoadingActivity:YES];
    //实例化一个数组临时接受数据
    self.dataArray=[[NSMutableArray alloc]init];
    __weak ScoreDeatilViewController * weakSelf = self;
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:nil action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        //获取全部数据
        if ([dic[@"code"] integerValue] == 0) {
            NSDictionary * dic1 = dic[@"data"];
            NSDictionary * data = dic1[@"rank"];
            NSString * key = @"5";
            if (self.isSecond) {
                key =@"9";
            }
            NSArray * arr = data[key];
            for (int i = 0; i<arr.count; i++) {
                NSDictionary * dataDic = arr[i];
                BERStandModel *model=[[BERStandModel alloc]init];
                [model setValuesForKeysWithDictionary:dataDic];
                if ([model.known_name_zh isEqualToString:@"拜仁"]) {
                    model.isBer = YES;
                }
                [weakSelf.dataArray addObject:model];
            }
        }
        [weakSelf.tabview reloadData];
        [weakSelf.view hideLoadWithAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];
}
-(NSString *)getActionName
{
    return @"team_rank";
}
-(NSString *)getMainActionName
{
    return @"match";
}
@end
