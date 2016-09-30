//
//  ScheduDetailViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/22.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "ScheduDetailViewController.h"
#import "HomeGameModel.h"
#import "RootRihtTabViewCell.h"
#import "YTImageBrowerController.h"
#import "BERNewsDetailViewController.h"
@interface ScheduDetailViewController()<UITableViewDelegate, UITableViewDataSource,RootRihtTabViewCellDelegate>
@property (nonatomic,strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end


@implementation ScheduDetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self creatUI];
    [self requestData];
}
- (void)creatUI{
    self.dataArray = [NSMutableArray new];
    
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH - Anno750(80) - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(400);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"RootRihtTabViewCell";
    RootRihtTabViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[RootRihtTabViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    HomeGameModel * model = self.dataArray[indexPath.row];
    [cell scheduUpdateWithHomeGameModel:model];
    cell.delegate = self;
    return cell;
}
-(NSString *)getActionName
{
    return @"schedules";
}
-(NSString *)getMainActionName
{
    return @"match";
}


- (void)requestData{
    [self.view showLoadingActivity:YES];
    NSString * leadgue_id = @"5";
    switch (self.scheduType) {
        case ScheduTypeBundesliga:
            break;
        case ScheduTypeChampions:
        {
            leadgue_id = @"9";
        }
            break;
        case ScheduTypeGermany:
        {
            leadgue_id = @"113";
        }
            break;
        case ScheduTypeEles:
        {
            leadgue_id = @"0";
        }
            break;
        default:
            break;
    }
    NSDictionary *parame=@{
                           @"league_id" : leadgue_id,
                           @"limit"     : @"0"
                           };
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    __weak ScheduDetailViewController * weakSelf = self;
    [manager GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:parame action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            NSArray *dataArr = dic[@"data"];
            if (dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i ++) {
                    HomeGameModel * model = [[HomeGameModel alloc]initWithDictionary:dataArr[i]];
                    [weakSelf.dataArray addObject:model];
                }
            }
            [weakSelf.tabview reloadData];
        }
        [weakSelf.view hideLoadWithAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.view hideLoadWithAnimated:YES];
    }];
    
}
- (void)RootRightCellPicBtnClick:(UIButton *)btn{
    UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeGameModel * model = self.dataArray[index.row];
    NSString *picLink = [NSString stringWithFormat:@"%@",model.album_link];
    NSString *shareTitle = model.league_title;
    [BERShareModel sharedInstance].shareTitle=shareTitle;
    [BERShareModel sharedInstance].shareID=picLink;
    [BERShareModel sharedInstance].shareUrl=[[BERShareModel sharedInstance]getShareURL:NO];
    YTImageBrowerController * vc = [[YTImageBrowerController alloc]init];
    vc.news_id = picLink;
    vc.titleName = shareTitle;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)RootRightCellNewsBtnClick:(UIButton *)btn{
    UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeGameModel * model = self.dataArray[index.row];
    NSString *newsLink = [NSString stringWithFormat:@"%@",model.news_link];
    
    NSString *shareTitle = model.league_title;
    if (shareTitle.length == 0 || shareTitle == nil) {
        shareTitle = @"";
    }
    [BERShareModel sharedInstance].shareTitle = shareTitle;
    [BERShareModel sharedInstance].shareID = newsLink;
    BERNewsDetailViewController *nv = [[BERNewsDetailViewController alloc] init];
    nv.news_id = newsLink;
    nv.needFetchNewsData = YES;
    [self.navigationController pushViewController:nv animated:YES];
}
@end
