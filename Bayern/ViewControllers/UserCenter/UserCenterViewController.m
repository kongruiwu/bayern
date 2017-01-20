//
//  UserCenterViewController.m
//  Bayern
//
//  Created by 吴孔锐 on 16/9/3.
//  Copyright © 2016年 Wusicong. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterCell.h"
#import "UserCenterHeadview.h"
#import "ChooseProViewController.h"
#import "ChangeGenerViewController.h"
#import "ChangeBirthViewController.h"
@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) UserCenterHeadview * headView;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSArray * descStrs;

@end

@implementation UserCenterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.descStrs = @[[UserInfo defaultInfo].gender,[UserInfo defaultInfo].birth,[UserInfo defaultInfo].area,[UserInfo defaultInfo].email];
    [self.tabview reloadData];
    [self getUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavAlpha];
    [self creatUI];
    if (self.isPush) {
        [self drawBackButton];
    }else{
        [self drawMainTabItem];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setNavUnAlpha];
}
- (void)creatUI{
    self.titles = @[@"性    别",@"生    日",@"所 在 地",@"电子邮箱"];
    self.images = @[@"porfile_sex",@"porfile_birthday",@"porfile_location",@"porfile_email"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabview = [Factory creatTabbleViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    self.headView = [[UserCenterHeadview alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, Anno750(460)+ 64)];
    [self.headView updateUI];
    self.tabview.tableHeaderView = self.headView;
    
    [self creatFooterView];
    

    
}


/*******tabview delegate******/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Anno750(20);
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, Anno750(20))];
        view.backgroundColor = COLOR_BACKGROUND;
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"UserCenterCell";
    UserCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row == 3) {
        [cell hideArrowIcon:YES];
    }
    [cell configUIwithTitle:self.titles[indexPath.row] imageName:self.images[indexPath.row] descText:self.descStrs[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[ChangeGenerViewController new] animated:YES];
    }else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[ChooseProViewController new] animated:YES];
    }else if(indexPath.row == 1){
        [self.navigationController pushViewController:[ChangeBirthViewController new] animated:YES];
    }
    
}
- (void)creatFooterView{
    UIView * footer = [Factory creatViewWithColor:[UIColor whiteColor]];
    footer.frame = CGRectMake(0, 0, SCREENWIDTH, Anno750(88 + 140));
    
    UIButton * button = [Factory creatButtonWithTitle:@"退出登陆" textFont:font750(28)
                                           titleColor:COLOR_CONTENT_GRAY_9 backGroundColor:[UIColor clearColor]];
    [footer addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(590)));
        make.height.equalTo(@(Anno750(88)));
    }];
    [button addTarget:self action:@selector(userLogOut) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = Anno750(44);
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = COLOR_LINECOLOR.CGColor;
    self.tabview.tableFooterView = footer;
}



/***网络请求***/
- (void)userLogOut{
    NSDictionary * params = @{};
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger GET:[BERApiProxy urlWithAction:@"user"] parameters:[BERApiProxy paramsWithDataDic:params action:@"logout"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([dic[@"code"] intValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userID"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UserInfo defaultInfo].uid = nil;
            if (self.isPush) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[AppDelegate sharedInstance].mainViewController showLeftPanelAnimated:YES];
                [[AppDelegate sharedInstance].mainViewController.leftVC updateHeadCell];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[AppDelegate sharedInstance].mainViewController setCenterVCWithIndex:1];
                });
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)getUserInfo{
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (userID && userID.intValue>0) {
        NSDictionary * params = @{@"uid":userID};
        AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
        [manger GET:[BERApiProxy urlWithAction:@"user"] parameters:[BERApiProxy paramsWithDataDic:params action:@"profile"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic=(NSDictionary *)responseObject;
            if ([dic[@"code"] intValue] == 0) {
                NSDictionary * data = dic[@"data"];
                [[UserInfo defaultInfo] setKeyValueForKeyWithDictionary:data];
            }
            self.descStrs = @[[UserInfo defaultInfo].gender,[UserInfo defaultInfo].birth,[UserInfo defaultInfo].area,[UserInfo defaultInfo].email];
            [self.tabview reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}
@end
