//
//  BERDetailTeamViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 15/7/28.
//  Copyright (c) 2015年 Wusicong. All rights reserved.
//

#import "BERDetailTeamViewController.h"
#import "BERHeadFile.h"
#import "BERTeamerModel.h"
#import "TeamerDetailTableViewCell.h"
#import "TeamerDeatilHeadView.h"
@interface BERDetailTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BERTeamerModel * model;
@property (nonatomic, strong) TeamerDeatilHeadView * header;
@end

@implementation BERDetailTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view showLoadWithAnimated:YES];
    
    [self drawBackButton];
    [self drawTitle:@"球队"];
    [self creatUI];
    [self loadData];
    
}
- (void)creatUI{
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    TeamerDeatilHeadView * header = [[TeamerDeatilHeadView alloc]init];
    header.frame = CGRectMake(0, 0, SCREENWIDTH, Anno750(480));
    self.header = header;
    self.tabview.tableHeaderView = header;
}
- (void)creatFooter{
    if (self.model.desc && self.model.desc.length>0) {
        NSString * title = @"教练介绍";
        if (self.isTeamer) {
            title = @"球员介绍";
        }
        UIView * footerView = [Factory creatViewWithColor:[UIColor whiteColor]];
        CGSize size = [Factory getSize:self.model.desc maxSize:CGSizeMake(SCREENWIDTH - Anno750(80), 99999) font:[UIFont boldSystemFontOfSize:font750(26)]];
        footerView.frame = CGRectMake(0, 0, SCREENWIDTH, 30 + Anno750(40)+ size.height);
        UILabel * titleLabel = [Factory creatLabelWithTitle:title textColor:[UIColor blackColor]
                                                   textFont:font750(28) textAlignment:NSTextAlignmentLeft];
        titleLabel.font = [UIFont boldSystemFontOfSize:font750(28)];
        [footerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(Anno750(60)));
            make.height.equalTo(@30);
        }];
        UIView * lineView = [Factory creatViewWithColor:UIColorFromRGB(0x111111)];
        [footerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(20)));
            make.right.equalTo(@(-Anno750(20)));
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.equalTo(@1);
        }];
        
        UILabel * descLabel = [Factory creatLabelWithTitle:self.model.desc textColor:COLOR_CONTENT_GRAY_9
                                                  textFont:font750(26) textAlignment:NSTextAlignmentLeft];
        descLabel.numberOfLines = 0;
        [footerView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(60)));
            make.right.equalTo(@(-Anno750(20)));
            make.top.equalTo(lineView.mas_bottom).offset(Anno750(20));
            make.bottom.equalTo(@(-Anno750(20)));
        }];
        self.tabview.tableFooterView = footerView;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.teamerTitles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(60);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"TeamerDetailTableViewCell";
    TeamerDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TeamerDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell updateWithTitle:self.model.teamerTitles[indexPath.row] descs:self.model.teamerDescs[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


-(void)loadData
{
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:[self getMainActionName]] parameters:[BERApiProxy paramsWithDataDic:[self getParamWithIsTeamer:self.isTeamer] action:[self getActionName]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[responseObject objectForKey:@"data"];
        
        BERTeamerModel *model=[[BERTeamerModel alloc]initWithDictionary:dic];
        self.model = model;
        [self.header updateWithModel:self.model];
        [self.tabview reloadData];
        [self.view hideLoadWithAnimated:YES];
        NSLog(@"球员数据解析成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"球员数据解析失败");
        [self.view hideLoadWithAnimated:YES];
    }];
}
-(NSDictionary *)getParamWithIsTeamer:(BOOL)rec
{
    if (rec) {
        NSDictionary *param=@{
                              @"id":self.teamerID,
                              @"is_coach":@"0"
                              };
        return param;
    }
    NSDictionary *param=@{
                          @"id":self.teamerID,
                          @"is_coach":@"1"
                          };
    return param;
}
-(NSString *)getActionName
{
    return @"get_detail";
}
-(NSString *)getMainActionName
{
    return @"team";
}




@end
