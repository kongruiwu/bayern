//
//  BERFixtureListView.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/23.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERFixtureListView.h"

@implementation BERFixtureListView
{
    BOOL rec;//判断欧冠数据是否存在
}
-(void)creatTabViewWtihLeadgueID:(NSString *)leadgue_id
{
    if ([self.delegate respondsToSelector:@selector(showLoadView)]) {
        [self.delegate showLoadView];
    }
    self.leadID=leadgue_id;
    rec=NO;
    if ([self.leadID intValue]==9) {
        rec=[self loadDataWith:self.leadID];
    }
    
    [self creatTabView];
    
    [self loadData:leadgue_id];
    
    
}

-(void)creatTabView
{
    self.fixtureTabView=[[UITableView alloc]initWithFrame:CGRectMake(0 , 0, SCREENWIDTH, self.frame.size.height) style:UITableViewStylePlain];
    self.fixtureTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.fixtureTabView.delegate=self;
    self.fixtureTabView.dataSource=self;
    self.fixtureTabView.showsHorizontalScrollIndicator=NO;
    self.fixtureTabView.showsVerticalScrollIndicator=NO;
    [self addSubview:self.fixtureTabView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (rec) {
        return 1;
    }
    return self.dataArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (rec) {
        return 44.0f;
    }
    BERFixtureModel *model=self.dataArray[indexPath.row];
    int num=[model.game_status intValue];
    if (num==0) {
        return 171.0f;
        }
        return 191.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellName";
    if (rec) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text=@"暂无数据，敬请期待！";
        cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
        return cell;
    }
    BERFixtureTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[BERFixtureTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    BERFixtureModel *model=self.dataArray[indexPath.row];
    [cell configUIwithModel:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegat=self;
    return cell;
}
-(void)BERFixtureBtnClickWith:(BERFixtureModel *)model
{
    [BERShareModel sharedInstance].shareID = [NSString stringWithFormat:@"%@",model.news_link];
    [BERShareModel sharedInstance].shareTitle =[NSString stringWithFormat:@"%@",model.league_title];
    [BERShareModel sharedInstance].shareUrl=[[BERShareModel sharedInstance] getShareURL:YES];
    [NFLAppLogManager sendLogWithEventID:EventID_News withKeyName:KN_NewsList andValueName:@"News"];
    [[AppDelegate sharedInstance] pushNewsWithNewsLink:[NSString stringWithFormat:@"%@",model.news_link]];
}
-(void)BERFixturePicBtnClickWith:(BERFixtureModel *)model
{
    if ([self.delegate respondsToSelector:@selector(pushToImgViewController:)]) {
        [self.delegate pushToImgViewController:model];
    }
}
-(NSString *)getActionName
{
    return @"schedules";
}
-(NSString *)getMainActionName
{
    return @"match";
}

-(void)loadData:(NSString *)leadgue_id
{
    self.dataArray=[[NSMutableArray alloc]init];
    NSDictionary *parame=@{
                           @"league_id" : leadgue_id,
                           @"limit"     : @"0"
                           /*
                            leadgue_id:
                            5 ->德甲
                            9 ->欧冠
                          113 -》德国杯
                            0 -》其他
                            */
                           };
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:parame action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *curDataAraay=[responseObject objectForKey:@"data"];
        for (NSDictionary *dic in curDataAraay) {
            BERFixtureModel *model=[[BERFixtureModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.fixtureTabView reloadData];
        NSLog(@"赛程数据加载成功");
        if ([self.delegate respondsToSelector:@selector(hideLoadView)]) {
            [self.delegate hideLoadView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"赛程数据加载失败");
        if ([self.delegate respondsToSelector:@selector(hideLoadView)]) {
            [self.delegate hideLoadView];
        }
    }];
    
}
-(BOOL)loadDataWith:(NSString *)leadID
{
    self.data1Array=[[NSMutableArray alloc]init];
    NSDictionary *parame=@{
                           @"league_id" : leadID,
                           @"limit"     : @"0"
                           /*
                            leadgue_id:
                            5 ->德甲
                            9 ->欧冠
                            113 -》德国杯
                            0 -》其他
                            */
                           };
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:parame action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *curDataAraay=[responseObject objectForKey:@"data"];
        for (NSDictionary *dic in curDataAraay) {
            BERFixtureModel *model=[[BERFixtureModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.data1Array addObject:model];
        }
        [self.fixtureTabView reloadData];
       
        NSLog(@"赛程数据加载成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"赛程数据加载失败");
    }];
    if (self.data1Array.count>0) {
        return NO;
    }
    return YES;
}
-(void)reloadData
{
    [self.fixtureTabView reloadData];
}
@end
