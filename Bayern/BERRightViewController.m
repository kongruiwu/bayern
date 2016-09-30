//
//  BERRightViewController.m
//  Bayern
//
//  Created by wusicong on 15/6/8.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERRightViewController.h"
#import "LeftRootScoreTableViewCell.h"
#import "RootScoreHeadCell.h"
#import "RootRihtTabViewCell.h"
#import "TeamRankModel.h"
@interface BERRightViewController () <UITableViewDataSource, UITableViewDelegate, RootRihtTabViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray * teamRanks;
@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation BERRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.contentArray = [NSMutableArray array];
    self.teamRanks = [NSMutableArray new];
    [self.view addSubview:self.listTableView];
    
    [self request];
    [self teamRankRequest];
}


#pragma mark - Request Method

- (void)request {
    __block NSMutableArray *listDataArray = self.contentArray;
    __block UITableView *tableView = self.listTableView;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"match"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"lastSchedules"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            
            NSArray *dataArr = dic[@"data"];
            
            if (dataArr.count > 0) {
                
                for (int i = 0; i < dataArr.count; i ++) {
                    HomeGameModel * model = [[HomeGameModel alloc]initWithDictionary:dataArr[i]];
                    [listDataArray addObject:model];
                }
                
            }
            [tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)teamRankRequest{
    __weak BERRightViewController * weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BERApiProxy urlWithAction:@"match"] parameters:[BERApiProxy paramsWithDataDic:@{} action:@"right_team_rank"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] integerValue] == 0) {
            NSArray *dataArr = dic[@"data"];
            if (dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i ++) {
                    TeamRankModel * model = [[TeamRankModel alloc]initWithDictionary:dataArr[i]];
                    [weakSelf.teamRanks addObject:model];
                }
            }
            [weakSelf.listTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return Anno750(120);
    }
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString * title = @"比赛中心";
    if (section == 1) {
        title = @"积分榜";
    }
    UIView * headView = [Factory creatViewWithColor:[UIColor clearColor]];
    headView.frame = CGRectMake(0, 0, SCREENWIDTH * 0.75, 64);
    UILabel * titleLabel = [Factory creatLabelWithTitle:title textColor:COLOR_MAIN_RED
                                               textFont:font750(30) textAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont boldSystemFontOfSize:font750(32)];
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(10));
    }];
    UIView * line = [Factory creatViewWithColor:COLOR_MAIN_RED];
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        UIView * footer = [Factory creatViewWithColor:[UIColor clearColor]];
        UIButton * button = [Factory creatButtonWithTitle:@"查看完整积分榜"
                                                 textFont:Anno750(30) titleColor:COLOR_MAIN_RED backGroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(goGameScoreView) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = Anno750(30);
        button.layer.borderColor = COLOR_MAIN_RED.CGColor;
        button.layer.borderWidth = 1.0f;
        [footer addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(@0);
            make.height.equalTo(@(Anno750(60)));
            make.width.equalTo(@(Anno750(340)));
        }];
        
        footer.frame = CGRectMake(0, 0, Anno750(650), Anno750(90));
        return footer;
    }
    return nil;
}
- (void)goGameScoreView{
    [[[AppDelegate sharedInstance] mainViewController] setCenterVCWithIndex:6];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.contentArray.count;
    }
    return self.teamRanks.count +1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return Anno750(400);
    }else{
        return Anno750(100);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *cellStr = @"cell";
        
        RootRihtTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[RootRihtTabViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        HomeGameModel * model = self.contentArray[indexPath.row];
        [cell updateWithHomeGameModel:model];
        cell.delegate = self;
        return cell;
    }
    static NSString * scorecell=  @"scorecell";
    static NSString * headCell = @"headCell";
    if (indexPath.row == 0) {
        RootScoreHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:headCell];
        if (cell == nil) {
            cell = [[RootScoreHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headCell];
        }
        return cell;
    }
    LeftRootScoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:scorecell];
    if (cell == nil) {
        cell = [[LeftRootScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scorecell];
    }
    TeamRankModel * model = self.teamRanks[indexPath.row - 1];
    [cell updateWithTeamRankModel:model];
    return cell;
}

#pragma mark - 
- (void)RootRightCellPicBtnClick:(UIButton *)btn{
    UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath * index = [self.listTableView indexPathForCell:cell];
    HomeGameModel * model = self.contentArray[index.row];
    NSString *picLink = [NSString stringWithFormat:@"%@",model.album_link];
    NSString *shareTitle = model.league_title;
    [BERShareModel sharedInstance].shareTitle=shareTitle;
    [BERShareModel sharedInstance].shareID=picLink;
    [BERShareModel sharedInstance].shareUrl=[[BERShareModel sharedInstance]getShareURL:NO];
    [[AppDelegate sharedInstance] pushPicWithPicLink:picLink andTitle:shareTitle];
}
- (void)RootRightCellNewsBtnClick:(UIButton *)btn{
    UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath * index = [self.listTableView indexPathForCell:cell];
    HomeGameModel * model = self.contentArray[index.row];
    NSString *newsLink = [NSString stringWithFormat:@"%@",model.news_link];
    
    NSString *shareTitle = model.league_title;
    if (shareTitle.length == 0 || shareTitle == nil) {
        shareTitle = @"";
    }
    [BERShareModel sharedInstance].shareTitle = shareTitle;
    [BERShareModel sharedInstance].shareID = newsLink;
    [[AppDelegate sharedInstance] pushNewsWithNewsLink:newsLink];

}

#pragma mark - Getter Method

- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(Anno750(100), 0, WindowWidth - Anno750(100), WindowHeight) style:UITableViewStyleGrouped];
        _listTableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _listTableView;
}

@end
