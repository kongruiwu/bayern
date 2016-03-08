//
//  BERStandingsViewController.m
//  Bayern
//
//  Created by wurui on 15/7/21.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERStandingsViewController.h"
#import "BERStandingTableViewCell.h"
#import "BERHeadFile.h"
@interface BERStandingsViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *mainScroll;
    UITableView *gerTabView;
    UITableView *eurTabView;
}

@end

@implementation BERStandingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self drawMainTabItem];
    [self drawTitle:@"积分"];
    
    [self initUI];
    [self creatTabView];
    [self loadData];
    
    [self.view showLoadingActivity:YES];
    // Do any additional setup after loading the view from its nib.
}
-(void)initUI
{
    NSArray *titleArray=@[@"德甲",@"欧冠"];
    self.NavArray = titleArray;
    for (int i=0; i<self.NavArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0+i*SCREENWIDTH/self.NavArray.count , 0, SCREENWIDTH/2, 44);
        [btn setTitle:self.NavArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"999999"]
                  forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:TEXTFONTSIZE];
        if (i==0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"e4003a"]
                      forState:UIControlStateNormal];
        }
        [btn        addTarget:self
                       action:@selector(NavBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:1000+i];
        [self.view addSubview:btn];
    }
    
    UIButton *btn1=(UIButton *)[self.view viewWithTag:1000];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(btn1.frame.origin.x, btn1.frame.origin.y+btn1.frame.size.height, btn1.frame.size.width, 2)];
    lineView.backgroundColor=[UIColor colorWithHexString:@"e4003a"];
    [lineView setTag:1100];
    [self.view addSubview:lineView];

    for (int i=0; i<3; i++) {
        UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0+SCREENWIDTH/3*i,lineView.frame.origin.y+lineView.frame.size.height, SCREENWIDTH/3, 44)];
        navView.tag=1200+i;
        [self.view addSubview:navView];
    }
    UIView *view1=(UIView *)[self.view viewWithTag:1200];
    UILabel *barNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, view1.frame.size.width, view1.frame.size.height-20)];
    barNameLabel.text=@"俱乐部";
    barNameLabel.textColor=[UIColor colorWithHexString:@"444444"];
    barNameLabel.font=[UIFont systemFontOfSize:TEXTFONTSIZE];
    barNameLabel.textAlignment=NSTextAlignmentCenter;
    [view1 addSubview:barNameLabel];
    
    UIView *view2=(UIView *)[self.view viewWithTag:1201];
    NSArray *resArray=@[@"胜",@"平",@"负"];
    for (int i=0; i<resArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0+view2.frame.size.width/resArray.count*i, 10, view2.frame.size.width/resArray.count, view2.frame.size.height-20)];
        label.text=resArray[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:TEXTFONTSIZE];
        label.textColor=[UIColor colorWithHexString:@"444444"];
        [view2 addSubview:label];
    }
    
    UIView *view3=(UIView *)[self.view viewWithTag:1202];
    NSArray *standArray=@[@"进/失球",@"积分"];
    for (int i=0; i<2; i++) {
    UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0+view3.frame.size.width/2*i, 10, view3.frame.size.width/2, view3.frame.size.height-20)];
    scoreLabel.text=standArray[i];
    scoreLabel.textColor=[UIColor colorWithHexString:@"444444"];
    scoreLabel.font=[UIFont systemFontOfSize:TEXTFONTSIZE];
    scoreLabel.textAlignment=NSTextAlignmentCenter;
    [view3 addSubview:scoreLabel];
    }
    
    mainScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, view1.frame.size.height+view1.frame.origin.y, SCREENWIDTH, SCREENHEIGHT-view1.frame.size.height-view1.frame.origin.y)];
    mainScroll.showsHorizontalScrollIndicator=NO;
    mainScroll.showsVerticalScrollIndicator=NO;
    mainScroll.contentSize=CGSizeMake(self.NavArray.count*SCREENWIDTH, SCREENHEIGHT-view1.frame.size.height-view1.frame.origin.y);
    mainScroll.pagingEnabled=YES;
    mainScroll.delegate=self;
    [self.view addSubview:mainScroll];
}
#pragma mark - 导航按钮点击事件
-(void)NavBtnClick:(UIButton *)btn
{
    UIView *lineView=(UIView *)[self.view viewWithTag:1100];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame=CGRectMake(btn.frame.origin.x, btn.frame.origin.y+btn.frame.size.height, btn.frame.size.width, 2);
        lineView.frame=frame;
    }];
    for (int i=0; i<self.NavArray.count; i++) {
        UIButton *btn1=(UIButton *)[self.view viewWithTag:1000+i];
        if (btn1.tag==btn.tag) {
            [btn1 setTitleColor:[UIColor colorWithHexString:@"e4003a"]
                       forState:UIControlStateNormal];
            btn1.titleLabel.font=[UIFont systemFontOfSize:TEXTFONTSIZE];
        }else
        {
            [btn1 setTitleColor:[UIColor colorWithHexString:@"999999"]
                       forState:UIControlStateNormal];
            btn1.titleLabel.font=[UIFont systemFontOfSize:TEXTFONTSIZE];
        }
    }
    CGPoint point=mainScroll.contentOffset;
    if (btn.tag==1000) {
        point.x=0;
    }else{
        point.x=mainScroll.frame.size.width;
    }
    [UIView animateWithDuration:0.5 animations:^{
        mainScroll.contentOffset=point;
    }];
}
#pragma mark - UIScrollView代理实现
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==mainScroll) {
        UIView *lineView=(UIView *)[self.view viewWithTag:1100];
        CGRect frame=CGRectMake(mainScroll.contentOffset.x/2, lineView.frame.origin.y, lineView.frame.size.width, lineView.frame.size.height);
        lineView.frame=frame;
        UIButton *btn=(UIButton *)[self.view viewWithTag:1000];
        UIButton *btn1=(UIButton *)[self.view viewWithTag:1001];
        if (mainScroll.contentOffset.x<SCREENWIDTH/4) {
            [btn setTitleColor:[UIColor colorWithHexString:@"e4003a"]
                      forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor colorWithHexString:@"999999"]
                       forState:UIControlStateNormal];
        }else
        {
            [btn1 setTitleColor:[UIColor colorWithHexString:@"e4003a"]
                      forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"999999"]
                       forState:UIControlStateNormal];
        }
    }
}
#pragma mark - TB的创建
-(void)creatTabView
{
    gerTabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, mainScroll.frame.size.height-64) style:UITableViewStylePlain];
    eurTabView=[[UITableView alloc]initWithFrame:CGRectMake(mainScroll.frame.size.width, 0, SCREENWIDTH, mainScroll.frame.size.height-64) style:UITableViewStylePlain];
    gerTabView.showsHorizontalScrollIndicator=NO;
    gerTabView.showsVerticalScrollIndicator=NO;
    eurTabView.showsVerticalScrollIndicator=NO;
    eurTabView.showsHorizontalScrollIndicator=NO;
    gerTabView.delegate=self;
    gerTabView.dataSource=self;
    eurTabView.delegate=self;
    eurTabView.dataSource=self;
    gerTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    eurTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [mainScroll addSubview:gerTabView];
    [mainScroll addSubview:eurTabView];
    
}
#pragma mark - tabView dataSource/delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == gerTabView) {
        return self.dataArray.count;
    }else if(tableView == eurTabView)
    {
        if (self.data1Array.count==0) {
            return 1;
        }
        return self.data1Array.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView==gerTabView) {
        static NSString *cellID = @"cellName";
        
        BERStandingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[BERStandingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        BERStandModel *model=self.dataArray[indexPath.row];
        if ([model.known_name_zh isEqualToString:@"拜仁"]) {
            model.isBer=YES;
        }else
        {
            model.isBer=NO;
        }
        [cell configUIWithModel:model];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if(tableView == eurTabView)
    {
        static NSString *cellID = @"cellName";
        if (self.data1Array.count==0) {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:nil];
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            }
            cell.textLabel.text=@"暂无数据，敬请期待！";
            cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        BERStandingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[BERStandingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
                
        BERStandModel *model=self.data1Array[indexPath.row];
        if ([model.known_name_zh isEqualToString:@"拜仁"]) {
            model.isBer=YES;
        }else
        {
            model.isBer=NO;
        }
        [cell configUIWithModel:model];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}


#pragma mark - loadData
-(void)loadData
{
    //实例化一个数组临时接受数据
    self.dataArray=[[NSMutableArray alloc]init];
    self.data1Array=[[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    [manger GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:nil action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取全部数据
        NSArray *allDataArray=[[[responseObject objectForKey:@"data"] objectForKey:@"rank"] objectForKey:@"5"];
        
        for (NSDictionary *dic in allDataArray) {
            BERStandModel *model=[[BERStandModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [gerTabView reloadData];
        NSArray *allData1Array=[[[responseObject objectForKey:@"data"] objectForKey:@"rank"] objectForKey:@"9"];
        for (NSDictionary *dic in allData1Array) {
            BERStandModel *model=[[BERStandModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.data1Array addObject:model];
        }
        [eurTabView reloadData];
        [self.view hideLoadWithAnimated:YES];
        NSLog(@"积分数据加载成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"积分数据加载失败");
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

@end
